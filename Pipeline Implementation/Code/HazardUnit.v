`timescale 1ps/1ps
module HazardUnit (
       ID_EXE_memRead,
       EXE_regWrite,
       MEM_memRead,
       MEM_regWrite,       
       beq, 
       bne, 
       jump,
       equal,       
       ID_rs, 
       ID_rt, 
       EXE_rd, 
       MEM_rd,
       IF_ID_write,
       PC_write, 
       IF_Nop,
       IF_Flush
       );

    input ID_EXE_memRead,
         	MEM_memRead,
          EXE_regWrite,
          MEM_regWrite,         	
          beq, 
          bne, 
          equal,
          jump;

    input [4:0] ID_rs, 
                ID_rt, 
                EXE_rd, 
                MEM_rd;

    output reg IF_ID_write,
               PC_write, 
               IF_Nop,
               IF_Flush;

    reg stall = 0;
    wire lw_EXE,
         lw_MEM,
         RType_EXE, 
         RType_MEM,  
         dataDep_EXE, 
         dataDep_MEM;
         
    assign lw_EXE = ID_EXE_memRead;
    assign lw_MEM = MEM_memRead;
    assign RType_EXE = EXE_regWrite;
    assign RType_MEM = MEM_regWrite;
    assign dataDep_EXE = (EXE_rd != 5'b0 && (EXE_rd == ID_rs || EXE_rd == ID_rt));
    assign dataDep_MEM = (MEM_rd != 5'b0 && (MEM_rd == ID_rs || MEM_rd == ID_rt));
    
    always@(*) begin
        IF_ID_write = 1;
        PC_write = 1;
        IF_Nop = 1;
        IF_Flush = 0;
        stall = 0;
        //1-
        if (dataDep_EXE && lw_EXE) begin
            stall = 1;
            IF_ID_write = 0;
            PC_write = 0;
            IF_Nop = 0;
        end
        //2-
        if (lw_MEM && dataDep_MEM && (beq || bne)) begin
            stall = 1;
            IF_ID_write = 0;
            PC_write = 0;
            IF_Nop = 0;
        end
        //3-
        if (RType_EXE && (beq || bne) && dataDep_EXE) begin
            stall = 1;
            IF_ID_write = 0;
            PC_write = 0;
            IF_Nop = 0;
        end
        //4-
        if (RType_MEM && (beq || bne) && dataDep_MEM) begin
            stall = 1;
            IF_ID_write = 0;
            PC_write = 0;
            IF_Nop = 0;
        end
        //5-
        if (jump && ~stall) begin
            IF_Nop = 0;
            IF_Flush = 1;
        end
        //6-
        if ((beq && equal && ~stall) || (bne && ~equal && ~stall)) begin
            IF_Nop = 0;
            IF_Flush = 1;
        end
    end
endmodule