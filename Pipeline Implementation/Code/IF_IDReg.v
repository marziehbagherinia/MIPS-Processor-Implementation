`timescale 1ps/1ps
module IF_IDReg(
       clk,
       rst,
       IF_IDWrite,
       IF_PC,
       IF_Inst,
       IF_Flush,
       ID_PC,
       ID_Inst   
       );

    input clk,
          rst,
          IF_Flush,
          IF_IDWrite;
    
    input [31:0] IF_PC,
                 IF_Inst;
    
    output reg [31:0] ID_PC,
                      ID_Inst;

    always@(posedge clk, posedge rst) begin
        if(rst) begin
            ID_PC <= 32'b0;
            ID_Inst <= 32'b00000100000000000000000000000000;
        end
        else begin
            if(IF_Flush) begin
                ID_PC <= 32'b0;
                ID_Inst <= 32'b00000100000000000000000000000000;
            end
            else begin
                if(IF_IDWrite)begin 
                    ID_Inst <= IF_Inst;
                    ID_PC <= IF_PC;
                end
                else begin
                    ID_Inst <= ID_Inst;
                    ID_PC <= ID_PC;
                end
            end
        end
    end
endmodule