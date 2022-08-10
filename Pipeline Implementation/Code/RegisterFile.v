`timescale 1ps/1ps
module RegisterFile(
       clk, 
       regWrite,
       readReg1,
       readReg2, 
       writeReg, 
       writeData,  
       readData1, 
       readData2
       );

	input clk,
	      regWrite;
	input [4:0] readReg1, 
	            readReg2, 
	            writeReg;
	input [31:0] writeData;
	output [31:0] readData1, readData2;
	
	reg [31:0]Registers[0:31];
	integer i;
	
	initial begin
        for(i = 0; i < 32; i = i+1)
            Registers[i] = 32'b0;
	end

	always @(negedge clk) begin
		if (regWrite) begin
            if (writeReg != 5'b0)
			    Registers[writeReg] <= writeData;
		end
	end
	
	assign readData1 = Registers[readReg1];
	assign readData2 = Registers[readReg2];
	
endmodule