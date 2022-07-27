library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity test_alu is
end test_alu;

architecture arch_test_alu of test_alu is
    signal op : std_logic_vector(1 downto 0);
    signal num_a, num_b, num_out : std_logic_vector(31 downto 0);
begin
    m : entity work.alu port map (op, num_a, num_b, num_out);
    process begin
        op <= "00";
        num_a <= "0" & "01111111" & "00000000000000000000000";
        num_a <= "0" & "01111111" & "10000000000000000000000";
        wait for 100 ns;
        num_out <= "1" & num_a(30 downto 0);
    end process;
end architecture;