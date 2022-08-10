`timescale 1ps/1ps

//------Adder------
module Adder(
       inp1,
       inp2,
       out
       );
       
    parameter n = 32;
    
    input signed [n - 1:0] inp1,
                           inp2;
    output signed [n - 1 : 0] out;

    assign out = inp1 + inp2;
endmodule

//------Concatenator------
module Concatenator(
       inp,
       concatPart,
       out
       );
    parameter nInp,
              nConcat;
    
    input  [nInp - 1 : 0] inp;
    input  [nConcat - 1 : 0] concatPart;
    output [nConcat + nInp - 1 : 0] out;
    
    assign out = {concatPart, inp};
endmodule

//------Comparatpr------
module Comparator (
       inp1,
       inp2,
       equal
       );
    
    parameter n;
    
    input [n - 1 : 0]inp1,
                     inp2;
    output equal;
    
    assign equal = (inp1 == inp2);
endmodule

//------SignExtender-----
module SignExtender(
       inp,
       out
       );
    
    input  [15 : 0] inp;
    output [31 : 0] out;
    
    wire [15:0] ext;
    
    assign ext = inp[15] ? {(16){1'b1}} : {(16){1'b0}};
    
    assign out = {ext, inp};
endmodule

//------ShiftLeft-----
module shift2Left (
       inp,
       out
       );
    
    input  [31 : 0]inp;
    output [31 : 0]out;

    assign out = {inp[29:0] ,{(2){1'b0}}};
endmodule

//------Multiplexer2to1-----
module MUX2 (
       sel,
       inp1,
       inp2,
       out
       );
    
    parameter n;
    
    input  sel;
    input  [n - 1:0]inp1, inp2;
    output [n - 1:0]out;

    assign out = sel ? inp2 : inp1;
endmodule

//------Multiplexer3to1-----
module MUX3 (
       sel,
       inp1,
       inp2,
       inp3,
       out
       );
  
    parameter n;
   
    input  [1:0] sel;
    input  [n - 1 : 0] inp1, inp2, inp3;
    output [n - 1 : 0] out;
    
    
    assign out = sel == 2'b00 ? inp1 : 
                 sel == 2'b01 ? inp2 : 
                 sel == 2'b10 ? inp3 :
                 out;
endmodule