library verilog;
use verilog.vl_types.all;
entity ALUController is
    port(
        AluOp           : in     vl_logic_vector(1 downto 0);
        FnField         : in     vl_logic_vector(5 downto 0);
        AluCtrl         : out    vl_logic_vector(2 downto 0);
        Jr              : out    vl_logic
    );
end ALUController;
