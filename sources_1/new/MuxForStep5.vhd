library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;           -- For type convertions

entity MuxForStep5 is
    generic (
        M : positive := 32 -- data word length
    );
    Port (
        A : in STD_LOGIC_VECTOR (M-1 downto 0);
        B : in STD_LOGIC_VECTOR (M-1 downto 0);
        S : in STD_LOGIC;
        Y : out STD_LOGIC_VECTOR (M-1 downto 0)
    );
end MuxForStep5;

architecture Behavioral of MuxForStep5 is

begin

    process (A, B, S)
    begin 
        if (S = '0') then
            Y <= A;
        else
            Y <= B;
        end if;
    end process;

end Behavioral;
