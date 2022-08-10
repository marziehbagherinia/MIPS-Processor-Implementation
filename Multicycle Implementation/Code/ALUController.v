module ALUController(AluOp, FnField, AluCtrl, Jr);

  input [1:0] AluOp;
  input [5:0] FnField; //for R-type instruction

  output reg [2:0] AluCtrl;
  output reg Jr;

  always@(AluOp or FnField)begin
   Jr = 1'b0;
   AluCtrl = 3'b0; 
	 casex({AluOp,FnField})
		  8'b00_xxxxxx:
		    AluCtrl = 3'b000; //lw / sw
		  8'b01_xxxxxx:
		    AluCtrl = 3'b001; //beq
		  8'b11_xxxxxx:
		    AluCtrl = 3'b010; //andi
		  8'b10_100000:
		    AluCtrl = 3'b000; //add
		  8'b10_100010:
		    AluCtrl = 3'b001; //sub
		  8'b10_100100:
		    AluCtrl = 3'b010; //and
		  8'b10_100101:
		    AluCtrl = 3'b011; //or
		  8'b10_101010:
		    AluCtrl = 3'b100; //slt
		  8'b10_001000:
		    begin
		      AluCtrl = 3'b110; //jr
	        Jr = 1'b1;
	     end
	 endcase
  end
  
endmodule