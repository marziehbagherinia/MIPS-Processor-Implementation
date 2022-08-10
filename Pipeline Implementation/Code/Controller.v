`timescale 1ps/1ps
module Controller(
       rst,
       equalRegs,
       opCode,
       funcIn,
       funcOut,
       memRead,
       memWrite,
       PCSrc,
       aluSrc,
       regDst,
       regWrite,
       memToReg,
       beq,
       bne,
       j,
       immediate
       );
       
    input rst,
          equalRegs;
    input [5:0] opCode,
                funcIn;
    output reg [5:0] funcOut;
    output reg [1:0] PCSrc;
    output reg memRead,
               memWrite,
               aluSrc,
               regDst,
               regWrite,
               memToReg,
               beq,
               bne,
               j,
               immediate;
              
    parameter LW    = 6'b100011, SW   = 6'b101011,
              BEQ   = 6'b000100, BNE  = 6'b000101,
              ADDI  = 6'b001000, ANDI = 6'b001100,
              RTYPE = 6'b000000, J    = 6'b000010,
              NOP   = 6'b000001;   
    
    parameter ADDF = 6'b100000,
              ANDF = 6'b100100, 
   
          NOPF = 6'b000000; 

    always @(*) begin
        if (rst) begin
            memRead   = 0;
            memWrite  = 0;
            aluSrc    = 0;
            regDst    = 0;
            regWrite  = 0;
            memToReg  = 0;
            immediate = 0;            
            PCSrc     = 2'b00;
            funcOut   = NOPF;
            beq = 0;
            bne = 0;
            j   = 0;            
        end
        else begin
            memRead   = 0;
            memWrite  = 0;
            aluSrc    = 0;
            regDst    = 0;
            regWrite  = 0;
            memToReg  = 0;
            immediate = 0;            
            PCSrc     = 2'b00;
            funcOut   = NOPF;
            beq = 0;
            bne = 0;
            j   = 0; 
            
            case(opCode)
            LW: begin
                aluSrc   = 1; 
                regWrite = 1;
                memRead  = 1;
                memToReg = 1;                
                funcOut  = ADDF;
            end
            SW: begin
                aluSrc   = 1;
                memWrite = 1;
                funcOut  = ADDF;  
            end
            ADDI: begin
                aluSrc    = 1;
                regWrite  = 1;
                funcOut   = ADDF;
                immediate = 1;
            end
            ANDI: begin
                aluSrc    = 1; 
                regWrite  = 1;
                funcOut   = ANDF;
                immediate = 1;
            end
            RTYPE: begin
                regWrite = 1;
                regDst   = 1; 
                funcOut  = funcIn;
            end
            BEQ:begin
                if(equalRegs == 1)
                  PCSrc = 2'b01; 
                else 
                  PCSrc = 2'b00;
                beq = 1;
            end                   
            BNE: begin
                if(equalRegs == 1)
                   PCSrc = 2'b00;
                else 
                   PCSrc = 2'b01;
                bne = 1;
            end
            J: begin                         
                PCSrc = 2'b10;
                j = 1;
           end
           NOP: begin
                memRead   = 0;
                memWrite  = 0;
                aluSrc    = 0;
                regDst    = 0;
                regWrite  = 0;
                memToReg  = 0;
                immediate = 0;            
                PCSrc     = 2'b00;
                funcOut   = NOPF;
                beq = 0;
                bne = 0;
                j   = 0; 
           end
          endcase
        end
    end
endmodule