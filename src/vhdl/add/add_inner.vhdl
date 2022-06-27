library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity add_inner is
    port (
        num_a : in std_logic_vector(31 downto 0);
        num_b : in std_logic_vector(31 downto 0);
        output: out std_logic_vector(31 downto 0);
    );
end add_inner;

architecture arch_add_inner of add_inner is
    signal exp_a : integer range 0 to 255;
    signal exp_b : integer range 0 to 255;
    signal exp_diff : integer range 0 to 255;
    signal mant_a : integer range 0 to 16777215;
    signal mant_b : integer range 0 to 16777215;
    signal mant_out : integer range 0 to 33554431;
begin
    exp_a <= to_integer(unsigned(num_a(30 downto 23)));
    exp_b <= to_integer(unsigned(num_b(30 downto 23)));
    if exp_a > exp_b then
        exp_diff <= exp_a - exp_b;
        mant_a <= to_integer(unsigned('1' & num_a(22 downto 0)));
        mant_b <= to_integer(unsigned(('1' & num_b(22 downto 0)) srl exp_diff));
    elsif exp_b > exp_a then
        exp_diff <= exp_b - exp_a;
        mant_b <= to_integer(unsigned('1' & num_b(22 downto 0)));
        mant_a <= to_integer(unsigned(('1' & num_a(22 downto 0)) srl exp_diff));
    else
        mant_a <= to_integer(unsigned('1' & num_a(22 downto 0)));
        mant_b <= to_integer(unsigned('1' & num_b(22 downto 0)));
    end if;
end arch_add_inner;