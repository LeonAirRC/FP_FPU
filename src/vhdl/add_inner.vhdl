library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity add_inner is
    port (
        num_a : in std_logic_vector(31 downto 0);
        num_b : in std_logic_vector(31 downto 0);
        num_out : out std_logic_vector(31 downto 0)
    );
end add_inner;

architecture arch_add_inner of add_inner is
    constant infty : std_logic_vector := "1111111100000000000000000000000";

    signal exp_a, exp_b, exp_max : unsigned(7 downto 0);
    signal mant_a_impl, mant_b_impl : unsigned(24 downto 0);
    signal mant_a, mant_b : unsigned(24 downto 0);
    signal mant_out : unsigned(24 downto 0);
    signal mant_out_vec : std_logic_vector(24 downto 0);
    signal exp_out : unsigned(7 downto 0);
    signal exp_out_vec : std_logic_vector(7 downto 0);

    signal exp_a_bigger, exp_equal : boolean;
    signal mant_out_overflow, exp_max_limit : boolean;
begin
    exp_a <= unsigned(num_a(30 downto 23));
    exp_b <= unsigned(num_b(30 downto 23));
    exp_equal <= exp_a = exp_b;
    exp_a_bigger <= exp_a > exp_b;
    mant_a_impl <= unsigned("01" & num_a(22 downto 0));
    mant_b_impl <= unsigned("01" & num_b(22 downto 0));
    mant_a <= mant_a_impl when (exp_equal or exp_a_bigger) else (mant_a_impl srl to_integer(exp_b - exp_a));
    mant_b <= (mant_b_impl srl to_integer(exp_a - exp_b)) when exp_a_bigger else mant_b_impl;
    exp_max <= exp_a when exp_a_bigger else exp_b;

    mant_out <= mant_a + mant_b;
    mant_out_vec <= std_logic_vector(mant_out);

    mant_out_overflow <= mant_out_vec(24) = '1';
    exp_max_limit <= exp_max = 254;

    exp_out <= (exp_max + 1) when (mant_out_overflow and not exp_max_limit) else exp_max;
    exp_out_vec <= std_logic_vector(exp_out);

    num_out <= (num_a(31) & exp_out_vec & mant_out_vec(22 downto 0))        when (not mant_out_overflow)
                else (num_a(31) & exp_out_vec & mant_out_vec(23 downto 1))  when (not exp_max_limit)
                else (num_a(31) & infty);
end arch_add_inner;