`timescale 1ps/1ps
module PC (
    clk,
    rst,
    ld,
    inp,
    out
    );
    parameter n = 32;
    input clk,
    rst,
    ld;
    input [n-1:0]inp;
    output reg [n-1:0]out;

    always @(posedge clk, posedge rst) begin
        if (rst) out <= {(n){1'b0}};
        else begin
            if(ld) out <= inp;
            else out <= out;
        end
    end
endmodule