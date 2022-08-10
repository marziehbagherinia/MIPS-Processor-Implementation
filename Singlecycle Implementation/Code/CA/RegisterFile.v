`timescale 1ps/1ps 
 module regFile ( 
   readReg1, 
   readReg2,
   writeReg,
	 writeData,
	
	 writeEn,
	 rst,
	 clk,

	 readData1,
	 readData2,
	);
	
	input [4:0] readReg1, readReg2, writeReg;
	input [31:0] writeData;
	input writeEn, rst, clk;
	output [31:0]readData1, readData2;
	
	integer i;
	reg [31:0] registers[31:0];
	
	reg [4:0] reg1 = 5'b0;
	reg [4:0] reg2 = 5'b0;
	reg [4:0] reg3 = 5'b0;
	
	always @(readReg1, readReg2, writeReg) begin
		reg1 = readReg1;
		reg2 = readReg2;
		reg3 = writeReg;
	end
					
	always @(posedge rst,posedge clk) begin
		if(rst) begin
		  for (i = 0; i < 32; i = i + 1) begin
            registers[i] <= 32'b0;
      end
    end
    else if(writeEn) begin
        registers[reg3] <= writeData;  
    end
	end
	
	assign readData1 = registers[reg1];
	assign readData2 = registers[reg2];
	endmodule