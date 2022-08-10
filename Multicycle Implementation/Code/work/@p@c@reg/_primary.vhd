library verilog;
use verilog.vl_types.all;
entity PCReg is
    port(
        Clk             : in     vl_logic;
        Rst             : in     vl_logic;
        PCWrite_1       : in     vl_logic;
        PCWrite_2       : in     vl_logic;
        PCSource        : in     vl_logic_vector(1 downto 0);
        PCIn_1          : in     vl_logic_vector(31 downto 0);
        PCIn_2          : in     vl_logic_vector(31 downto 0);
        PCIn_3          : in     vl_logic_vector(31 downto 0);
        PCIn_4          : in     vl_logic_vector(31 downto 0);
        PCOut           : out    vl_logic_vector(31 downto 0)
    );
end PCReg;
