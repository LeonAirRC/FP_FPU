-- author: Leon Bartmann

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity sub_outer is
    port (
        num_a : in std_logic_vector(31 downto 0);
        num_b : in std_logic_vector(31 downto 0);
        rnd : in std_logic_vector(2 downto 0);
        num_out : out std_logic_vector(31 downto 0);
        exc : out std_logic_vector(4 downto 0)
    );
end sub_outer;

architecture arch_sub_outer of sub_outer is
    constant zero : std_logic_vector(30 downto 0) := "0000000000000000000000000000000";
    constant infty : std_logic_vector(30 downto 0) := "1111111100000000000000000000000";
    constant nan : std_logic_vector(31 downto 0) := "-1111111111111111111111111111111";

    signal sub_output : std_logic_vector(31 downto 0);
    signal a_nan, b_nan, a_infty, b_infty, a_zero, b_zero, equal : boolean;
    signal sub_exc : std_logic_vector(4 downto 0);
begin
    a : entity work.sub_inner port map (num_a, num_b, rnd, sub_output, sub_exc);

    a_nan <= num_a(30 downto 23) = "11111111" and num_a(22 downto 0) /= "0";
    b_nan <= num_b(30 downto 23) = "11111111" and num_b(22 downto 0) /= "0";
    a_infty <= num_a(30 downto 0) = infty;
    b_infty <= num_b(30 downto 0) = infty;
    a_zero <= num_a(30 downto 0) = zero;
    b_zero <= num_b(30 downto 0) = zero;
    equal <= num_a = num_b;
    num_out <=  nan                                     when (a_nan or b_nan or (a_infty and b_infty)) else -- Sonderfälle abfangen
                num_a                                   when (a_infty or b_zero) else
                num_b                                   when (b_infty or a_zero) else
                (not num_b(31)) & num_b(30 downto 0)    when (b_infty or a_zero) else                       -- -(num_b), falls b unendlich oder a null
                ("0" & zero)                            when (equal) else                           -- null, falls num_a = num_b
                sub_output;
    exc <=  "00000" when (a_nan or b_nan or a_infty or b_infty or a_zero or b_zero or equal) else
            sub_exc;
end architecture;