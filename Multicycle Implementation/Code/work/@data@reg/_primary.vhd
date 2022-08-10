library verilog;
use verilog.vl_types.all;
entity DataReg is
    port(
        Clk             : in     vl_logic;
        DRIn            : in     vl_logic_vector(31 downto 0);
        DROut           : out    vl_logic_vector(31 downto 0)
    );
end DataReg;
