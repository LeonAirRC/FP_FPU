library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity add is
    port (
        num_a : in std_logic_vector(31 downto 0);
        num_b : in std_logic_vector(31 downto 0);
        output: out std_logic_vector(31 downto 0);
    );
end add;

architecture arch_add of add is
    signal add_num_a, add_num_b, add_output std_logic_vector(31 downto 0);
    signal sub_num_a, sub_num_b, sub_output std_logic_vector(31 downto 0);
begin
    a: entity work.add_inner port map (add_num_a, add_num_b, add_output);
    s: entity work.sub_inner port map (sub_num_a, sub_num_b, sub_output);

    if num_a(31) ='0' xor num_b(31) = '0' then
        sub_num_a <= num_a;
        sub_num_b <= num_a(31) & num_b(30 downto 1);
        output <= sub_output;
    else
        add_num_a <= num_a;
        add_num_b <= num_b;
        output <= add_output;
    end if;
end arch_add;