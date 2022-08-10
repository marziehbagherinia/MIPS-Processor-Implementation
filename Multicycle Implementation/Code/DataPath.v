module DataPath(Clk, Rst, IorD, MemRead, MemWrite, MemtoReg, IRWrite, PCSource, ALUSrcB, 
                ALUSrcA, RegWrite, RegDst, PCSel, Jal, ALUCtrl, Jr, OpCode, Zero, Function);

	input Clk,
	      Rst,
	      IorD,
	      MemWrite,
	      MemRead,
	      MemtoReg,
	      IRWrite,
	      RegDst,
	      RegWrite,
	      ALUSrcA,
	      PCSel,
	      Jal,
	      Jr;
	      
	input [1:0] PCSource,
	            ALUSrcB;

	input [2:0] ALUCtrl;
  
  output Zero;
	output [5:0] OpCode;
	output [5:0] Function;

	reg [31:0] OpB;
  
  wire [31:0] A,
              B,
              PC,
              OpA,
              MemData,
              MemDataReg,
              ReadData_1,
              ReadData_2,
              Address,
              J_Address, //jal & j
              ALUOut,
              ALUResult,
              Instruction;
              
	assign Function = Instruction[5:0];
	assign OpCode = Instruction[31:26];

//Data and Instruction Memory
	assign Address =(IorD)? ALUOut : PC;
			
	memory IDM(
    .Clk(Clk),
    .MemWrite(MemWrite),
    .MemRead(MemRead),
    .Address(Address),
    .WriteData(B),
    .MemData(MemData)
    );	

//PC logic
	assign J_Address = {PC[31:28], Instruction[25:0], 2'b0};
	
	PCReg PCR(
     .Clk(Clk),
     .Rst(Rst),
     .PCWrite_1(PCSel),
     .PCWrite_2(Jr),
     .PCSource(PCSource),
     .PCIn_1(ALUResult),
     .PCIn_2(ALUOut),
     .PCIn_3(J_Address),
     .PCIn_4(A),
     .PCOut(PC)
     );

//Instruction Register
	InstReg IR(
       .Clk(Clk),
       .IRWrite(IRWrite),
       .IRIn(MemData),
       .IROut(Instruction)
       );

//Data Register
	DataReg DR(
       .Clk(Clk),
       .DRIn(MemData),
       .DROut(MemDataReg)
       );

//Register File
	RegFile RF(
       .Clk(Clk),
       .RegWrite(RegWrite),
       .RegDst(RegDst),
       .Jal(Jal),
       .MemtoReg(MemtoReg),
       .RFIn_1(ALUOut),
       .RFIn_2(MemDataReg),
       .RFIn_3(PC),
       .Instruction(Instruction),
       .RFOut_1(ReadData_1),
       .RFOut_2(ReadData_2)
       );

	//A and B registers
	Reg AR(
      .Clk(Clk),
      .In(ReadData_1),
      .Out(A)
       );
   
 	Reg BR(
      .Clk(Clk),
      .In(ReadData_2),
      .Out(B)
       );


	//ALU
	assign OpA = (ALUSrcA) ? A : PC;

	always@(ALUSrcB or B or Instruction[15:0])begin
		case(ALUSrcB)
		  2'b00 : OpB = B;
		  2'b01 : OpB = 32'b00000000000000000000000000000100;
		  2'b10 : OpB = {{(16){Instruction[15]}},Instruction[15:0]};
		  2'b11 : OpB = {{(14){Instruction[15]}},Instruction[15:0], 2'b0};
		endcase
	end
	
	ALU Alu(
       .In_1(OpA),
       .In_2(OpB),
       .Function(ALUCtrl),
       .Out(ALUResult),
       .Zero(Zero)
       );

//ALUOut Register
 	Reg ALUR(
      .Clk(Clk),
      .In(ALUResult),
      .Out(ALUOut)
      );

endmodule