library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;           -- For type convertions

entity PCPlus4 is
    generic(
        M : positive := 32 -- data word length
    );

    Port (
        PC      : in  STD_LOGIC_VECTOR (M-1 downto 0);
        PCPlus4 : out  STD_LOGIC_VECTOR (M-1 downto 0)
     );
end PCPlus4;

architecture Behavioral of PCPlus4 is       -- STEP 2-1.3.

begin

PCPlus4 <= std_logic_vector(unsigned(PC) + 4);  -- PC = PC + 4

end Behavioral;
