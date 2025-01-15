library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.ALL;    -- For counting and addition
use IEEE.NUMERIC_STD.ALL;           -- For type convertions

entity Datapath is
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
end Datapath;

architecture Structural of Datapath is

-- STEP 1: Instruction Memory
    component Instruction_Memory is
    generic (
        M : positive := 32; -- data word length
        N : positive := 6 -- address length
    );
    Port (
        ADDR        : in STD_LOGIC_VECTOR(N-1 downto 0);
        DATA_OUT    : out STD_LOGIC_VECTOR(M-1 downto 0)
     );
    end component;

    component PC is     
    generic(
        M : positive := 32 -- data word length
    );
    Port ( 
        CLK     : in std_logic;
        RESET   : in std_logic;
        WE      : in std_logic;
        D       : in STD_LOGIC_VECTOR(M-1 downto 0);
        Q       : out STD_LOGIC_VECTOR(M-1 downto 0)
    );
    end component;

    component PCPlus4 is
    generic(
        M : positive := 32 -- data word length
    );
    Port (
        PC      : in  STD_LOGIC_VECTOR (M-1 downto 0);
        PCPlus4 : out  STD_LOGIC_VECTOR (M-1 downto 0)
     );
    end component;

-- STEP 2: Register File

    component Extend is
    Port ( 
        ImmSrc  : in STD_LOGIC;
        X       : in STD_LOGIC_VECTOR (23 downto 0);
        Y       : out STD_LOGIC_VECTOR (31 downto 0)
    );
    end component;
    
    component Register_File is
    generic (
        N : positive := 4; -- address length
        M : positive := 32 -- data word length
    ); 
    port (
        CLK : in STD_LOGIC;
        WE  : in STD_LOGIC;
        A1  : in STD_LOGIC_VECTOR (N-1 downto 0);
        A2  : in STD_LOGIC_VECTOR (N-1 downto 0);
        A3  : in STD_LOGIC_VECTOR (N-1 downto 0);
        R15 : in STD_LOGIC_VECTOR (M-1 downto 0);   -- R15 = PC
        WD  : in STD_LOGIC_VECTOR (M-1 downto 0);
        RD1 : out STD_LOGIC_VECTOR (M-1 downto 0);
        RD2 : out STD_LOGIC_VECTOR (M-1 downto 0)
    );
    end component;

    component Mux2To1 is
    generic (
        M : positive := 4 -- data word length
    );

    Port (
        A : in STD_LOGIC_VECTOR (M-1 downto 0);
        B : in STD_LOGIC_VECTOR (M-1 downto 0);
        S : in STD_LOGIC;
        Y : out STD_LOGIC_VECTOR (M-1 downto 0)
    );
    end component;

--STEP 3: Alu
    component ALU is
    generic (
        M : positive := 32; -- data word length
        N : positive := 3 -- command word length
    );
    Port ( 
        SRC_A           : in STD_LOGIC_VECTOR (M-1 downto 0);
        SRC_B           : in STD_LOGIC_VECTOR (M-1 downto 0);
        ALU_CONTROL     : in STD_LOGIC_VECTOR (N-1 downto 0);
        SA5             : in STD_LOGIC_VECTOR (4 downto 0);
        ALU_RESULT      : out STD_LOGIC_VECTOR (M-1 downto 0);
        ALU_Flags       : out STD_LOGIC_VECTOR (3 downto 0)
    );
    end component;

    component Status_Register is
    generic(
        N : positive := 4 -- data word length
    );
    Port ( 
        CLK     : in std_logic;
        RESET   : in std_logic;
        WE      : in std_logic;
        D       : in STD_LOGIC_VECTOR (N-1 downto 0);
        Q       : out STD_LOGIC_VECTOR (N-1 downto 0)
    );
    end component;
    

--STEP 4: Data Memory

    component Data_Memory is
    generic (
        N : positive := 5; -- address length
        M : positive := 32 -- data word length
    ); 
    port (
        CLK         : in STD_LOGIC;
        WE          : in STD_LOGIC;
        ADDR        : in STD_LOGIC_VECTOR (N-1 downto 0);
        DATA_IN     : in STD_LOGIC_VECTOR (M-1 downto 0);
        DATA_OUT    : out STD_LOGIC_VECTOR (M-1 downto 0)
    );
    end component;
    

    component MuxForStep5 is
    generic (
        M : positive := 32 -- data word length
    );
    Port (
        A : in STD_LOGIC_VECTOR (M-1 downto 0);
        B : in STD_LOGIC_VECTOR (M-1 downto 0);
        S : in STD_LOGIC;
        Y : out STD_LOGIC_VECTOR (M-1 downto 0)
    );
    end component;
    


----------------------------------------------------------------------------
-- STEP 1: Instruction Memory
signal Q_PC         : STD_LOGIC_VECTOR (M-1 downto 0);
signal DATA_OUT_IM  : STD_LOGIC_VECTOR (M-1 downto 0);
signal PCPlus4_P4   : STD_LOGIC_VECTOR (M-1 downto 0);

-- STEP 2: Register File
signal RD1_RF       : STD_LOGIC_VECTOR (M-1 downto 0);
signal RD2_RF       : STD_LOGIC_VECTOR (M-1 downto 0);
signal Y_M0         : STD_LOGIC_VECTOR (3 downto 0);
signal Y_M1         : STD_LOGIC_VECTOR (3 downto 0);
signal Y_M2         : STD_LOGIC_VECTOR (3 downto 0);
signal Y_M3         : STD_LOGIC_VECTOR (M-1 downto 0);
signal Y_EX         : STD_LOGIC_VECTOR (M-1 downto 0);
signal PCPlus4_P8   : STD_LOGIC_VECTOR (M-1 downto 0);

--STEP 3: Alu
signal ALU_RESULT_AL    : STD_LOGIC_VECTOR (M-1 downto 0);
signal ALU_Flags_AL     : STD_LOGIC_VECTOR (3 downto 0);
signal Q_SR             : STD_LOGIC_VECTOR (3 downto 0);
signal Y_M4             : STD_LOGIC_VECTOR (M-1 downto 0);

-- STEP 4: Data Memory
signal DATA_OUT_DM      : STD_LOGIC_VECTOR (M-1 downto 0);

-- STEP 5 : Results
signal Y_M5 : STD_LOGIC_VECTOR (M-1 downto 0);
signal Y_M6 : STD_LOGIC_VECTOR (M-1 downto 0);
----------------------------------------------------------------------------


    
begin

-- STEP 1: Instruction Memory
    Instruction_Memory_Map: Instruction_Memory 
    port map(
        ADDR        => Q_PC(7 downto 2),
        DATA_OUT    => DATA_OUT_IM
    );
    
    PC_Map: PC 
    port map(
        CLK     => CLK,
        RESET   => RESET,
        WE      => PCWrite,
        D       => Y_M6,
        Q       => Q_PC
    );
    
    PCPlus4_Map: PCPlus4 
    port map(
        PC      => Q_PC,
        PCPlus4 => PCPlus4_P4
    );

-- STEP 2: Register File
    Extend_Map: Extend 
    port map(
        ImmSrc  => ImmSrc,
        X       => DATA_OUT_IM(23 downto 0),
        Y       => Y_EX
    );  
    
    Register_File_Map: Register_File 
    port map(
        CLK => CLK,
        WE  => RegWrite,
        A1  => Y_M0,
        A2  => Y_M1,
        A3  => Y_M2,
        R15 => PCPlus4_P8,
        WD  => Y_M3,
        RD1 => RD1_RF,
        RD2 => RD2_RF
    );
    
    Mux2To1_Map0: Mux2To1   -- RegSrc(0)
    port map(
        A => DATA_OUT_IM(19 downto 16),
        B => "1111",
        S => RegSrc(0),
        Y => Y_M0
    );
    
    Mux2To1_Map1: Mux2To1   -- RegSrc(1) 
    port map(
        A => DATA_OUT_IM(3 downto 0),
        B => DATA_OUT_IM(15 downto 12),
        S => RegSrc(1),
        Y => Y_M1
    );
    
    Mux2To1_Map2: Mux2To1   -- RegSrc(2) 
    port map(
        A => DATA_OUT_IM(15 downto 12),
        B => "1110",
        S => RegSrc(2),
        Y => Y_M2
    );
    
    PCPlus8_Map : PCPlus4
    port map(
        PC      => PCPlus4_P4,
        PCPlus4 => PCPlus4_P8
    );

--STEP 3: Alu  
    ALU_Map: ALU 
    port map(
        SRC_A       => RD1_RF,
        SRC_B       => Y_M4,
        ALU_CONTROL => ALUCONTROL,
        SA5         => Y_EX(11 downto 7),
        ALU_RESULT  => ALU_RESULT_AL,
        ALU_Flags   => ALU_Flags_AL
    );
    
    Status_Register_Map: Status_Register 
    port map(
        CLK     => CLK,
        RESET   => RESET,
        WE      => FlagsWrite,
        D       => ALU_Flags_AL,
        Q       => Q_SR
    );
    
    MuxForStep5_Map_SrcB: MuxForStep5 
    port map(
        A => RD2_RF,
        B => Y_EX,
        S => ALUSrc,
        Y => Y_M4
    );

-- STEP 4: Data Memory
    Data_Memory_Map: Data_Memory 
    port map(
        CLK         => CLK,
        WE          => MemWrite,
        ADDR        => ALU_RESULT_AL(4 downto 0),
        DATA_IN     => RD2_RF,
        DATA_OUT    => DATA_OUT_DM
    );


-- STEP 5 : Results
    MuxForStep5_Map_WD: MuxForStep5       --For step 2, output is WD 
    port map(
        A => Y_M5,
        B => PCPlus4_P4,
        S => RegSrc(2),
        Y => Y_M3
    );
      
    MuxForStep5_Map_MREG: MuxForStep5       --MemtoReg 
    port map(
        A => ALU_RESULT_AL,
        B => DATA_OUT_DM,
        S => MemtoReg,
        Y => Y_M5
    );
    
     MuxForStep5_Map_PC: MuxForStep5 
    port map(
        A => PCPlus4_P4,
        B => Y_M5,
        S => PCSrc,
        Y => Y_M6
    );
    
    PC_out      <= Q_PC;
    instr       <= DATA_OUT_IM;
    ALUResult   <= ALU_RESULT_AL;
    Result      <= Y_M5;
    flags       <= Q_SR;
    
end Structural;
