`timescale 1ps/1ps
module TestBench();
    parameter CLK = 100;
    reg clk = 0;
    reg rst = 0;
    PiplineMips UUT(
        .clk(clk),
        .rst(rst)
    );
    always #CLK clk = ~clk;
    initial begin 
        #(CLK) rst = 1;
        #(3*CLK) rst = 0;
        #(1000*CLK)
        $stop;
    end
endmodule