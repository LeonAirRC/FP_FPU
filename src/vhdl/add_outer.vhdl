library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity add_outer is
    port (
        num_a : in std_logic_vector(31 downto 0);
        num_b : in std_logic_vector(31 downto 0);
        num_out : out std_logic_vector(31 downto 0)
    );
end add_outer;

architecture arch_add_outer of add_outer is
    constant zero : std_logic_vector(30 downto 0) := "0000000000000000000000000000000";
    constant infty : std_logic_vector(30 downto 0) := "1111111100000000000000000000000";
    constant nan : std_logic_vector(31 downto 0) := "-1111111111111111111111111111111";

    signal add_output : std_logic_vector(31 downto 0);
    signal a_nan, b_nan, a_infty, b_infty, a_zero, b_zero : boolean;
begin
    a : entity work.add_inner port map (num_a, num_b, add_output);
    
    a_nan <= num_a(30 downto 23) = "11111111" and num_a(22 downto 0) /= "0";
    b_nan <= num_b(30 downto 23) = "11111111" and num_b(22 downto 0) /= "0";
    a_infty <= num_a(30 downto 0) = infty;
    b_infty <= num_b(30 downto 0) = infty;
    a_zero <= num_a(30 downto 0) = zero;
    b_zero <= num_b(30 downto 0) = zero;
    num_out <=  nan         when (a_nan or b_nan or (a_infty and b_infty)) else -- Sonderfälle abfangen
                num_a       when (a_infty or b_zero) else
                num_b       when (b_infty or a_zero) else
                add_output;
end architecture;