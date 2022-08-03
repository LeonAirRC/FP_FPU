library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity sub is
    port (
        num_a : in std_logic_vector(31 downto 0);
        num_b : in std_logic_vector(31 downto 0);
        num_out : out std_logic_vector(31 downto 0)
    );
end sub;

architecture arch_sub of sub is
    signal add_num_b, add_output, sub_output : std_logic_vector(31 downto 0);
begin
    a: entity work.add_outer port map (num_a, add_num_b, add_output);
    s: entity work.sub_outer port map (num_a, num_b, sub_output);

    add_num_b <= num_a(31) & num_b(30 downto 0); -- für die Addition wird das Vorzeichenbit von num_b invertiert bzw. an num_a angeglichen
    
    num_out <=  sub_output when (num_a(31) = num_b(31)) else -- falls Vorzeichenbits gleich: tatsächliche Subtraktion
                add_output;                                  -- sonst Addition mit invertiertem Vorzeichnbit von num_b
end architecture;