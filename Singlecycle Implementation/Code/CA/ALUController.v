`timescale 1ps/1ps
module aluCU (
    rst,
    aluOp,
    aluSub,
    aluAdd,
    aluAnd,
    aluFunc,
    aluCURes,
    jr
    );
    
    input rst,
          aluOp,
          aluSub,
          aluAdd,
          aluAnd;
          
    input [5:0]aluFunc;
    output reg [2:0]aluCURes;
    output reg jr;
               
    parameter ADD = 6'b100000, SUB = 6'b100010,
              AND = 6'b100100, OR = 6'b100101,
              SLT = 6'b101010, JR = 6'b001000;          

    always @(*) begin
        if (rst) begin
           aluCURes = 3'b0;
           jr = 1'b0;
        end
        else begin
           aluCURes = 3'b0;
           jr = 1'b0;
           if (aluAdd) begin
             aluCURes = 3'b001;
           end
           else if (aluSub) begin
              aluCURes = 3'b010;
            end
           else if(aluAnd) begin
              aluCURes = 3'b011;
           end
           else if (aluOp) begin
              case(aluFunc)
                ADD : begin
                   aluCURes = 3'b001;
                end
                SUB : begin
                    aluCURes = 3'b010;
                end
                AND : begin
                    aluCURes = 3'b011;
                end          
                OR : begin
                    aluCURes = 3'b100;
                end
                SLT : begin
                    aluCURes = 3'b101;
                end
                JR : begin
                    jr = 1'b1;
                end
              endcase
            end
        end
    end
endmodule