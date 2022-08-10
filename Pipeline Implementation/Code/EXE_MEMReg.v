`timescale 1ps/1ps
module EXE_MEMReg (
       clk,
       rst,
       EXE_MEM,
       EXE_WB,
       EXE_rd,       
       EXE_aluRes,
       EXE_writeData,
       MEM_MEM,
       MEM_WB,
       MEM_rd,
       MEM_aluRes,
       MEM_writeData
       );
    
    input clk,
          rst;
    input [1:0] EXE_MEM,
                EXE_WB;
    input [4:0] EXE_rd;               
    input [31:0] EXE_aluRes,
                 EXE_writeData;
    
    output reg [1:0] MEM_MEM,
                     MEM_WB;
    output reg [4:0] MEM_rd;
    output reg [31:0] MEM_aluRes,
                      MEM_writeData;

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            MEM_MEM <= 2'b0;
            MEM_WB  <= 2'b0;
            MEM_rd  <= 5'b0;
            MEM_aluRes <= 32'b0;
            MEM_writeData <= 32'b0;
        end
        else begin
            MEM_MEM <= EXE_MEM;
            MEM_WB  <= EXE_WB;
            MEM_rd  <= EXE_rd;
            MEM_aluRes <= EXE_aluRes;
            MEM_writeData <= EXE_writeData;
        end
    end
endmodule