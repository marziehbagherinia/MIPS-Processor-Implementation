`timescale 1ps/1ps
module ALU(
       inp1,
       inp2,
       func,
       out
       );
       
    input [2 : 0] func;
    input [31 : 0] inp1,
                   inp2;
    output reg [31 : 0] out;

    parameter  ADD = 3'b010, SUB = 3'b110, 
               AND = 3'b000, OR  = 3'b001,
               SLT = 3'b111, NOP = 3'b011;
                 
    always @(*) begin
      out = 32'b0;
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
    end                                      
endmodule