-- author: Leon Bartmann

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity test_alu is
end test_alu;

architecture arch_test_alu of test_alu is
    signal op : std_logic_vector(1 downto 0);
    signal num_a, num_b, num_out, num_r : std_logic_vector(31 downto 0);
    signal rnd : std_logic_vector(2 downto 0);
    signal exc : std_logic_vector(4 downto 0);
begin
    m : entity work.alu port map (op, num_a, num_b, rnd, num_out, exc);

    process begin
        num_a <= "1" & "10000000" & "00000000000000000000000";
        num_b <= "0" & "01111111" & "00000000000000000000001";
        op <= "00";
        rnd <= "000";
        wait for 10 ns;
        rnd <= "001";
        wait for 10 ns;
        rnd <= "010";
        wait for 10 ns;
        rnd <= "011";
        wait for 10 ns;
        rnd <= "100";
        wait for 10 ns;
        op <= "01";
        rnd <= "000";
        wait for 10 ns;
        rnd <= "001";
        wait for 10 ns;
        rnd <= "010";
        wait for 10 ns;
        rnd <= "011";
        wait for 10 ns;
        rnd <= "100";
        wait for 10 ns;
        op <= "10";
        rnd <= "000";
        wait for 10 ns;
        rnd <= "001";
        wait for 10 ns;
        rnd <= "010";
        wait for 10 ns;
        rnd <= "011";
        wait for 10 ns;
        rnd <= "100";
        wait for 10 ns;
        wait;
    end process;
end architecture;