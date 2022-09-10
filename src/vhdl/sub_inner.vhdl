library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity sub_inner is
    port (
        num_a : in std_logic_vector(31 downto 0);
        num_b : in std_logic_vector(31 downto 0);
        num_out : out std_logic_vector(31 downto 0);
        exc : out std_logic_vector(4 downto 0)
    );
end sub_inner;

architecture arch_sub_inner of sub_inner is
    constant zero : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
    signal sign_out : std_logic;
    signal exp_a, exp_b : unsigned(7 downto 0);
    signal exp_max : unsigned(7 downto 0);
    signal mant_a, mant_b : unsigned(24 downto 0);
    signal mant_a_impl, mant_b_impl : unsigned(24 downto 0);
    signal mant_b_comp : unsigned(24 downto 0);
    signal mant_diff : unsigned(24 downto 0);
    signal mant_diff_comp : unsigned(24 downto 0);
    signal mant_diff_impl : unsigned(23 downto 0);
    signal shift_amt : integer range 0 to 23 := 0;
    signal exp_out : unsigned(7 downto 0);
    signal mant_out : std_logic_vector(23 downto 0);
    signal exp_a_bigger, exp_equal, underflow : boolean;
    signal trimmed_suffix : unsigned(24 downto 0);
    signal underflow_bit, inexact_bit : std_logic;
begin
    s : entity work.shift_amount port map (mant_diff_impl, shift_amt);

    exp_a <= unsigned(num_a(30 downto 23)); -- Exponenten extrahieren
    exp_b <= unsigned(num_b(30 downto 23));
    exp_equal <= exp_a = exp_b;
    exp_a_bigger <= exp_a > exp_b;
    mant_a_impl <= unsigned("01" & num_a(22 downto 0)); -- Mantissen extrahieren und um implizite 1 erweitern
    mant_b_impl <= unsigned("01" & num_b(22 downto 0)); -- da bei der Subtraktion ein Overflow möglich ist, wird vor der 1 eine 0 angehängt
    mant_a <= mant_a_impl when (exp_equal or exp_a_bigger) else (mant_a_impl srl to_integer(exp_b - exp_a)); -- Mantissen auf grössten Exponenten normalisieren
    mant_b <= (mant_b_impl srl to_integer(exp_a - exp_b)) when exp_a_bigger else mant_b_impl;
    trimmed_suffix <= (mant_b_impl sll to_integer(25 + exp_b - exp_a)) when exp_a_bigger else (mant_a_impl sll to_integer(25 + exp_a - exp_b));
    exp_max <= exp_a when exp_a_bigger else exp_b; -- grösster der beiden Exponenten

    mant_b_comp <= (not mant_b) + 1; -- Zweierkomplement von mant_b
    mant_diff <= mant_a + mant_b_comp; -- Differenz von mant_a und mant_b
    sign_out <= num_a(31) xor mant_diff(24); -- Vorzeichen des Ergebnisses ist das von num_a, falls Differenz der Mantissen positiv; ansonsten wird invertiert

    mant_diff_comp <= (not mant_diff) + 1; -- Zweierkomplement der Differenz
    mant_diff_impl <=   mant_diff_comp(23 downto 0) when mant_diff(24) = '1' else -- falls Differenz negativ -> Zweierkomplement nutzen und auf eine Stelle vor dem Komma kürzen
                        mant_diff(23 downto 0); -- sonst Differenz unverändert nutzen und auf eine Stelle vor dem Komma kürzen
    
    exp_out <= exp_max - shift_amt; -- Exponent normalisieren
    mant_out <= std_logic_vector(mant_diff_impl sll shift_amt); -- Mantisse normalisieren
    underflow <= mant_diff_impl = "0" or exp_max <= shift_amt;

    num_out <=  zero        when (underflow) else -- falls Mantisse null oder Exponent zu klein -> null
                sign_out & std_logic_vector(exp_out) & mant_out(22 downto 0); -- sonst Ergebnis zusammensetzen; implizite 1 wird entfernt

    underflow_bit <= '1' when underflow else '0';
    inexact_bit <= '1' when trimmed_suffix /= "0" else '0';
    exc <= "000" & underflow_bit & inexact_bit;
end architecture;