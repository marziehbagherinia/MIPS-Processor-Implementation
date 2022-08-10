module MIPS(Clk, Rst);

	input Clk,
      	 Rst;

	wire Zero,
	     IorD,
	     MemRead,
	     MemWrite,
	     MemToReg,
	     IRWrite,
	     ALUSrcA,
	     RegWrite,
	     RegDst,
	     PCSel,
	     Jal,
	     Jr;
	
	wire [1:0] ALUOp,
	           ALUSrcB,
	           PCSource;
	           
	wire [2:0] ALUCtrl;
	
	wire [5:0] Function,
	           OpCode;

	Controller ControlUnit(
	           .Clk(Clk), 
	           .Rst(Rst), 
	           .OpCode(OpCode),
	           .Zero(Zero), 
	           .IorD(IorD), 
	           .MemRead(MemRead), 
	           .MemWrite(MemWrite), 
	           .MemtoReg(MemtoReg), 
	           .IRWrite(IRWrite), 
             .PCSource(PCSource), 
             .ALUSrcB(ALUSrcB), 
             .ALUSrcA(ALUSrcA), 
             .RegWrite(RegWrite), 
             .RegDst(RegDst), 
             .PCSel(PCSel), 
             .ALUOp(ALUOp), 
             .Jal(Jal)
             );

  DataPath DataPathUnit(
           .Clk(Clk), 
           .Rst(Rst), 
           .IorD(IorD), 
           .MemRead(MemRead), 
           .MemWrite(MemWrite), 
           .MemtoReg(MemtoReg), 
           .IRWrite(IRWrite),
           .PCSource(PCSource), 
           .ALUSrcB(ALUSrcB), 
           .ALUSrcA(ALUSrcA), 
           .RegWrite(RegWrite), 
           .RegDst(RegDst), 
           .PCSel(PCSel), 
           .Jal(Jal), 
           .ALUCtrl(ALUCtrl), 
           .Jr(Jr), 
           .OpCode(OpCode), 
           .Zero(Zero), 
           .Function(Function)
           );
           
  	ALUController ALUControlUnit(
  	              .AluOp(ALUOp), 
  	              .FnField(Function), 
  	              .AluCtrl(ALUCtrl), 
  	              .Jr(Jr)
	               );    

endmodule