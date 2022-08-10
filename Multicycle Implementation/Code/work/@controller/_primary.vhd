library verilog;
use verilog.vl_types.all;
entity Controller is
    generic(
        FETCH           : vl_logic_vector(0 to 3) := (Hi0, Hi0, Hi0, Hi0);
        DECODE          : vl_logic_vector(0 to 3) := (Hi0, Hi0, Hi0, Hi1);
        MEMADRCOMP      : vl_logic_vector(0 to 3) := (Hi0, Hi0, Hi1, Hi0);
        MEMACCESSL      : vl_logic_vector(0 to 3) := (Hi0, Hi0, Hi1, Hi1);
        MEMREADEND      : vl_logic_vector(0 to 3) := (Hi0, Hi1, Hi0, Hi0);
        MEMACCESSS      : vl_logic_vector(0 to 3) := (Hi0, Hi1, Hi0, Hi1);
        EXECUTION       : vl_logic_vector(0 to 3) := (Hi0, Hi1, Hi1, Hi0);
        RTYPEEND        : vl_logic_vector(0 to 3) := (Hi0, Hi1, Hi1, Hi1);
        BEQ             : vl_logic_vector(0 to 3) := (Hi1, Hi0, Hi0, Hi0);
        BNE             : vl_logic_vector(0 to 3) := (Hi1, Hi0, Hi0, Hi1);
        J               : vl_logic_vector(0 to 3) := (Hi1, Hi0, Hi1, Hi0);
        \JAL\           : vl_logic_vector(0 to 3) := (Hi1, Hi0, Hi1, Hi1);
        ADDI            : vl_logic_vector(0 to 3) := (Hi1, Hi1, Hi0, Hi0);
        ANDI            : vl_logic_vector(0 to 3) := (Hi1, Hi1, Hi0, Hi1);
        ANDADDEND       : vl_logic_vector(0 to 3) := (Hi1, Hi1, Hi1, Hi0)
    );
    port(
        Clk             : in     vl_logic;
        Rst             : in     vl_logic;
        OpCode          : in     vl_logic_vector(5 downto 0);
        Zero            : in     vl_logic;
        IorD            : out    vl_logic;
        MemRead         : out    vl_logic;
        MemWrite        : out    vl_logic;
        MemtoReg        : out    vl_logic;
        IRWrite         : out    vl_logic;
        PCSource        : out    vl_logic_vector(1 downto 0);
        ALUSrcB         : out    vl_logic_vector(1 downto 0);
        ALUSrcA         : out    vl_logic;
        RegWrite        : out    vl_logic;
        RegDst          : out    vl_logic;
        PCSel           : out    vl_logic;
        ALUOp           : out    vl_logic_vector(1 downto 0);
        \Jal\           : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of FETCH : constant is 1;
    attribute mti_svvh_generic_type of DECODE : constant is 1;
    attribute mti_svvh_generic_type of MEMADRCOMP : constant is 1;
    attribute mti_svvh_generic_type of MEMACCESSL : constant is 1;
    attribute mti_svvh_generic_type of MEMREADEND : constant is 1;
    attribute mti_svvh_generic_type of MEMACCESSS : constant is 1;
    attribute mti_svvh_generic_type of EXECUTION : constant is 1;
    attribute mti_svvh_generic_type of RTYPEEND : constant is 1;
    attribute mti_svvh_generic_type of BEQ : constant is 1;
    attribute mti_svvh_generic_type of BNE : constant is 1;
    attribute mti_svvh_generic_type of J : constant is 1;
    attribute mti_svvh_generic_type of \JAL\ : constant is 1;
    attribute mti_svvh_generic_type of ADDI : constant is 1;
    attribute mti_svvh_generic_type of ANDI : constant is 1;
    attribute mti_svvh_generic_type of ANDADDEND : constant is 1;
end Controller;
