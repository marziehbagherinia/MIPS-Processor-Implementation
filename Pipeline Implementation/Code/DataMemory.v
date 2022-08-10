`timescale 1ps/1ps
module DataMemory(
       address,
       writeData,
       readData,
       memWrite,
       memRead,
       clk
       );
    
    input [31:0]address;
    input [31:0]writeData;
    input memWrite, 
          memRead,
          clk;
    
    output [31:0]readData;
    
    parameter WORD = 8, LENGTH = 65536;    
    reg [WORD - 1 : 0]memory[LENGTH - 1 : 0];
    integer i;
    
    initial begin
        for (i = 0; i < LENGTH; i = i + 1) begin
            memory[i] =  8'b0;
        end
    end

    initial begin
        $readmemb("data.txt", memory); 
    end

    always @(posedge clk) begin
        if (memWrite)
            {memory[address], memory[address + 1], memory[address + 2], memory[address + 3]} <= writeData;
    end
    
    assign readData =  memRead ? {memory[address], memory[address + 1], memory[address + 2], memory[address + 3]} : 32'b0;
                      
endmodule