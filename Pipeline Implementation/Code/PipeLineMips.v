`timescale 1ps/1ps
module PiplineMips(
    clk,
    rst
    );

    input clk,
          rst;
    
    wire memRead,
         memWrite,
         aluSrc,
         regDst,
         regWrite,
         memToReg;
  
    wire [2:0] aluOp;             
    
    //IF:
    wire PcWrite;
    
    wire [1:0]  PcSrc;    
    wire [31:0] PcOut,
                PcIn, 
                If_Pc, 
                If_Inst, 
                jAddress, 
                brAddress;
    
    //ID----------------------:
    wire eq,
         bne, 
         beq, 
         j, 
         immediate,
         If_Nop,
         If_Flush,
         If_IdWrite;
         
    wire [1:0] Id_Mem,
               Id_Wb;
    
    wire [4:0] Id_EXE;
    wire [5:0] funcOut;
    
    wire [8:0] ctrlIn, 
               ctrlOut;

    wire [29:0] concat1Out;         
    
    wire [31:0] Id_Inst,
                Id_Pc, 
                Id_address,
                Id_readData1,
                Id_readData2,
                Id_addressSh;

    //EX:
    wire [1:0] Exe_Mem,
               Exe_Wb,
               selA,
               selB;
     
    wire [4:0] Exe_Exe,
               Exe_rs,
               Exe_rt, 
               Exe_rd, 
               Exe_rdF;
    
    wire [31:0] Exe_readData1, 
                Exe_readData2, 
                Exe_address,
                Exe_AluD,
                aluIn1,
                aluIn2, 
                aluRes;
    
    //MEM:
    wire [1:0] Mem_Mem,
               Mem_Wb;
               
    wire [4:0] Mem_rd;
    
    wire [31:0] memAdr,
                memData,
                memOut;
                
    //WB---------------------:
    
    wire [1:0] Wb_Wb;
    
    wire [4:0] Wb_rd;
    
    wire [31:0] Wb_readData, 
                Wb_address, 
                Wb_writeData;
    
    assign ctrlIn = {aluSrc, regDst, aluOp, memWrite, memRead, regWrite,  memToReg};
    assign Id_EXE = ctrlOut[8:4];
    assign Id_Mem = ctrlOut[3:2];
    assign Id_Wb  = ctrlOut[1:0];                

    //IF:
    InstructionMemory instructionMemory(
       .address(PcOut),
       .out(If_Inst)
    );

    PCReg pcReg(
       .clk(clk),
       .rst(rst),
       .ld(PcWrite),
       .clr(1'b0),
       .inp(PcIn),
       .out(PcOut)
    );

    Adder adder1(
       .inp1(32'd4),
       .inp2(PcOut),
       .out(If_Pc)
    );

    mux3 #(32) m1(
       .sel(PcSrc),
       .inp1(If_Pc),
       .inp2(brAddress),
       .inp3(jAddress),
       .out(PcIn)
    );

    //IF_ID:
    IF_IDReg If_IdReg(            
       .clk(clk),
       .rst(rst),
       .IF_IDWrite(If_IdWrite),
       .IF_PC(If_Pc),
       .IF_Inst(If_Inst),
       .IF_Flush(If_Flush),
       .ID_PC(Id_Pc),
       .ID_Inst(Id_Inst)  
    );


    //ID:
    Controller CU(
       .rst(rst),
       .equalRegs(eq),
       .opCode(Id_Inst[31:26]),
       .funcIn(Id_Inst[5:0]),
       .funcOut(funcOut),
       .memRead(memRead),
       .memWrite(memWrite),
       .PCSrc(PcSrc),
       .aluSrc(aluSrc),
       .regDst(regDst),
       .regWrite(regWrite),
       .memToReg(memToReg),
       .beq(beq),
       .bne(bne),
       .j(j),
       .immediate(immediate)
       );
    
    ALUController aluCu(
       .rst(rst),
       .func(funcOut),
       .aluFunc(aluOp)
       );
           
    HazardUnit hazardUnit(
       .ID_EXE_memRead(Exe_Mem[0]),
       .EXE_regWrite(Exe_Wb[1]),
       .MEM_memRead(Mem_Mem[0]),
       .MEM_regWrite(Mem_Wb[1]),       
       .beq(beq),
       .bne(bne),
       .jump(j),
       .equal(eq),       
       .ID_rs(Id_Inst[25:21]), 
       .ID_rt(Id_Inst[20:16]), 
       .EXE_rd(Exe_rdF), 
       .MEM_rd(Mem_rd),
       .IF_ID_write(If_IdWrite),
       .PC_write(PcWrite), 
       .IF_Nop(If_Nop),
       .IF_Flush(If_Flush)
       );

    RegisterFile registerFile(
       .clk(clk), 
       .regWrite(Wb_Wb[1]),
       .readReg1(Id_Inst[25:21]),
       .readReg2(Id_Inst[20:16]), 
       .writeReg(Wb_rd), 
       .writeData(Wb_writeData), 
       .readData1(Id_readData1), 
       .readData2(Id_readData2)
    );

    Comparator #(32) comp(
       .inp1(Id_readData1),
       .inp2(Id_readData2),
       .equal(eq)
    );
    
    MUX2 #(9) m2(
       .sel(If_Nop),
       .inp1(9'b0),
       .inp2(ctrlIn),
       .out(ctrlOut)
    );    

    Concatenator #(26, 4) concat1(
       .inp(Id_Inst[25:0]),
       .concatPart(Id_Pc[31:28]),
       .out(concat1Out)
    );

    Concatenator #(2, 30) concat2(
       .inp(2'b00),
       .concatPart(concat1Out),
       .out(jAddress)
    );    

    SignExtender sE(
       .inp(Id_Inst[15:0]),
       .out(Id_address)
    );

    shift2Left shift2L(
       .inp(Id_address),
       .out(Id_addressSh)
    );

    Adder adder2(
       .inp1(Id_Pc),
       .inp2(Id_addressSh),
       .out(brAddress)
    );

    //ID_EXE:
    ID_EXEReg Id_ExeReg(
       .clk(clk),
       .rst(rst),
       .ID_MEM(Id_Mem),
       .ID_WB(Id_Wb),
       .ID_EXE(Id_EXE),
       .ID_rs(Id_Inst[25:21]),
       .ID_rt(Id_Inst[20:16]),
       .ID_rd(Id_Inst[15:11]),       
       .ID_readD1(Id_readData1),
       .ID_readD2(Id_readData2),
       .ID_address(Id_address),
       .EXE_MEM(Exe_Mem),       
       .EXE_WB(Exe_Wb),
       .EXE_EXE(Exe_Exe),
       .EXE_rs(Exe_rs),       
       .EXE_rt(Exe_rt),
       .EXE_rd(Exe_rd),       
       .EXE_readD1(Exe_readData1),
       .EXE_readD2(Exe_readData2),
       .EXE_address(Exe_address)
    );  
    
    //EXE
    ALU alu(
       .inp1(aluIn1),
       .inp2(aluIn2),
       .func(Exe_Exe[2:0]),
       .out(aluRes)
    );
    
    ForwardingUnit FU(
       .MEM_WB(Mem_Wb[1]),
       .MEM_rd(Mem_rd),
       .WB_WB(Wb_Wb[1]),
       .WB_rd(Wb_rd),
       .EXE_rs(Exe_rs),
       .EXE_rt(Exe_rt),
       .immediate(immediate),
       .selA(selA),
       .selB(selB)
    );
            
    MUX3 #(32) m3(
       .sel(selA),
       .inp1(Exe_readData1),
       .inp2(memAdr),
       .inp3(Wb_writeData),
       .out(aluIn1)
    );

    MUX3 #(32) m4(
       .sel(selB),
       .inp1(Exe_readData2),
       .inp2(memAdr),
       .inp3(Wb_writeData),
       .out(Exe_AluD)
    );
    
    MUX2 #(32) m5(
       .sel(Exe_Exe[4]),
       .inp1(Exe_AluD),
       .inp2(Exe_address),
       .out(aluIn2)
    );

    MUX2 #(5) m6(
       .sel(Exe_Exe[3]),
       .inp1(Exe_rt),
       .inp2(Exe_rd),
       .out(Exe_rdF)
    );
    
    //EXE_MEM:    
    EXE_MEMReg Exe_MemReg(
       .clk(clk),
       .rst(rst),
       .EXE_MEM(Exe_Mem),
       .EXE_WB(Exe_Wb),
       .EXE_rd(Exe_rdF),       
       .EXE_aluRes(aluRes),
       .EXE_writeData(Exe_AluD),
       .MEM_MEM(Mem_Mem),
       .MEM_WB(Mem_Wb),
       .MEM_rd(Mem_rd),
       .MEM_aluRes(memAdr),
       .MEM_writeData(memData)
    );
       
    //MEM:
    DataMemory dataMemory(
       .address(memAdr),
       .writeData(memData),
       .readData(memOut),
       .memWrite(Mem_Mem[1]),
       .memRead(Mem_Mem[0]),
       .clk(clk)
    );
    
    //MEMWB:
    MEM_WBReg Mem_WbReg(
       .clk(clk),
       .rst(rst),
       .MEM_WB(Mem_Wb),
       .MEM_rd(Mem_rd),
       .MEM_data(memOut),
       .MEM_address(memAdr),
       .WB_WB(Wb_Wb),
       .WB_rd(Wb_rd),
       .WB_memData(Wb_readData),
       .WB_memAddress(Wb_address)
    );
    
    //WB:
    MUX2 #(32) m7(
       .sel(Wb_Wb[0]),
       .inp1(Wb_address),
       .inp2(Wb_readData),
       .out(Wb_writeData)
    );
endmodule