library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity shift_amount is
    port (
        mant : in unsigned(24 downto 0);
        shift_amt : out integer range 0 to 31
    );
end shift_amount;

architecture arch_shift_amount of shift_amount is
begin
    process( mant )
    begin
        for i in 23 downto 0 loop
            if mant(i) = '1' then
                shift_amt <= 23 - i;
                exit;
            end if;
        end loop;
    end process;
end architecture;