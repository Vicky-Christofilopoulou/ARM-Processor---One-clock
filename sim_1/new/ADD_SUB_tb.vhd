library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use STD.ENV.ALL;

entity ADD_SUB_tb is
    generic(
        M : positive := 32);
end ADD_SUB_tb;

architecture Behavioral of ADD_SUB_tb is
    
    component ADD_SUB is
    generic (
        M : positive := 32 -- data word length
    );
    Port ( 
        AOS     : in STD_LOGIC;
        A       : in STD_LOGIC_VECTOR (M-1 downto 0);
        B       : in STD_LOGIC_VECTOR (M-1 downto 0);
        S       : out STD_LOGIC_VECTOR (M-1 downto 0);
        COUT    : out STD_LOGIC;
        OV      : out STD_LOGIC
    );
    end component;
    
    signal A    : STD_LOGIC_VECTOR (M-1 downto 0);
    signal B    : STD_LOGIC_VECTOR (M-1 downto 0);
    signal S    : STD_LOGIC_VECTOR (M-1 downto 0);
    signal F    : STD_LOGIC_VECTOR (3 downto 0);
    signal AC   : STD_LOGIC;
    signal C    : STD_LOGIC;
    signal O    : STD_LOGIC;
    
begin

    ADD_SUB_Map : ADD_SUB 
    port map (
        A       => A,
        B       => B,
        S       => S,
        AOS     => AC,
        COUT    => C,
        OV      => O
    );

    process
    
    begin     
        
        -- ADD
        AC <= '0';
        A <= X"0000000" & "1101";
        B <= X"0000000" & "0111";
        wait for 100 ns;
        
        -- SUB
        AC <= '1';
        A <= X"0000000" & "1101";
        B <= X"0000000" & "0111";
        wait for 100 ns;
            
        wait;
        report "COMPLETE";
        stop(2);
        
    end process;
    
end Behavioral;
