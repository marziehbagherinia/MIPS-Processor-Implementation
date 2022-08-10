module Controller(Clk, Rst, OpCode, Zero, IorD, MemRead, MemWrite, MemtoReg, IRWrite, 
                PCSource, ALUSrcB, ALUSrcA, RegWrite, RegDst, PCSel, ALUOp, Jal);

	input Clk,
	      Rst,
	      Zero;
	      
	input [5:0] OpCode;

  output PCSel;
  
	output reg IorD,
	           MemWrite,
	           MemRead,
	           MemtoReg,
	           IRWrite,
             RegDst,
	           RegWrite,
	           ALUSrcA,
	           Jal;
	
	output reg [1:0] ALUOp,
	                 ALUSrcB,
	                 PCSource;

	reg PCWrite,
	    PCWriteCond_1,
	    PCWriteCond_2;
	
	reg [3:0] state,
	          nextstate;   

	//states
	parameter FETCH      = 4'b0000;
	parameter DECODE     = 4'b0001;
	parameter MEMADRCOMP = 4'b0010;
	parameter MEMACCESSL = 4'b0011; //Load1
	parameter MEMREADEND = 4'b0100; //Load2
	parameter MEMACCESSS = 4'b0101; //Store
	parameter EXECUTION  = 4'b0110; 
	parameter RTYPEEND   = 4'b0111;
	parameter BEQ        = 4'b1000;
	parameter BNE        = 4'b1001;
  parameter J          = 4'b1010;
  parameter JAL        = 4'b1011;
  parameter ADDI       = 4'b1100;
	parameter ANDI       = 4'b1101;
	parameter ANDADDEND  = 4'b1110;
	
	assign PCSel = (PCWrite | (PCWriteCond_1 & Zero) | (PCWriteCond_2 & ~Zero));

  always@(posedge Clk) begin
    if (Rst)
		  state <= FETCH;
    else
		  state <= nextstate;
  end
	
	always@(state or OpCode) begin
      	case(state)
        FETCH: nextstate = DECODE;
        DECODE: begin
          case(OpCode)
            6'b100011:	nextstate = MEMADRCOMP;//lw
            6'b101011:	nextstate = MEMADRCOMP;//sw
            6'b000000:	nextstate = EXECUTION;//r
            6'b000100:	nextstate = BEQ;//beq
            6'b000101:	nextstate = BNE;//bne
            6'b000010:	nextstate = J;//Jump
            6'b000011:	nextstate = JAL;//jal
            6'b001000: nextstate = ADDI;
            6'b001100: nextstate = ANDI;
            default:   nextstate = FETCH;
           endcase
        end
        MEMADRCOMP: begin 
          case(OpCode)
            6'b100011: nextstate = MEMACCESSL;//lw
            6'b101011: nextstate = MEMACCESSS;//sw
            default:   nextstate = FETCH;
          endcase
        end
        MEMACCESSL: nextstate = MEMREADEND;
        MEMREADEND: nextstate = FETCH;
        MEMACCESSS:  nextstate = FETCH;
        EXECUTION:  nextstate = RTYPEEND;
        RTYPEEND:   nextstate = FETCH;
        BEQ:        nextstate = FETCH;
        BNE:        nextstate = FETCH;
        J:          nextstate = FETCH;
        JAL:        nextstate = FETCH;
        ADDI:       nextstate = ANDADDEND;
        ANDI:       nextstate = ANDADDEND;
        ANDADDEND:  nextstate = FETCH;
        default:    nextstate = FETCH;
      endcase
    end

	always@(state) begin
	  
	  {IorD, MemRead, MemWrite, MemtoReg, RegDst, IRWrite} = 6'b0;
	  {ALUSrcA, RegWrite, PCWrite, PCWriteCond_1, PCWriteCond_2, Jal} = 6'b0;
	  {PCSource, ALUSrcB, ALUOp} = 6'b00;

    	case (state)
        FETCH: begin
            MemRead = 1'b1;
            IRWrite = 1'b1;
            ALUSrcB = 2'b01;
            PCWrite = 1'b1;
        end
          
        DECODE:
	         ALUSrcB = 2'b11;
        
        MEMADRCOMP: begin
            ALUSrcA = 1'b1;
            ALUSrcB = 2'b10;
        end
        
        MEMACCESSL: begin
            MemRead = 1'b1;
            IorD    = 1'b1;
        end
        
        MEMREADEND: begin
            RegWrite = 1'b1;
	          MemtoReg = 1'b1;
            RegDst = 1'b0;
        end
        
        MEMACCESSS: begin
           MemWrite = 1'b1;
            IorD     = 1'b1;
        end
        
        EXECUTION: begin
            ALUSrcA = 1'b1;
            ALUOp   = 2'b10;
        end
          
        RTYPEEND: begin
            RegDst   = 1'b1;
            RegWrite = 1'b1;
        end
        
        BEQ: begin
            ALUSrcA = 1'b1;
            ALUOp   = 2'b01;
            PCWriteCond_1 = 1'b1;
	          PCSource = 2'b01;
        end
        
        BNE: begin
            ALUSrcA = 1'b1;
            ALUOp   = 2'b01;
            PCWriteCond_2 = 1'b1;
	          PCSource = 2'b01;
        end
        
        J: begin
            PCWrite = 1'b1;
            PCSource = 2'b10; 
        end
        
        JAL: begin
            Jal = 1'b1;
            PCWrite = 1'b1;
            PCSource = 2'b10;
            RegWrite = 1'b1;
        end
        
        ADDI: begin
            ALUSrcA = 1'b1;
            ALUSrcB = 2'b10;
            ALUOp   = 2'b00;           
        end
         
        ANDI: begin
            ALUSrcA = 1'b1;
            ALUSrcB = 2'b10;
            ALUOp   = 2'b11;         
        end
         
        ANDADDEND: begin
            RegWrite = 1'b1;
        end          
      endcase
    end
    
endmodule