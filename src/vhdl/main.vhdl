library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity main is
    port (
        op : in std_logic_vector(1 downto 0);
        num_a : in std_logic_vector(31 downto 0);
        num_b : in std_logic_vector(31 downto 0);
        num_out : out std_logic_vector(31 downto 0);
    );
end main;

architecture arch_main of main is
    signal add_num_a, add_num_b, add_output : std_logic_vector(31 downto 0);
    signal sub_num_a, sub_num_b, sub_output : std_logic_vector(31 downto 0);
    signal mul_num_a, mul_num_b, mul_output : std_logic_vector(31 downto 0);
begin
    a: entity work.add port map (add_num_a, add_num_b, add_output);
    s: entity work.sub port map (sub_num_a, sub_num_b, sub_output);
    m: entity work.mul port map (mul_num_a, mul_num_b, mul_output);

    if op = "00" then
        add_num_a <= num_a;
        add_num_b <= num_b;
        num_out <= add_output;
    elsif op = "01" then
        sub_num_a <= num_a;
        sub_num_b <= num_b;
        num_out <= sub_output;
    elsif op = "10" then
        mul_num_a <= num_a;
        mul_num_b <= num_b;
        num_out <= mul_output;
    end if;
end arch_main;