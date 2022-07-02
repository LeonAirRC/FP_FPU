library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mul_outer is
    port (
        num_a : in std_logic_vector(31 downto 0);
        num_b : in std_logic_vector(31 downto 0);
        num_out : out std_logic_vector(31 downto 0)
    );
end mul_outer;

architecture arch_mul_outer of mul_outer is
    constant zero : std_logic_vector := "0000000000000000000000000000000";
    constant infty : std_logic_vector := "1111111100000000000000000000000";
    constant nan : std_logic_vector := "-1111111111111111111111111111111";

    signal mul_num_a, mul_num_b, mul_output : std_logic_vector(31 downto 0);
begin
    a : entity work.mul_inner port map (mul_num_a, mul_num_b, mul_output);
    if num_a = nan or num_b = nan then
        num_out <= nan;
    elsif num_a(30 downto 0) = infty then
        if num_b(30 downto 0) = zero then
            num_out <= nan;
        else
            num_out <= (num_a(31) xor num_b(31)) & infty;
        end if;
    elsif num_b(30 downto 0) = infty then
        if num_a(30 downto 0) = zero then
            num_out <= nan;
        else
            num_out <= (num_a(31) xor num_b(31)) & infty;
        end if;
    elsif num_a(30 downto 0) = zero or num_b(30 downto 0) = zero then
        num_out <= (num_a(31) xor num_b(31)) & zero;
    else
        mul_num_a <= num_a;
        mul_num_b <= num_b;
        num_out <= mul_output;
    end if;
end architecture;