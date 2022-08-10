`timescale 1ps/1ps
module ALUController (
       rst,
       func,
       aluFunc
       );
    
    input rst;
    input [5:0] func;
    output reg [2:0] aluFunc;
    
    parameter  ADDF = 6'b100000, SUBF = 6'b100010,
               ANDF = 6'b100100, ORF  = 6'b100101,
               SLTF = 6'b101010, NOPF = 6'b000000;
               
    parameter  ADD = 3'b010, SUB = 3'b110, 
               AND = 3'b000, OR  = 3'b001,
               SLT = 3'b111, NOP = 3'b011;

    always @(*) begin
        if (rst) begin
            aluFunc = NOP; 
        end
        else begin
            aluFunc = NOP;
            case(func)
            ADDF : begin aluFunc = ADD;
                    end
            SUBF : begin aluFunc = SUB;
                    end
            ANDF : begin aluFunc = AND;
                    end
            ORF : begin aluFunc = OR;
                    end
            SLTF : begin aluFunc = SLT;
                    end
            endcase
        end
    end
endmodule