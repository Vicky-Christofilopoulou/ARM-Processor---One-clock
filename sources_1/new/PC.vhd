library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;           -- For type convertions

entity PC is
    generic(
        M : positive := 32 -- data word length
    );
    Port ( 
        CLK     : in std_logic;
        RESET   : in std_logic;
        WE      : in std_logic;
        D       : in STD_LOGIC_VECTOR(M-1 downto 0);
        Q       : out STD_LOGIC_VECTOR(M-1 downto 0)
    );
end PC;

architecture Behavioral of PC is    -- STEP 2-1.1. 
begin
    
    process (CLK, RESET, WE, D)
    begin
        if (CLK'event and CLK = '1') then
            if (RESET = '1') then
                Q <= (others => '0');
            elsif (WE = '1') then
                Q <= D;
            end if;
        end if;
    end process;

end Behavioral;
