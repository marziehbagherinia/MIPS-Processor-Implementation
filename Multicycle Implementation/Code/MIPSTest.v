module MIPSTestBench;

	reg Clk;
	reg Rst;

	MIPS MIPSUnit(Clk, Rst);

	initial
		forever #5 Clk = ~Clk;

	initial begin
	 Clk = 0;
	 Rst = 1;
	 #10 Rst = 0;
  	#9000 $stop; 	
	end
	
endmodule