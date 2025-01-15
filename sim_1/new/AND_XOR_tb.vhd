library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use STD.ENV.ALL;

entity AND_XOR_tb is
    generic(
        M : positive := 32);
end AND_XOR_tb;

architecture Behavioral of AND_XOR_tb is
    
    component AND_XOR is
    generic (
        M : positive := 32 -- data word length
    );    
    Port (
        AOX     : in STD_LOGIC;
        A       : in STD_LOGIC_VECTOR (M-1 downto 0);
        B       : in STD_LOGIC_VECTOR (M-1 downto 0);
        S       : out STD_LOGIC_VECTOR (M-1 downto 0)
    );
    end component;
    
    signal A    : STD_LOGIC_VECTOR (M-1 downto 0);
    signal B    : STD_LOGIC_VECTOR (M-1 downto 0);
    signal S    : STD_LOGIC_VECTOR (M-1 downto 0);
    signal AC   : STD_LOGIC;
    
begin

    AND_XOR_Map : AND_XOR 
    port map (
        A       => A,
        B       => B,
        S       => S,
        AOX     => AC
    );

    process   
    begin 

        -- AND
        AC <= '0';
        A <= X"0000000" & "1101";
        B <= X"1101010" & "0101";
        
        wait for 100 ns;
        
        -- XOR
        AC <= '1';
        A <= X"0000000" & "0111";
        B <= X"1101010" & "0101";
        wait for 100 ns;
                
        wait;
        report "COMPLETE";
        stop(2);
        
    end process;
    
end Behavioral;
