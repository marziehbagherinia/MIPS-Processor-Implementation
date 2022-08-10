`timescale 1ps/1ps
module Concatenator (
    inp,
    concatPart,
    out
    );
    input [27:0]inp;
    input [3:0] concatPart;
    output [31:0]out;
    assign out = {concatPart, inp};
endmodule

module sign_Extend(
    inp,
    out
    );
    input [15:0]inp;
    output [31:0]out;
    assign out = {16'b0, inp};
 endmodule
 
 module mult_in_4(
   inp,
   out);
   parameter n = 32;
   input [n - 1:0]inp;
   output [n - 1:0]out;
   assign out = {inp[29:0], 2'b00};
 endmodule
   
 module Shl2(
    inp,
    out
    );
    parameter n = 26;
    parameter no = 28;
    input [n - 1:0]inp;
    output [no - 1:0]out;
    assign out = {inp, 2'b0};
 endmodule