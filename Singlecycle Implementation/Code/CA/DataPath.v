`timescale 1ps/1ps
module DP (
    clk,
    rst,
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
    branchne,
    
    opcode
    );

    input clk,
    rst,
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
    branchne;

    output [5:0] opcode;
                
    wire [31:0] PC,
                addressIM,
                adder_1Res,
                adder_2Res,
                ins,
                muxOut_5,
                signOut,
                muxOut_3,
                ALURes,
                DMReadData,
                muxOut_4,
                multOut,
                muxOut_6,
                shiftOut,
                concatOut,
                muxOut_7,
                regOut_1,
                regOut_2,
                helper;            
    
    wire [4:0] muxOut_1,
               muxOut_2;           
               
    wire [2:0] ALUCURes;                       
                
    wire zero, 
         first_pc, 
         second_pc,
         jr;//alu controller  
    
    PC pcReg(
        .clk(clk),
        .rst(rst),
        .ld(1'b1),
        .inp(PC),
        .out(addressIM)
    );
    
    Adder adder_1(
        .inp1(32'b00000000000000000000000000000100),
        .inp2(addressIM),
        .out(adder_1Res)
    );
    
    Adder adder_2(
        .inp1(adder_1Res),
        .inp2(multOut),
        .out(adder_2Res)
    );    
    
    InstMemory im(
        .address(addressIM),
        .out(ins)
    );
    
    sign_Extend se(
    .inp(ins[15:0]),
    .out(signOut)
    );
    
    mux2 #(5) mux_1(
    .sel(loadStore),
    .inp1(ins[20:16]),
    .inp2(ins[15:11]),
    .out(muxOut_1)
    );
    
    mux2 #(5) mux_2(
    .sel(jal),
    .inp1(5'b11111),
    .inp2(muxOut_1),
    .out(muxOut_2)
    );    
    
    regFile rf( 
       .readReg1(ins[25:21]), 
       .readReg2(ins[20:16]),
       .writeReg(muxOut_2),
	     .writeData(muxOut_5),
	
	     .writeEn(regWrite),
	     .rst(rst),
	     .clk(clk),

	     .readData1(regOut_1),
	     .readData2(regOut_2)
	  );
	  
    mux2 #(32) mux_3(
      .sel(loadStore),
      .inp1(signOut),
      .inp2(regOut_2),
      .out(muxOut_3)
    );	  
	  
	  ALU alu(
      .inp1(regOut_1),
      .inp2(muxOut_3),
      .func(ALUCURes), //alu controller unit output
      .out(ALURes),
      .zero(zero)
    );
    
    DataMemory dm(
        .address(ALURes),
        .writeData(regOut_2),
        .readData(DMReadData),
        .memWrite(memWrite),
        .memRead(memRead)
    );
    
    mux2 #(32) mux_4(
      .sel(load),
      .inp1(DMReadData),
      .inp2(ALURes),
      .out(muxOut_4)
    );
    
    mux2 #(32) mux_5(
      .sel(jal),
      .inp1(adder_1Res), //pc + 4
      .inp2(muxOut_4),
      .out(muxOut_5)
    );
    
   mult_in_4 mf(
      .inp(signOut),
      .out(multOut));

   mux2 #(32) mux_6(
      .sel(first_pc),
      .inp1(adder_2Res),
      .inp2(adder_1Res),
      .out(muxOut_6)
   );
   
   Shl2 sh(
    .inp(ins[25:0]),
    .out(shiftOut)
    );
    
   Concatenator cn(
    .inp(shiftOut),
    .concatPart(adder_1Res[31:28]),
    .out(concatOut)
    );      
   
   mux2 #(32) mux_7(
      .sel(second_pc),
      .inp1(concatOut),
      .inp2(muxOut_6),
      .out(muxOut_7)
   );
   
   mux2 #(32) mux_8(
      .sel(jr),
      .inp1(regOut_1),
      .inp2(muxOut_7),
      .out(PC)
   );
   
   aluCU aluController(
    .rst(rst),
    .aluOp(aluOp),
    .aluSub(aluSub),
    .aluAdd(aluAdd),
    .aluAnd(aluAnd),
    .aluFunc(ins[5:0]),
    .aluCURes(ALUCURes),
    .jr(jr)
    );
    
    assign first_pc = (branch & zero) | (branchne & (~zero));
    assign second_pc = jal | jump;
    assign opcode = ins[31:26];
    
endmodule