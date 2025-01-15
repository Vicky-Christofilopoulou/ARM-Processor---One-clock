library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.ALL;    -- For counting and addition
use IEEE.NUMERIC_STD.ALL;           -- For type convertions

entity PCLogic is       -- STEP 4-3
    Port ( 
        RegWrite_in : in STD_LOGIC;
        Rd          : in STD_LOGIC_VECTOR(3 downto 0);
        op          : in STD_LOGIC;
        PCSrc_in    : out STD_LOGIC
    );
end PCLogic;

architecture Behavioral of PCLogic is

begin

    PCSrc_in <= '0' when (op = '0' and RegWrite_in = '0') else
                '1' when (op = '0' and RegWrite_in = '1' and Rd = "1111") else
                '0' when (op = '0' and RegWrite_in = '1' and not(Rd = "1111")) else
                '1' when (op = '1') else
                'Z';

end Behavioral;
