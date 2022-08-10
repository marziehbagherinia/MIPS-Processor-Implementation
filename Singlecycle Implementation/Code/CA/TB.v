`timescale 1ps/1ps
module TestBench ();
    parameter CLK = 100;
    reg clk = 0;
    reg rst = 0;
    mips UUT(
        .clk(clk),
        .rst(rst)
    );
    always #CLK clk = ~clk;
    initial begin 
        #(CLK) rst = 1;
        #(CLK) rst = 0;
        #(200*CLK)
        $stop;
    end
endmodule