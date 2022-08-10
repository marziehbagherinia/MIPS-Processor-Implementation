library verilog;
use verilog.vl_types.all;
entity memory is
    port(
        Clk             : in     vl_logic;
        MemWrite        : in     vl_logic;
        MemRead         : in     vl_logic;
        Address         : in     vl_logic_vector(31 downto 0);
        WriteData       : in     vl_logic_vector(31 downto 0);
        MemData         : out    vl_logic_vector(31 downto 0)
    );
end memory;
