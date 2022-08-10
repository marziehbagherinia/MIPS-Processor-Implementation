`timescale 1ps/1ps
module ID_EXEReg(
       clk,
       rst,
       ID_MEM,
       ID_WB,
       ID_EXE,
       ID_rs,
       ID_rt,
       ID_rd,       
       ID_readD1,
       ID_readD2,
       ID_address,
       EXE_MEM,       
       EXE_WB,
       EXE_EXE,
       EXE_rs,       
       EXE_rt,
       EXE_rd,       
       EXE_readD1,
       EXE_readD2,
       EXE_address
       );
       
    input rst,
          clk;
    input [1:0] ID_MEM,
                ID_WB;
    input [4:0] ID_EXE, 
                ID_rs, 
                ID_rt,
                ID_rd;
    input[31:0] ID_readD1,
                ID_readD2,
                ID_address;
                
    output reg [1:0] EXE_MEM,
                     EXE_WB;
    output reg [4:0] EXE_EXE,
                   	 EXE_rs, 
                     EXE_rt, 
                     EXE_rd;
    output reg [31:0] EXE_readD1,
                      EXE_readD2,
                      EXE_address;

    always@(posedge clk,posedge rst)begin
        if(rst) begin
            EXE_MEM <= 2'b0;
            EXE_WB <= 2'b0;
            EXE_EXE <= 5'b0;
            EXE_rs <= 5'b0;            
            EXE_rt <= 5'b0;
            EXE_rd <= 5'b0;            
            EXE_readD1 <= 32'b0;
            EXE_readD2 <= 32'b0;
            EXE_address <= 32'b0;
      end
      else begin
            EXE_MEM <= ID_MEM;        
            EXE_WB <= ID_WB;
            EXE_EXE <= ID_EXE;
            EXE_rs <= ID_rs;
            EXE_rt <= ID_rt;
            EXE_rd <= ID_rd;            
            EXE_readD1 <= ID_readD1;
            EXE_readD2 <= ID_readD2;
            EXE_address <= ID_address;
      end
    end
endmodule