library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.ALL;    -- For counting and addition
use IEEE.NUMERIC_STD.ALL;           -- For type convertions

entity WELogic is       -- STEP 4-2
    Port ( 
        op              : in STD_LOGIC_VECTOR (1 downto 0);
        S_L             : in STD_LOGIC;
        NoWrite_in      : in STD_LOGIC;
        MemWrite_in     : out STD_LOGIC;
        FlagsWrite_in   : out STD_LOGIC;
        RegWrite_in     : out STD_LOGIC
    );
end WELogic;

architecture Behavioral of WELogic is

begin

    MemWrite_in <= '0' when (op = "00") else
              '1' when (op = "01" and S_L = '0' and NoWrite_in = '0') else
              '0' when (op = "01" and S_L = '1' and NoWrite_in = '0') else
              '0' when (op = "10") else
              'Z';

    FlagsWrite_in <= '0' when (op = "00" and S_L = '0' and NoWrite_in = '0') else
                     '1' when (op = "00" and S_L = '1') else
                     '0' when (op = "01") else
                     '0' when (op = "10") else
                     'Z';
    
    RegWrite_in <= '1' when (op = "00" and S_L = '0' and NoWrite_in = '0') else
                   '1' when (op = "00" and S_L = '1' and NoWrite_in = '0') else
                   '0' when (op = "00" and S_L = '1' and NoWrite_in = '1') else
                   '1' when (op = "01" and S_L = '1' and NoWrite_in = '0') else
                   '0' when (op = "01" and S_L = '0' and NoWrite_in = '0') else
                   '0' when (op = "10" and NoWrite_in = '0') else
                   '1' when (op = "10" and NoWrite_in = '1') else
                   'Z';

end Behavioral;
