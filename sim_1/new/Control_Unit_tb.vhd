library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use STD.ENV.ALL;

entity Control_Unit_tb is
    generic(
        M : positive := 32);
end Control_Unit_tb;

architecture Structural of Control_Unit_tb is

    component Control_Unit is
    generic(
        M : positive := 32);
    Port (
        Instr       : in STD_LOGIC_VECTOR(M-1 downto 0);
        FLAGS       : in STD_LOGIC_VECTOR(3 downto 0);
        
        RegSrc      : out STD_LOGIC_VECTOR(2 downto 0);     --out signals from files InstrDec, Logic
        ALUSrc      : out STD_LOGIC;
        MemtoReg    : out STD_LOGIC;
        ALUControl  : out STD_LOGIC_VECTOR(2 downto 0);
        ImmSrc      : out STD_LOGIC;
        MemWrite    : out STD_LOGIC;
        FlagsWrite  : out STD_LOGIC;
        RegWrite    : out STD_LOGIC;
        PCSrc       : out STD_LOGIC
    );
    end component;
    
    signal Instr        : STD_LOGIC_VECTOR (M-1 downto 0);
    signal FLAGS        : STD_LOGIC_VECTOR (3 downto 0);
    signal RegSrc       : STD_LOGIC_VECTOR (2 downto 0);
    signal ALUControl   : STD_LOGIC_VECTOR (2 downto 0);
    signal ALUSrc       : STD_LOGIC;
    signal MemtoReg     : STD_LOGIC;
    signal ImmSrc       : STD_LOGIC;
    signal MemWrite     : STD_LOGIC;
    signal FlagsWrite   : STD_LOGIC;
    signal RegWrite     : STD_LOGIC;
    signal PCSrc        : STD_LOGIC;
    
    constant CLK_PERIOD : time := 50 ns;
    
begin

    Control_Unit_Map : Control_Unit 
    port map (
        Instr       => Instr,
        FLAGS       => FLAGS,
        RegSrc      => RegSrc,
        ALUSrc      => ALUSrc,
        MemtoReg    => MemtoReg,
        ALUControl  => ALUControl,
        ImmSrc      => ImmSRc,
        MemWrite    => MemWrite,
        FlagsWrite  => FlagsWrite,
        RegWrite    => RegWrite,
        PCSrc       => PCSrc
    );
    
    CntrlUnt: process
    begin
                
        --mov R0, #10
        Instr <= X"E3A0000A";
        FLAGS <= "0000";
        
        wait for CLK_PERIOD;
        
        --mov R1, #10
        Instr <= X"E3A0100A";
        FLAGS <= "0000";
        
        wait for CLK_PERIOD;
        
        --add R2, R1, R0
        Instr <= X"E0812000";
        FLAGS <= "0000";
        
        wait for CLK_PERIOD;
        
        --sub R3, R1, R0
        Instr <= X"E0413000";
        FLAGS <= "0000";
        
        wait for CLK_PERIOD;
        
        -- and R4, R3, R2
        Instr <= X"E0034002";
        FLAGS <= "0000";
        
        wait for CLK_PERIOD;

        -- xor R5, R3, R2
        Instr <= X"E0235002";
        FLAGS <= "0000";
        
        wait for CLK_PERIOD;
        
        -- LSL R6, R5, #1
        Instr <= X"E1A06084";
        FLAGS <= "0000";
        
        wait for CLK_PERIOD;
        
        -- ASR R7, R5, #1
        Instr <= X"E1A070C5";
        FLAGS <= "0000";
        
        wait for CLK_PERIOD;
        
        -- STR R0, [R0, #12]
        Instr <= X"E580000C";
        FLAGS <= "0000";
        
        wait for CLK_PERIOD;
        
        -- STR R0, [R2, #-12]
        Instr <= X"E502000C";
        FLAGS <= "0000";
        
        wait for CLK_PERIOD;
        
        -- LDR R8, [R0, #12]
        Instr <= X"E590800C";
        FLAGS <= "0000";
        
        wait for CLK_PERIOD;
        
        -- LDR R9, [R2, #-12]
        Instr <= X"E512900C";
        FLAGS <= "0000";
        
        wait for CLK_PERIOD;
        
        -- CMP R0, R1
        Instr <= X"E1500001";
        FLAGS <= "0110";
        
        wait for CLK_PERIOD;
        
        -- ADDEQ R10, R0, #1
        Instr <= X"0280A001";
        FLAGS <= "0110";
        
        wait for CLK_PERIOD;
        
        -- BL #-1
        Instr <= X"EBFFFFFD";
        FLAGS <= "0110";
        
        wait for CLK_PERIOD;
        
        -- after BL
        Instr <= "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";
        FLAGS <= "0110";
        
        wait for 2*CLK_PERIOD;
        
        report "TEST COMPLETED";
        stop(2);
    end process;

end Structural;
