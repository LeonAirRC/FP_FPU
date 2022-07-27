library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity sub_outer is
    port (
        num_a : in std_logic_vector(31 downto 0);
        num_b : in std_logic_vector(31 downto 0);
        num_out : out std_logic_vector(31 downto 0)
    );
end sub_outer;

architecture arch_sub_outer of sub_outer is
    constant zero : std_logic_vector := "0000000000000000000000000000000";
    constant infty : std_logic_vector := "1111111100000000000000000000000";
    constant nan : std_logic_vector := "-1111111111111111111111111111111";

    signal sub_num_a, sub_num_b, sub_output : std_logic_vector(31 downto 0);
begin
    a : entity work.sub_inner port map (sub_num_a, sub_num_b, sub_output);
    process( num_a, num_b )
    begin
        if num_a = nan or num_b = nan then
            num_out <= nan;
        elsif num_a(30 downto 0) = infty then
            if num_b(30 downto 0) = infty then
                num_out <= nan;
            else
                num_out <= num_a;
            end if;
        elsif num_b(30 downto 0) = infty then
            num_out <= (not num_b(31)) & num_b(30 downto 0);
        elsif num_b(30 downto 0) = zero then
            num_out <= num_a;
        elsif num_a(30 downto 0) = zero then
            num_out <= (not num_b(31)) & num_b(30 downto 0);
        elsif num_a = num_b then
            num_out <= "0" & zero;
        else
            sub_num_a <= num_a;
            sub_num_b <= num_b;
            num_out <= sub_output;
        end if;
    end process;
end architecture;