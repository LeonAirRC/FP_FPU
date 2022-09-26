-- author: Leon Bartmann

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity test_au is
end test_au;

architecture arch_test_au of test_au is
    signal op : std_logic_vector(1 downto 0);
    signal num_a, num_b, num_out : std_logic_vector(31 downto 0);
    signal rnd : std_logic_vector(2 downto 0);
    signal exc : std_logic_vector(4 downto 0);
begin
    m : entity work.au port map (op, num_a, num_b, rnd, num_out, exc);

    process begin
        num_a <= "1" & "01111111" & "00000000000000000000000";
        num_b <= "0" & "01111110" & "00000000000000000000000";
        op <= "00";
        rnd <= "000";
        wait for 10 ns;
        op <= "01";
        wait for 10 ns;
        op <= "10";
        wait for 10 ns;
        num_a <= "0" & "10000001" & "01000000000000000000000";
        num_b <= "0" & "10000001" & "01000000000000000000000";
        op <= "00";
        rnd <= "000";
        wait for 10 ns;
        op <= "01";
        wait for 10 ns;
        op <= "10";
        wait for 10 ns;
        wait;
    end process;
end architecture;