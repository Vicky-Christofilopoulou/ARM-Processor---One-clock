library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;           -- For type convertions

entity Mux2To1 is
    generic (
        M : positive := 4 -- data word length
    );

    Port (
        A : in STD_LOGIC_VECTOR (M-1 downto 0);
        B : in STD_LOGIC_VECTOR (M-1 downto 0);
        S : in STD_LOGIC;
        Y : out STD_LOGIC_VECTOR (M-1 downto 0)
    );
end Mux2To1;

architecture Behavioral of Mux2To1 is

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
