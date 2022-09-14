-- author: Leon Bartmann

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity add_inner is
    port (
        num_a : in std_logic_vector(31 downto 0);
        num_b : in std_logic_vector(31 downto 0);
        rnd : in std_logic_vector(2 downto 0);
        num_out : out std_logic_vector(31 downto 0);
        exc : out std_logic_vector(4 downto 0)
    );
end add_inner;

architecture arch_add_inner of add_inner is
    constant infty : std_logic_vector(30 downto 0) := "1111111100000000000000000000000";

    signal exp_a, exp_b, exp_max : unsigned(7 downto 0);
    signal mant_a_impl, mant_b_impl : unsigned(24 downto 0);
    signal mant_a, mant_b : unsigned(24 downto 0);
    signal mant_a_raw, mant_b_raw : unsigned(22 downto 0);
    signal mant_sum : unsigned(24 downto 0);
    signal mant_out : unsigned(24 downto 0);
    signal mant_out_vec : std_logic_vector(24 downto 0);
    signal exp_a_bigger, exp_equal : boolean;
    signal mant_out_overflow, exp_max_limit : boolean;
    signal overflow_bit, inexact_bit : std_logic;
    signal trimmed_suffix : unsigned(22 downto 0);
begin
    exp_a <= unsigned(num_a(30 downto 23)); -- Exponenten extrahieren
    exp_b <= unsigned(num_b(30 downto 23));
    exp_equal <= exp_a = exp_b;
    exp_a_bigger <= exp_a > exp_b;
    mant_a_raw <= unsigned(num_a(22 downto 0));
    mant_b_raw <= unsigned(num_b(22 downto 0));
    mant_a_impl <= unsigned("01" & num_a(22 downto 0)); -- Mantissen extrahieren und um implizite 1 erweitern
    mant_b_impl <= unsigned("01" & num_b(22 downto 0)); -- da bei der Addition ein Overflow möglich ist, wird vor der 1 eine 0 angehängt
    mant_a <= mant_a_impl when (exp_equal or exp_a_bigger) else (mant_a_impl srl to_integer(exp_b - exp_a)); -- Mantissen auf grössten Exponenten normalisieren
    mant_b <= (mant_b_impl srl to_integer(exp_a - exp_b)) when exp_a_bigger else mant_b_impl;
    trimmed_suffix <= (mant_b_raw sll to_integer(23 + exp_b - exp_a)) when exp_a_bigger else (mant_a_raw sll to_integer(23 + exp_a - exp_b));
    exp_max <= exp_a when exp_a_bigger else exp_b; -- grösster der beiden Exponenten

    mant_sum <= mant_a + mant_b; -- Addition der normalisierten Mantissen
    mant_out <= mant_sum + 1 -- aufrunden, falls:
                    when    (rnd = "000" and trimmed_suffix(22) = '1' and (trimmed_suffix(21 downto 0) /= "0" or mant_sum(0) = '1'))
                    or      (rnd = "001" and trimmed_suffix(22) = '1')
                    or      (rnd = "011" and num_a(31) = '0' and trimmed_suffix /= "0")
                    or      (rnd = "100" and num_a(31) = '1' and trimmed_suffix /= "0")
                else mant_sum;

    mant_out_overflow <= mant_out(24) = '1'; -- ist bei der Addition ein Overflow aufgetreten?
    exp_max_limit <= exp_max = 254; -- ist der Exponent der Höchstmögliche?

    num_out <=  (num_a(31) & std_logic_vector(exp_max & mant_out(22 downto 0)))                         when (not mant_out_overflow) else -- kein Overflow -> keine Normalisierung notwendig
                (num_a(31) & std_logic_vector(exp_max + 1) & std_logic_vector(mant_out(23 downto 1)))   when (not exp_max_limit) else     -- Overflow aufgetreten, aber Exponent ist noch nicht maximal -> Normalisierung
                (num_a(31) & infty);                                                                                                      -- Overflow aufgetreten und Exponent ist maximal -> unendlich

    overflow_bit <= '1' when (mant_out_overflow and exp_max_limit) else '0';
    inexact_bit <= '1' when (trimmed_suffix /= "0" or (mant_out_overflow and mant_out(0) = '1')) else '0'; -- Ergebnis ist inexakt, wenn beim Normalisieren eine '1' abgeschnitten wurde
    exc <= "00" & overflow_bit & "0" & inexact_bit;
end arch_add_inner;