library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use STD.ENV.all;

entity Datapath_tb is
    generic(
        M : positive := 32);
end Datapath_tb;

Architecture Behavioral of Datapath_tb is

    component DataPath is
    generic (
        M : positive := 32          -- data word length
    );
    Port (
        -- STEP 1:
        CLK         : in STD_LOGIC;
        RESET       : in STD_LOGIC;
        PCWrite     : in STD_LOGIC;
        PC_out      : out STD_LOGIC_VECTOR (M-1 downto 0);
        instr       : out STD_LOGIC_VECTOR (M-1 downto 0);
        
        -- STEP 2:
        RegSrc      : in STD_LOGIC_VECTOR (2 downto 0);
        RegWrite    : in STD_LOGIC;
        ImmSrc      : in STD_LOGIC;
        
        -- STep 3:
        ALUSrc      : in STD_LOGIC;
        ALUControl  : in STD_LOGIC_VECTOR (2 downto 0);
        FlagsWrite  : in STD_LOGIC;
        ALUResult   : out STD_LOGIC_VECTOR (M-1 downto 0);
        flags       : out STD_LOGIC_VECTOR (3 downto 0);
        
        -- STEP 4:
        MemWrite : in STD_LOGIC;
        
        -- STEP 5:
        MemtoReg    : in STD_LOGIC;
        PCSrc       : in STD_LOGIC;
        Result      : out STD_LOGIC_VECTOR (M-1 downto 0)
        
    );
    end component;
    
    -- in
    signal CLK          : STD_LOGIC;
    signal RESET        : STD_LOGIC;
    signal PCWrite      : STD_LOGIC;
    signal REG_SRC      : STD_LOGIC_VECTOR (2 downto 0);
    signal ALU_CONTROL  : STD_LOGIC_VECTOR (2 downto 0);

    signal ALU_SRC      : STD_LOGIC;
    signal MemToREG     : STD_LOGIC;
    signal IMM_SRC      : STD_LOGIC;
    
    signal MEM_WRITE     : STD_LOGIC;
    signal FLAGS_WRITE   : STD_LOGIC;
    signal REG_WRITE     : STD_LOGIC;
    signal PC_SRC        : STD_LOGIC;

    -- out
    signal Flag         : STD_LOGIC_VECTOR (3 downto 0);
    signal Instr        : STD_LOGIC_VECTOR (M-1 downto 0);
    signal PC           : STD_LOGIC_VECTOR (M-1 downto 0);
    signal ALU_RESULT   : STD_LOGIC_VECTOR (M-1 downto 0);
    signal RESULT       : STD_LOGIC_VECTOR (M-1 downto 0);
    signal WRITE_DATA   : STD_LOGIC;
    
    constant CLK_PERIOD : time := 10 ns;
    
begin
    
    DataPath_Map : DataPath 
    port map(
        CLK         => CLK,
        RESET       => RESET,
        PCWrite     => PCWrite,
        RegSrc      => REG_SRC,
        ALUSrc      => ALU_SRC,
        MemtoReg    => MemToREG,
        ALUControl  => ALU_CONTROL,
        ImmSrc      => IMM_SRC,
        MemWrite    => MEM_WRITE,
        FlagsWrite  => FLAGS_WRITE,
        RegWrite    => REG_WRITE,
        PCSrc       => PC_SRC,
        INSTR       => Instr,
        flags       => Flag,
        PC_out      => PC,
        ALUResult   => ALU_RESULT,
        Result      => RESULT
    );
    
    CLK_PROCESS : process
    
    begin
        CLK <= '0';
        wait for CLK_PERIOD/2;
        
        CLK <= '1';
        wait for CLK_PERIOD/2;
    end process;
    
    DataPath_PROCESS : process
    
    begin
    
        RESET <= '1';
        wait for 20 ns;
        
        RESET <= '0';
        PCWrite <= '1';
        
        -- move R0, #5
        REG_SRC     <= "000";
        ALU_SRC     <= '1';
        MemToREG    <= '0';
        ALU_CONTROL <= "001";
        IMM_SRC     <= '0';
        MEM_WRITE   <= '0';
        FLAGS_WRITE <= '0';
        REG_WRITE   <= '1';
        PC_SRC      <= '0';
        
        wait;
        
    end process;

end Behavioral;
