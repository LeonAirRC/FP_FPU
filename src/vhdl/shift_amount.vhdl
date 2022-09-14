-- author: Leon Bartmann

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity shift_amount is
    port (
        mant : in unsigned(23 downto 0);
        shift_amt : out integer range 0 to 23
    );
end shift_amount;

architecture arch_shift_amount of shift_amount is
    -- Berechnet die Anzahl an bits, um die eine Mantisse normalisiert werden muss
begin
    shift_amt <=  0 when mant(23) = '1' else
                  1 when mant(22) = '1' else
                  2 when mant(21) = '1' else
                  3 when mant(20) = '1' else
                  4 when mant(19) = '1' else
                  5 when mant(18) = '1' else
                  6 when mant(17) = '1' else
                  7 when mant(16) = '1' else
                  8 when mant(15) = '1' else
                  9 when mant(14) = '1' else
                 10 when mant(13) = '1' else
                 11 when mant(12) = '1' else
                 12 when mant(11) = '1' else
                 13 when mant(10) = '1' else
                 14 when mant(9)  = '1' else
                 15 when mant(8)  = '1' else
                 16 when mant(7)  = '1' else
                 17 when mant(6)  = '1' else
                 18 when mant(5)  = '1' else
                 19 when mant(4)  = '1' else
                 20 when mant(3)  = '1' else
                 21 when mant(2)  = '1' else
                 22 when mant(1)  = '1' else
                 23 when mant(0)  = '1' else
                  0;
end architecture;