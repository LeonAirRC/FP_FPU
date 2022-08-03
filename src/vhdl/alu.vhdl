library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity alu is
    port (
        op : in std_logic_vector(1 downto 0);
        num_a : in std_logic_vector(31 downto 0);
        num_b : in std_logic_vector(31 downto 0);
        num_out : out std_logic_vector(31 downto 0)
    );
end alu;

architecture arch_alu of alu is
    signal add_output, sub_output, mul_output : std_logic_vector(31 downto 0);
begin
    a: entity work.add port map (num_a, num_b, add_output);
    s: entity work.sub port map (num_a, num_b, sub_output);
    m: entity work.mul_outer port map (num_a, num_b, mul_output);

    num_out <=  add_output when (op = "00") else
                sub_output when (op = "01") else
                mul_output;
end arch_alu;