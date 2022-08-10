`timescale 1ps/1ps
module mips (
    clk,
    rst
    );

    input clk,
          rst;

    wire aluOp,
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

    wire [5:0]opcode;

    DP dp(
        .clk(clk),
        .rst(rst),
        .aluOp(aluOp),
        .aluSub(aluSub),
        .aluAdd(aluAdd),
        .aluAnd(aluAnd),
        .memRead(memRead),
        .memWrite(memWrite),
        .regWrite(regWrite),
        .loadStore(loadStore),
        .load(load),
        .jump(jump),
        .jal(jal),
        .branch(branch),
        .branchne(branchne),
    
        .opcode(opcode)
    );

    CU cu(
        .rst(rst),
        .opcode(opcode),

        .aluOp(aluOp),
        .aluSub(aluSub),
        .aluAdd(aluAdd),
        .aluAnd(aluAnd),
        .memRead(memRead),
        .memWrite(memWrite),
        .regWrite(regWrite),
        .loadStore(loadStore),
        .load(load),
        .jump(jump),
        .jal(jal),
        .branch(branch),
        .branchne(branchne)
    );
    
endmodule