`timescale 1ps/1ps
module MEM_WBReg(
       clk,
       rst,
       MEM_WB,
       MEM_rd,
       MEM_data,
       MEM_address,
       WB_WB,
       WB_rd,
       WB_memData,
       WB_memAddress
       );
    
    input clk, 
          rst;
    input [1:0] MEM_WB;
    input [4:0] MEM_rd;    
    input [31:0] MEM_data;
    input [31:0] MEM_address;

    output reg [1:0] WB_WB;
    output reg [4:0] WB_rd;
    output reg [31:0] WB_memData;
    output reg [31:0] WB_memAddress;

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            WB_WB <= 2'b0;
            WB_rd <= 5'b0;
            WB_memData    <= 32'b0;
            WB_memAddress <= 32'b0;
        end
        else begin
            WB_WB <= MEM_WB;
            WB_rd <= MEM_rd;
            WB_memData    <= MEM_data;
            WB_memAddress <= MEM_address;
        end
    end 
endmodule