library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mul_inner is
    port (
        num_a : in std_logic_vector(31 downto 0);
        num_b : in std_logic_vector(31 downto 0);
        num_out : out std_logic_vector(31 downto 0)
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
    signal mant_prod_vec : std_logic_vector(24 downto 0);
    signal mant_out : std_logic_vector(22 downto 0);
    signal exp_out : signed(9 downto 0);
    signal mant_prod_overflow, exp_out_gt254, exp_out_lt0 : boolean;
begin
    sig_out <= num_a(31) xor num_b(31); -- Vorzeichenbit des Ergebnisses
    exp_a <= "00" & unsigned(num_a(30 downto 23)); -- Exponenten extrahieren; zwei 0 werden angehängt, um den benötigten Zahlenbereich -127 bis 508 abzudecken
    exp_b <= "00" & unsigned(num_b(30 downto 23));
    exp_sum <= signed(exp_a + exp_b) - 127; -- Exponenten addieren und überflüssiges Bias abziehen

    mant_a <= unsigned("1" & num_a(22 downto 0)); -- Mantissen mit impliziter 1 extrahieren
    mant_b <= unsigned("1" & num_b(22 downto 0));
    mant_prod <= mant_a * mant_b; -- Multiplikation der Mantissen
    mant_prod_vec <= std_logic_vector(mant_prod(47 downto 23)); -- resultierende Mantisse inklusive zwei Stellen vor dem Komma aus Produkt extrahieren; es wird immer abgerundet
    mant_prod_overflow <= mant_prod_vec(24) = '1'; -- ist ein Overflow aufgetreten?

    exp_out <= exp_sum + 1 when mant_prod_overflow else exp_sum; -- falls Overflow: Exponent erhöhen
    mant_out <= mant_prod_vec(23 downto 1) when mant_prod_overflow else mant_prod_vec(22 downto 0); -- falls Overflow: Mantisse 'eine Stelle nach rechts verschieben'; implizite 1 wird entfernt
    exp_out_gt254 <= exp_out(8) = '1' and exp_out(7 downto 0) = "11111111"; -- ist Exponent grösser als 254?
    exp_out_lt0 <= exp_out(9) = '1'; -- ist Exponent negativ?

    num_out <=  sig_out & infty    when (exp_out_gt254 or (exp_out = 254 and mant_prod_overflow)) else -- Exponent zu gross oder Exponent maximal und Overflow aufgetreten -> unendlich
                sig_out & zero     when (exp_out_lt0 or (not mant_prod_overflow and exp_out = 0)) else -- Exponent negativ oder kein Overflow und Exponent ist 0 -> null
                sig_out & std_logic_vector(exp_out(7 downto 0)) & mant_out;                            -- kein Sonderfall -> Ergebnis zusammensetzen
end architecture;