library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mul_inner is
    port (
        num_a : in std_logic_vector(31 downto 0);
        num_b : in std_logic_vector(31 downto 0);
        num_out : out std_logic_vector(31 downto 0)
    );
end mul_inner;

architecture arch_mul_inner of mul_inner is
    constant zero : std_logic_vector := "0000000000000000000000000000000";
    constant infty : std_logic_vector := "1111111100000000000000000000000";

    signal sig_out : std_logic;
    signal exp_a, exp_b : unsigned(7 downto 0);
    signal exp_sum : signed(8 downto 0);
    signal mant_a, mant_b : unsigned(23 downto 0);
    signal mant_prod : unsigned(47 downto 0);
    signal mant_prod_vec : std_logic_vector(24 downto 0);
    signal exp_out : std_logic_vector(7 downto 0);
begin
    process( num_a, num_b )
    begin
        sig_out <= num_a(31) xor num_b(31);
        exp_a <= unsigned(num_a(30 downto 23));
        exp_b <= unsigned(num_b(30 downto 23));
        exp_sum <= signed(exp_a + exp_b) - 127;
        if exp_sum > 254 then
            num_out <= sig_out & infty;
        elsif exp_sum < 0 then
            num_out <= sig_out & zero;
        else
            mant_a <= unsigned("1" & num_a(22 downto 0));
            mant_b <= unsigned("1" & num_b(22 downto 0));
            mant_prod <= mant_a * mant_b;
            mant_prod_vec <= std_logic_vector(mant_prod srl 23);
            if mant_prod_vec(24) = '1' then
                if exp_sum = 254 then
                    num_out <= sig_out & infty;
                else
                    exp_out <= std_logic_vector(exp_sum + 1);
                    num_out <= sig_out & exp_out & mant_prod_vec(23 downto 1);
                end if;
            elsif exp_sum = 0 then
                num_out <= sig_out & zero;
            else
                exp_out <= std_logic_vector(exp_sum);
                num_out <= sig_out & exp_out & mant_prod_vec(22 downto 0);
            end if;
        end if;
    end process;
end architecture;