`timescale 1ps/1ps
module mux2(
    sel,
    inp1,
    inp2,
    out
    );
    parameter n;
    input sel;
    input [n-1:0]inp1, inp2;
    output [n-1:0]out;

    assign out = sel ? inp1 : inp2;
endmodule