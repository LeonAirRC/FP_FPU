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
    signal exp_a : integer range 0 to 255;
    signal exp_b : integer range 0 to 255;
    signal exp_diff : integer range 0 to 255;
    signal exp_max : integer range 0 to 255;
    signal mant_a : integer range 0 to 33554431;
    signal mant_b : integer range 0 to 33554431;
    signal mant_b_comp : integer range 0 to 33554431;
    signal mant_sum : integer range 0 to 33554431;
    signal mant_sum_comp : integer range 0 to 33554431;
    signal mant_sum_vec : std_logic_vector(23 downto 0);
    signal shift_amt : integer range 0 to 23 := 0;
    signal exp_out : integer range 0 to 255;
    signal exp_out_vec : std_logic_vector(7 downto 0);
    signal mant_out : std_logic_vector(23 downto 0);
begin
    exp_a <= to_integer(unsigned(num_a(30 downto 23)));
    exp_b <= to_integer(unsigned(num_b(30 downto 23)));
    if exp_a > exp_b then
        exp_diff <= exp_a - exp_b;
        mant_a <= to_integer(unsigned("01" & num_a(22 downto 0)));
        mant_b <= to_integer(unsigned(("01" & num_b(22 downto 0)) srl exp_diff));
        exp_max <= exp_a;
    elsif exp_b > exp_a then
        exp_diff <= exp_b - exp_a;
        mant_a <= to_integer(unsigned(("01" & num_a(22 downto 0)) srl exp_diff));
        mant_b <= to_integer(unsigned("01" & num_b(22 downto 0)));
        exp_max <= exp_b;
    else
        mant_a <= to_integer(unsigned("01" & num_a(22 downto 0)));
        mant_b <= to_integer(unsigned("01" & num_b(22 downto 0)));
        exp_max <= exp_a;
    end if;

    mant_b_comp <= (not mant_b) + 1;
    mant_sum <= mant_a + mant_b_comp;
    sig_out <= num_a(31) xor mant_sum(24);
    if mant_sum(24) then
        mant_sum_comp = (not mant_sum) + 1;
        mant_sum_vec <= std_logic_vector(to_unsigned(mant_sum_comp))(23 downto 0);
    else
        mant_sum_vec <= std_logic_vector(to_unsigned(mant_sum))(23 downto 0);
    end if;
    if mant_sum_vec = "0" then
        num_out <= zero;
    else
        for i in 23 downto 0 loop
            if mant_sum_vec(i) then
                shift_amt <= 23 - i;
                exit;
            end if;
        end loop;
        if exp_max < shift_amt then
            num_out <= zero;
        else
            exp_out <= exp_max - shift_amt;
            exp_out_vec <= std_logic_vector(to_unsigned(exp_out));
            mant_out <= mant_sum_vec sll shift_amt;
            num_out <= sig_out & exp_out_vec & mant_out(22 downto 0);
        end if;
    end if;
end architecture;