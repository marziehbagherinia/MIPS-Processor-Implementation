library verilog;
use verilog.vl_types.all;
entity RegFile is
    port(
        Clk             : in     vl_logic;
        RegWrite        : in     vl_logic;
        RegDst          : in     vl_logic;
        Jal             : in     vl_logic;
        MemtoReg        : in     vl_logic;
        RFIn_1          : in     vl_logic_vector(31 downto 0);
        RFIn_2          : in     vl_logic_vector(31 downto 0);
        RFIn_3          : in     vl_logic_vector(31 downto 0);
        Instruction     : in     vl_logic_vector(31 downto 0);
        RFOut_1         : out    vl_logic_vector(31 downto 0);
        RFOut_2         : out    vl_logic_vector(31 downto 0)
    );
end RegFile;
