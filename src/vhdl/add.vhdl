library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity add is
    port (
        num_a : in std_logic_vector(31 downto 0);
        num_b : in std_logic_vector(31 downto 0);
        num_out : out std_logic_vector(31 downto 0)
    );
end add;

architecture arch_add of add is
    signal sub_num_b, add_output, sub_output : std_logic_vector(31 downto 0);
begin
    a: entity work.add_outer port map (num_a, num_b, add_output);
    s: entity work.sub_outer port map (num_a, sub_num_b, sub_output);
    
    sub_num_b <= num_a(31) & num_b(30 downto 0); -- für die Subtraktion wird das Vorzeichenbit von num_b invertiert bzw. an num_a angeglichen
    
    num_out <=  add_output when (num_a(31) = num_b(31)) else -- falls Vorzeichenbits gleich: tatsächliche Addition
                sub_output;                                  -- sonst Subtraktion mit invertiertem Vorzeichnbit von num_b
end arch_add;