library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity add_inner is
    port (
        num_a : in std_logic_vector(31 downto 0);
        num_b : in std_logic_vector(31 downto 0);
        mum_out : out std_logic_vector(31 downto 0);
    );
end add_inner;

architecture arch_add_inner of add_inner is
    constant infty : std_logic_vector := '1111111100000000000000000000000';

    signal exp_a : integer range 0 to 255;
    signal exp_b : integer range 0 to 255;
    signal exp_diff : integer range 0 to 255;
    signal exp_max : integer range 0 to 255;
    signal mant_a : integer range 0 to 16777215;
    signal mant_b : integer range 0 to 16777215;
    signal mant_out : integer range 0 to 33554431;
    signal mant_out_vec : std_logic_vector(24 downto 0);
    signal exp_out : std_logic_vector(7 downto 0);
begin
    exp_a <= to_integer(unsigned(num_a(30 downto 23)));
    exp_b <= to_integer(unsigned(num_b(30 downto 23)));
    if exp_a > exp_b then
        exp_diff <= exp_a - exp_b;
        mant_a <= to_integer(unsigned('1' & num_a(22 downto 0)));
        mant_b <= to_integer(unsigned(('1' & num_b(22 downto 0)) srl exp_diff));
        exp_max <= exp_a;
    elsif exp_b > exp_a then
        exp_diff <= exp_b - exp_a;
        mant_a <= to_integer(unsigned(('1' & num_a(22 downto 0)) srl exp_diff));
        mant_b <= to_integer(unsigned('1' & num_b(22 downto 0)));
        exp_max <= exp_b;
    else
        mant_a <= to_integer(unsigned('1' & num_a(22 downto 0)));
        mant_b <= to_integer(unsigned('1' & num_b(22 downto 0)));
        exp_max <= exp_a;
    end if;

    mant_out <= mant_a + mant_b;
    mant_out_vec <= std_logic_vector(to_unsigned(mant_out));

    if mant_out_vec(24) then
        if exp_max = 254 then
            mum_out <= num_a(31) & infty;
        else
            exp_out <= std_logic_vector(to_unsigned(exp_max + 1));
            mum_out <= num_a(31) & exp_out & mant_out_vec(23 downto 1);
        end if;
    else
        exp_out <= std_logic_vector(to_unsigned(exp_max));
        mum_out <= num_a(31) & exp_out & mant_out_vec(22 downto 0);
    end if;
end arch_add_inner;