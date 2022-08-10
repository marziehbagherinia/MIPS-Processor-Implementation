`timescale 1ps/1ps
module CU (
    rst,
    opcode,

    aluOp,
    aluSub,
    aluAdd,
    aluAnd,
    memRead,
    memWrite,
    regWrite,
    loadStore,
    load,
    jump,
    jal,
    branch,
    branchne
    );
    
    input rst;
    input [5:0]opcode;
    output reg aluOp,
    aluSub,
    aluAdd,
    aluAnd,
    memRead,
    memWrite,
    regWrite,
    loadStore,
    load,
    jump,
    jal,
    branch,
    branchne;
    
    parameter ALU = 6'b0;
    parameter ADDI = 6'b001000, ANDI = 6'b001100, LW = 6'b100011, SW = 6'b101011, BEQ = 6'b000100, BNE = 6'b000101;
    parameter JUMP = 6'b000010, JAL = 6'b000011;

    always @(*) begin
        if (rst) begin
            aluOp = 0;
            memRead = 0;
            memWrite = 0;
            regWrite = 0;
            loadStore = 0;
            jump = 0;
            jal = 0;
            load = 0;
            branch = 0;
            branchne = 0;
            aluSub = 0;
            aluAdd = 0;
        end
        else begin
            aluOp = 0;
            memRead = 0;
            memWrite = 0;
            regWrite = 0;
            loadStore = 0;
            jump = 0;
            jal = 0;
            load = 0;
            branch = 0;
            branchne = 0;
            aluSub = 0;
            aluAdd = 0;
            case(opcode)
              ALU: begin
                aluOp = 1;
                regWrite = 1;
              end
              ADDI: begin
                aluAdd = 1;
                loadStore = 1;
                regWrite = 1;
              end
              ANDI: begin
                aluAnd = 1;
                loadStore = 1;
                regWrite = 1;
              end
              LW: begin
                loadStore = 1;
                load = 1;
                memRead = 1;
                regWrite = 1;
                aluAdd = 1;
              end
              SW: begin
                loadStore = 1;
                memWrite = 1;
                aluAdd = 1;
              end
              BEQ: begin
                branch = 1;
                aluSub = 1;
              end
              BNE: begin
                branchne = 1;
                aluSub = 1;
              end
              JUMP: begin
                jump = 1;
              end
              JAL: begin
                jal = 1;
              end
            endcase
        end
    end
endmodule