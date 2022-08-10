library verilog;
use verilog.vl_types.all;
entity DataPath is
    port(
        Clk             : in     vl_logic;
        Rst             : in     vl_logic;
        IorD            : in     vl_logic;
        MemRead         : in     vl_logic;
        MemWrite        : in     vl_logic;
        MemtoReg        : in     vl_logic;
        IRWrite         : in     vl_logic;
        PCSource        : in     vl_logic_vector(1 downto 0);
        ALUSrcB         : in     vl_logic_vector(1 downto 0);
        ALUSrcA         : in     vl_logic;
        RegWrite        : in     vl_logic;
        RegDst          : in     vl_logic;
        PCSel           : in     vl_logic;
        Jal             : in     vl_logic;
        ALUCtrl         : in     vl_logic_vector(2 downto 0);
        Jr              : in     vl_logic;
        OpCode          : out    vl_logic_vector(5 downto 0);
        Zero            : out    vl_logic;
        \Function\      : out    vl_logic_vector(5 downto 0)
    );
end DataPath;
