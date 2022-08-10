library verilog;
use verilog.vl_types.all;
entity Reg is
    port(
        Clk             : in     vl_logic;
        \In\            : in     vl_logic_vector(31 downto 0);
        \Out\           : out    vl_logic_vector(31 downto 0)
    );
end Reg;
