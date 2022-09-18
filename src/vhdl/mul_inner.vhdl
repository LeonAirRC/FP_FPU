-- author: Leon Bartmann

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mul_inner is
    port (
        num_a : in std_logic_vector(31 downto 0);
        num_b : in std_logic_vector(31 downto 0);
        rnd : in std_logic_vector(2 downto 0);
        num_out : out std_logic_vector(31 downto 0);
        exc : out std_logic_vector(4 downto 0)
    );
end mul_inner;

architecture arch_mul_inner of mul_inner is
    constant zero : std_logic_vector(30 downto 0) := "0000000000000000000000000000000";
    constant infty : std_logic_vector(30 downto 0) := "1111111100000000000000000000000";

    signal sig_out : std_logic;
    signal exp_a, exp_b : unsigned(9 downto 0);
    signal exp_sum : signed(9 downto 0);
    signal mant_a, mant_b : unsigned(23 downto 0);
    signal mant_prod : unsigned(47 downto 0);
    signal mant_prod_rnd : unsigned(24 downto 0);
    signal mant_out : unsigned(22 downto 0);
    signal exp_out : signed(9 downto 0);
    signal mant_prod_overflow, exp_out_gt254, exp_out_lt0, overflow, underflow : boolean;
    signal overflow_bit, underflow_bit, inexact_bit : std_logic;
begin
    sig_out <= num_a(31) xor num_b(31); -- Vorzeichenbit des Ergebnisses
    exp_a <= "00" & unsigned(num_a(30 downto 23)); -- Exponenten extrahieren; zwei 0 werden angehängt, um den benötigten Zahlenbereich -127 bis 508 abzudecken
    exp_b <= "00" & unsigned(num_b(30 downto 23));
    exp_sum <= signed(exp_a + exp_b) - 127; -- Exponenten addieren und überflüssiges Bias abziehen
    mant_a <= unsigned("1" & num_a(22 downto 0)); -- Mantissen mit impliziter 1 extrahieren
    mant_b <= unsigned("1" & num_b(22 downto 0));
    mant_prod <= mant_a * mant_b; -- Multiplikation der Mantissen
    mant_prod_rnd <=    mant_prod(47 downto 23) + 1 -- resultierende Mantisse inklusive zwei Stellen vor dem Komma aus Produkt extrahieren; aufrunden, falls:
                            when    (rnd = "000" and mant_prod(22) = '1' and (mant_prod(21 downto 0) /= "0" or mant_prod(23) = '1'))
                            or      (rnd = "001" and mant_prod(22) = '1')
                            or      (rnd = "011" and sig_out = '0' and mant_prod(22 downto 0) /= "0")
                            or      (rnd = "100" and sig_out = '1' and mant_prod(22 downto 0) /= "0")
                        else mant_prod(47 downto 23);
    mant_prod_overflow <= mant_prod_rnd(24) = '1'; -- ist ein Overflow aufgetreten?

    exp_out <= exp_sum + 1 when mant_prod_overflow else exp_sum; -- falls Overflow: Exponent erhöhen
    mant_out <= mant_prod_rnd(23 downto 1) when mant_prod_overflow else mant_prod_rnd(22 downto 0); -- falls Overflow: Mantisse 'eine Stelle nach rechts verschieben'; implizite 1 wird entfernt
    exp_out_gt254 <= exp_out(8) = '1' and exp_out(7 downto 0) = "11111111"; -- ist Exponent grösser als 254?
    exp_out_lt0 <= exp_out(9) = '1'; -- ist Exponent negativ?
    overflow <= exp_out_gt254 or (exp_out = 254 and mant_prod_overflow);
    underflow <= exp_out_lt0 or (not mant_prod_overflow and exp_out = 0);

    num_out <=  sig_out & infty    when overflow    else                                        -- Exponent zu gross oder Exponent maximal und Overflow aufgetreten -> unendlich
                sig_out & zero     when underflow   else                                        -- Exponent negativ oder kein Overflow und Exponent ist 0 -> null
                sig_out & std_logic_vector(exp_out(7 downto 0)) & std_logic_vector(mant_out);   -- kein Sonderfall -> Ergebnis zusammensetzen

    overflow_bit <= '1' when overflow else '0';
    underflow_bit <= '1' when underflow else '0';
    inexact_bit <= '1' when (mant_prod(22 downto 0) /= "0" or (mant_prod_overflow and mant_prod_rnd(0) = '1')) else '0';
    exc <= "00" & overflow_bit & underflow_bit & inexact_bit;
end architecture;