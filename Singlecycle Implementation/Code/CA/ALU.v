`timescale 1ps/1ps
module ALU (
    inp1,
    inp2,
    func,
    out,
    zero
    );
    parameter n = 32;
    input [31:0]inp1, inp2;
    input [2:0]func;
    output reg[31:0]out;
    output reg zero;

    parameter NOP = 3'b000, ADD = 3'b001, SUB = 3'b010, AND = 3'b011,
               OR  = 3'b100, SLT = 3'b101;
               
    always @(*) begin
      out = 32'b0;
      zero = 1'b0;
      case (func)
        NOP : out = 32'b0;
        ADD : out = inp1 + inp2;
        SUB : out = inp1 - inp2;
        AND : out = inp1 & inp2;
        OR  : out = inp1 | inp2;
        SLT : begin
          if (inp1 < inp2)
            out = 32'b11111111111111111111111111111111;
          else 
            out = 32'b0;
        end
      endcase
      if(out == 32'b0)
        zero = 1'b1;
    end                 
endmodule