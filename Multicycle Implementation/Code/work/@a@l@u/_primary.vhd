library verilog;
use verilog.vl_types.all;
entity ALU is
    port(
        In_1            : in     vl_logic_vector(31 downto 0);
        In_2            : in     vl_logic_vector(31 downto 0);
        \Function\      : in     vl_logic_vector(2 downto 0);
        \Out\           : out    vl_logic_vector(31 downto 0);
        Zero            : out    vl_logic
    );
end ALU;
