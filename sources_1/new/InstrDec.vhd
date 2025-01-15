library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.ALL;    -- For counting and addition
use IEEE.NUMERIC_STD.ALL;           -- For type convertions

entity InstrDec is  --  STEP 4-1.3
    Port ( 
        op          : in STD_LOGIC_VECTOR(1 downto 0);
        funct       : in STD_LOGIC_VECTOR(5 downto 0);
        sh          : in STD_LOGIC_VECTOR(1 downto 0);
        RegSrc      : out STD_LOGIC_VECTOR(2 downto 0);
        ALUControl  : out STD_LOGIC_VECTOR(2 downto 0);
        ALUSrc      : out STD_LOGIC;
        MemtoReg    : out STD_LOGIC;
        ImmSrc      : out STD_LOGIC;
        NoWrite_in  : out STD_LOGIC
    );
end InstrDec;

architecture Behavioral of InstrDec is

begin
  
--Base on the table p. 17: STEP 4-1.1

    ALUControl <= "000" when (funct(4 downto 1) = "0100" and op = "00") else                    --ADD = 0100
                  "100" when (funct(4 downto 1) = "0010" and op = "00") else                    --SUB = 0010
                  "010" when (funct(4 downto 1) = "0000" and op = "00") else                    --AND = 0000
                  "110" when (funct(4 downto 1) = "0001" and op = "00") else                    --XOR = 0001
                  "100" when (funct(4 downto 1) = "1010" and op = "00") else                    --CMP = 1010
                  "001" when (funct(5 downto 1) = "11101" and op = "00") else                   --MOV = 1101
                  "101" when (funct(4 downto 1) = "1111" and op = "00") else                    --MVN = 1111
                  "011" when (funct(5 downto 1) = "01101" and op = "00" and sh = "00") else     --S = 1101 LS = 00
                  "111" when (funct(5 downto 1) = "01101" and op = "00" and sh = "10") else     --S = 1101 RS = 10
                  "000" when (funct(4 downto 1) = "1100" and op = "01") else                    -- R+#I
                  "100" when (funct(4 downto 1) = "1000" and op = "01") else                    -- R-#I
                  "000" when (op = "10") else -- B
                  "ZZZ";
                  
    RegSrc <= "000" when (op = "00") else
              "010" when (op = "01") else
              "100" when (op = "10" and funct(4 downto 3) = "10") else
              "101" when (op = "10" and funct(4 downto 3) = "11") else
              "ZZZ";
              
    ALUSrc <= funct(5) when (op = "00") else
              '1' when (op = "01") else
              '1' when (op = "10") else
              'Z';
              
    ImmSrc <= '0' when (op = "00") else
              '0' when (op = "01") else
              '1' when (op = "10") else
              'Z';
              
    MemtoReg <= '0' when (op = "00") else
                '1' when (op = "01") else
                '0' when (op = "10") else
                'Z';
                
    NoWrite_in <= '1' when (op = "00" and funct(4 downto 1) = "1010") else
                  '0' when (op = "00" and not(funct(4 downto 1) = "1010")) else
                  '0' when (op = "01") else
                  '0' when (op = "10" and funct(4 downto 3) = "10") else
                  '1' when (op = "10" and funct(4 downto 3) = "11") else
                  'Z';

end Behavioral;
