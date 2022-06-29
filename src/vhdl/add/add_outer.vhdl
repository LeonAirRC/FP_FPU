library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity add_outer is
    port (
        num_a : in std_logic_vector(31 downto 0);
        num_b : in std_logic_vector(31 downto 0);
        num_out : out std_logic_vector(31 downto 0);
    );
end add_outer;

architecture arch_add_outer of add_outer is
    constant zero : std_logic_vector := "0000000000000000000000000000000";
    constant infty : std_logic_vector := "1111111100000000000000000000000";
    constant nan : std_logic_vector := "-1111111111111111111111111111111";

    signal add_num_a, add_num_b, add_output : std_logic_vector(31 downto 0);
begin
    a : entity work.add_inner port map (add_num_a, add_num_b, add_output);
    if num_a = nan or num_b = nan then
        num_out <= nan;
    elsif num_a(30 downto 0) = infty then
        if num_b(30 downto 0) = infty then
            if num_a(31) = num_b(31) then
                num_out <= num_a;
            else
                num_out <= nan;
            end if;
        else
            num_out <= num_a;
        end if;
    elsif num_b(30 downto 0) = infty then
        num_out <= num_b;
    elsif num_b(30 downto 0) = zero then
        num_out <= num_a;
    elsif num_a(30 downto 0) = zero then
        num_out <= num_b;
    else
        add_num_a <= num_a;
        add_num_b <= num_b;
        num_out <= add_output;
    end if;
end architecture;