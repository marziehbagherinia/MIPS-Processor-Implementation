library verilog;
use verilog.vl_types.all;
entity InstReg is
    port(
        Clk             : in     vl_logic;
        IRWrite         : in     vl_logic;
        IRIn            : in     vl_logic_vector(31 downto 0);
        IROut           : out    vl_logic_vector(31 downto 0)
    );
end InstReg;
