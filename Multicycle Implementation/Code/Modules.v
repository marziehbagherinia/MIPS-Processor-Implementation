//Instruction & Data Memory
module memory(
       Clk,
       MemWrite,
       MemRead,
       Address,
       WriteData,
       MemData
       );
    
    input Clk,
          MemRead,
          MemWrite;
          
    input [31:0] Address,
                 WriteData;
    
    output [31:0] MemData;                   
  
  reg [7:0]mem[65535:0];
  
	initial
		$readmemb("data.txt", mem);

	 always @(posedge Clk) begin
		  if(MemWrite)
			 {mem[Address], mem[Address + 1], mem[Address + 2], mem[Address + 3]} <= WriteData;
	end

	assign
		MemData = (MemRead)? {mem[Address], mem[Address + 1], mem[Address + 2], mem[Address + 3]} : 32'b0;

endmodule

//PC Register
module PCReg(
       Clk,
       Rst,
       PCWrite_1,
       PCWrite_2,
       PCSource,
       PCIn_1,
       PCIn_2,
       PCIn_3,
       PCIn_4,
       PCOut     
       );

    input Clk,
          Rst,
          PCWrite_1,
          PCWrite_2;
          
     input [1:0] PCSource;
     
     input [31:0] PCIn_1,
                  PCIn_2,
                  PCIn_3,
                  PCIn_4;
     
     output reg[31:0] PCOut;
     
   	always@(posedge Clk) begin
		  if(Rst)
			PCOut <= 32'b0;
		  else begin
		    if(PCWrite_1)begin
		      if(PCWrite_2)
		        PCOut <= PCIn_4;
		      else begin  
			      case(PCSource)
				      2'b00: PCOut <= PCIn_1;
				      2'b01: PCOut <= PCIn_2;
				      2'b10: PCOut <= PCIn_3;
			      endcase
			    end
		    end
		  end
	  end

endmodule

//Instruction Register
module InstReg(
       Clk,
       IRWrite,
       IRIn,
       IROut
       );
  
  input Clk,
        IRWrite;
        
  input [31:0] IRIn;
  
  output reg [31:0] IROut;           
       
	always @(posedge Clk) begin
		if (IRWrite)
			IROut <= IRIn;
	end       
	
endmodule

//Data Register
module DataReg(
       Clk,
       DRIn,
       DROut
       );
       
  input Clk;
       
  input [31:0] DRIn;
  
  output reg [31:0] DROut;
  
 	always @(posedge Clk) begin
		DROut <= DRIn;
	end 
	
endmodule

//Register File
module RegFile(
       Clk,
       RegWrite,
       RegDst,
       Jal,
       MemtoReg,
       RFIn_1,
       RFIn_2,
       RFIn_3,
       Instruction,
       RFOut_1,
       RFOut_2
       );
       
  input Clk,
        RegWrite,
        RegDst,
        Jal,
        MemtoReg;
        
  input [31:0] RFIn_1,
               RFIn_2,
               RFIn_3,
               Instruction;
               
  output [31:0] RFOut_1,
                RFOut_2;
                             
  reg [31:0] registers [31:0];
  
	assign RFOut_1 = (Instruction[25:21] != 5'b0) ? registers[Instruction[25:21]] : 6'b0;
	assign RFOut_2 = (Instruction[20:16] != 5'b0) ? registers[Instruction[20:16]] : 6'b0;

	always @(posedge Clk) begin
		if (RegWrite)begin
		  if (Jal)
		    registers[5'b11111] <= RFIn_3;
			else begin 
			  if (RegDst)
				  registers[Instruction[15:11]] <= (MemtoReg)? RFIn_2 : RFIn_1;
			  else
				  registers[Instruction[20:16]] <= (MemtoReg)? RFIn_2 : RFIn_1;
      end
		end
	end
	
endmodule

//A % B Register
module Reg(
       Clk,
       In,
       Out
       );
       
  input Clk;
  
  input [31:0] In;
  
  output reg [31:0] Out;
  
	always@(posedge Clk) begin
		Out <= In;
	end 
	
endmodule

//ALU
module ALU (
       In_1,
       In_2,
       Function,
       Out,
       Zero
       );
       
  input [31:0] In_1,
               In_2;
  
  input [2:0] Function;
  
  output reg [31:0] Out;
  
  output Zero;                  
       
	assign Zero = (Out == 0); //Zero == 1 when ALUResult is 0 (for branch)

	always @(Function or In_1 or In_2) begin
		case(Function)
		  3'b000 : Out = In_1 + In_2;
		  3'b001 : Out = In_1 - In_2;
		  3'b010 : Out = In_1 & In_2;
		  3'b011 : Out = In_1 | In_2;
		  3'b100 : Out = In_1 < In_2 ? 32'b11111111111111111111111111111111 : 32'b0;
		endcase
	end
	
endmodule