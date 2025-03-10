library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.ALL;    -- For counting and addition
use IEEE.NUMERIC_STD.ALL;           -- For type convertions

entity Processor is         -- STEP 5
    generic(
        M : positive := 32);
    Port (
        CLK         : in STD_LOGIC;
        RESET       : in STD_LOGIC;
        PC          : out STD_LOGIC_VECTOR (M-1 downto 0);
        ALUResult   : out STD_LOGIC_VECTOR (M-1 downto 0);
        WriteData   : out STD_LOGIC;
        Instruction : out STD_LOGIC_VECTOR (M-1 downto 0);
        Result      : out STD_LOGIC_VECTOR (M-1 downto 0)
    );
end Processor;

architecture Structural of Processor is

    component Datapath is
    generic (
        M : positive := 32          -- data word length
    );
    Port (
        -- STEP 1:
        CLK         : in STD_LOGIC;
        RESET       : in STD_LOGIC;
        PCWrite     : in STD_LOGIC;
        PC_out          : out STD_LOGIC_VECTOR (M-1 downto 0);
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
    
    
    
--signal for the match-up

    -- DataPath
    signal INSTR    : STD_LOGIC_VECTOR (M-1 downto 0);
    signal FLAG     : STD_LOGIC_VECTOR (3 downto 0);
    signal PCReg    : STD_LOGIC_VECTOR (M-1 downto 0);
    signal ALURes   : STD_LOGIC_VECTOR (M-1 downto 0);
    signal Res      : STD_LOGIC_VECTOR (M-1 downto 0);
    
    -- Control Unit
    signal RegSrc_0     : STD_LOGIC_VECTOR (2 downto 0);
    signal ALUSrc_0     : STD_LOGIC;
    signal MemtoReg_0   : STD_LOGIC;
    signal ALUControl_0 : STD_LOGIC_VECTOR (2 downto 0);
    signal ImmSrc_0     : STD_LOGIC;
    signal RegWrite_0   : STD_LOGIC;
    signal MemWrite_0   : STD_LOGIC;
    signal FlagsWrite_0 : STD_LOGIC;
    signal PCSrc_0      : STD_LOGIC;
    
begin

    Datapath_Map : DataPath 
    port map(
        CLK         => CLK,
        RESET       => RESET,
        PCWrite     => '1',
        RegSrc      => RegSrc_0,
        ALUSrc      => ALUSrc_0,
        MemtoReg    => MemtoReg_0,
        ALUControl  => ALUControl_0,
        ImmSrc      => ImmSrc_0,
        RegWrite    => RegWrite_0,
        MemWrite    => MemWrite_0,
        FlagsWrite  => FlagsWrite_0,
        INSTR       => Instr,
        flags       => FLAG,
        PCSrc       => PCSrc_0,
        PC_out      => PCReg,
        ALUResult   => ALURes,
        Result      => Res
    );
    
    Control_Unit_Map : Control_Unit 
    port map(
        Instr       => INSTR,
        FLAGS       => FLAG,
        RegSrc      => RegSrc_0,
        ALUSrc      => ALUSrc_0,
        MemtoReg    => MemtoReg_0,
        ALUControl  => ALUControl_0,
        ImmSrc      => ImmSrc_0,
        RegWrite    => RegWrite_0,
        MemWrite    => MemWrite_0,
        FlagsWrite  => FlagsWrite_0,
        PCSrc       => PCSrc_0
    );
    
    Instruction <= INSTR;
    PC          <= PCReg;
    ALUResult   <= ALURes;
    WriteData   <= MemWrite_0;
    Result      <= Res;

end Structural;
