`timescale 1ps/1ps
module InstructionMemory(
    address,
    out
    );
    
    parameter WORD = 8, LENGTH = 65536;
    parameter NOP = 32'b00000100000000000000000000000000;
    input [31:0]address;
    output [31:0]out;
    reg [WORD - 1:0]memory[LENGTH - 1:0];
    
    integer i;
    initial begin
        for (i = 0; i < LENGTH; i = i + 4) begin
            {memory[i], memory[i + 1], memory[i + 2], memory[i + 3]} = NOP;
        end
    end

    initial begin 
        $readmemb("Instruction.txt", memory);
    end

    assign out = {memory[address], memory[address + 1], memory[address + 2], memory[address + 3]};
endmodule