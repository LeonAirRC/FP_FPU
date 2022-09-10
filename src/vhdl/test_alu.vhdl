library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity test_alu is
end test_alu;

architecture arch_test_alu of test_alu is
    signal op : std_logic_vector(1 downto 0);
    signal num_a, num_b, num_out, num_r : std_logic_vector(31 downto 0);
    signal correct : std_logic;
begin
    m : entity work.alu port map (op, num_a, num_b, num_out);
    correct <= '1' when (num_out = num_r) else '0';

    process begin
        op <= "00";
        num_a <= "0" & "01111111" & "00000000000000000000000";
        num_b <= "0" & "10000001" & "00000000000000000000000";
        num_r <= "0" & "10000001" & "01000000000000000000000";
        wait for 10 ns;
        op <= "01";
        num_r <= "1" & "10000000" & "10000000000000000000000";
        wait for 10 ns;
        op <= "10";
        num_r <= "0" & "10000001" & "00000000000000000000000";
        wait for 10 ns;
        op <= "00";
        num_a <= "0" & "10000010" & "01000000000000000000000";
        num_b <= "0" & "01111111" & "10000000000000000000000";
        num_r <= "0" & "10000010" & "01110000000000000000000";
        wait for 10 ns;
        op <= "01";
        num_r <= "0" & "10000010" & "00010000000000000000000";
        wait for 10 ns;
        op <= "10";
        num_r <= "0" & "10000010" & "11100000000000000000000";
        wait for 10 ns;
        op <= "00";
        num_a <= "1" & "01111111" & "00000000000000000000000";
        num_b <= "0" & "01111110" & "00000000000000000000000";
        num_r <= "0" & "10000001" & "01000000000000000000000";
        wait for 10 ns;
        op <= "01";
        wait for 10 ns;
        op <= "10";
        wait for 10 ns;
        op <= "00";
        num_a <= "1" & "00000001" & "00000000000000000000000";
        num_b <= "0" & "00000010" & "00000000000000000000000";
        wait for 10 ns;
        op <= "01";
        wait for 10 ns;
        op <= "10";
        wait for 10 ns;
        op <= "00";
        num_a <= "1" & "00000000" & "00000000000000000000000";
        num_b <= "0" & "11111111" & "00000000000001000000000";
        wait for 10 ns;
        op <= "01";
        wait for 10 ns;
        op <= "10";
        wait for 10 ns;
        wait;
    end process;
end architecture;