library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity sub_inner is
    port (
        num_a : in std_logic_vector(31 downto 0);
        num_b : in std_logic_vector(31 downto 0);
        num_out : out std_logic_vector(31 downto 0)
    );
end sub_inner;

architecture arch_sub_inner of sub_inner is
    constant zero : std_logic_vector := "00000000000000000000000000000000";
    signal sig_out : std_logic;
    signal exp_a, exp_b : unsigned(7 downto 0);
    signal exp_max : unsigned(7 downto 0);
    signal mant_a, mant_b : unsigned(24 downto 0);
    signal mant_a_impl, mant_b_impl : unsigned(24 downto 0);
    signal mant_b_comp : unsigned(24 downto 0);
    signal mant_sum : unsigned(24 downto 0);
    signal mant_sum_comp : unsigned(24 downto 0);
    signal mant_sum_impl : unsigned(23 downto 0);
    signal shift_amt : integer range 0 to 23 := 0;
    signal exp_out : unsigned(7 downto 0);
    signal exp_out_vec : std_logic_vector(7 downto 0);
    signal mant_out : std_logic_vector(23 downto 0);
begin
    process( num_a, num_b )
    begin
        exp_a <= unsigned(num_a(30 downto 23));
        exp_b <= unsigned(num_b(30 downto 23));
        mant_a_impl <= unsigned("01" & num_a(22 downto 0));
        mant_b_impl <= unsigned("01" & num_b(22 downto 0));
        if exp_a > exp_b then
            mant_a <= mant_a_impl;
            mant_b <= mant_b_impl srl to_integer(exp_a - exp_b);
            exp_max <= exp_a;
        elsif exp_b > exp_a then
            mant_a <= mant_a_impl srl to_integer(exp_b - exp_a);
            mant_b <= mant_b_impl;
            exp_max <= exp_b;
        else
            mant_a <= mant_a_impl;
            mant_b <= mant_b_impl;
            exp_max <= exp_a;
        end if;

        mant_b_comp <= (not mant_b) + 1;
        mant_sum <= mant_a + mant_b_comp;
        sig_out <= num_a(31) xor mant_sum(24);
        if mant_sum(24) = '1' then
            mant_sum_comp <= (not mant_sum) + 1;
            mant_sum_impl <= mant_sum_comp(23 downto 0);
        else
            mant_sum_impl <= mant_sum(23 downto 0);
        end if;
        if mant_sum_impl = "0" then
            num_out <= zero;
        else
            for i in 23 downto 0 loop
                if mant_sum_impl(i) = '1' then
                    shift_amt <= 23 - i;
                    exit;
                end if;
            end loop;
            if exp_max < shift_amt then
                num_out <= zero;
            else
                exp_out <= exp_max - shift_amt;
                exp_out_vec <= std_logic_vector(exp_out);
                mant_out <= std_logic_vector(mant_sum_impl sll shift_amt);
                num_out <= sig_out & exp_out_vec & mant_out(22 downto 0);
            end if;
        end if;
    end process;
end architecture;