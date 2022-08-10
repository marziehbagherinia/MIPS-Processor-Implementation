module ForwardingUnit (
       MEM_WB,
       MEM_rd,
       WB_WB,
       WB_rd,
       EXE_rs,
       EXE_rt,
       immediate,
       selA,
       selB
       );
       
    input MEM_WB,
          WB_WB,
          immediate;
          
    input[4:0] EXE_rs,
               EXE_rt,
               MEM_rd,
               WB_rd;
               
    output [1:0] selA,
                 selB;

    assign selA = (MEM_WB == 1 && MEM_rd != 5'b0 && MEM_rd == EXE_rs) ? 2'b01 :
	                (WB_WB  == 1 && WB_rd  != 5'b0 && WB_rd  == EXE_rs) ? 2'b10 :
	                 2'b00;

    assign selB = (MEM_WB == 1 &&  MEM_rd != 5'b0 &&  MEM_rd == EXE_rt && immediate != 1) ? 2'b01 :
	                (WB_WB  == 1 &&  WB_rd  != 5'b0 &&  WB_rd  == EXE_rt && immediate != 1) ? 2'b10 :
	                 2'b00;

endmodule