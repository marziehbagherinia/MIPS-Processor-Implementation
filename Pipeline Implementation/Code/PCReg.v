`timescale 1ps/1ps
module PCReg(
       clk,
       rst,
       ld,
       clr,
       inp,
       out
       );

    input clk,
          rst,
          ld,
          clr;
    input [31:0] inp; 
    output reg [31:0] out;
   
    always @(posedge clk, posedge rst) begin
        if (rst) 
            out <= {(32){1'b0}};
        else begin
            if(clr) 
                out <= {(32){1'b0}};
            else 
                if(ld) 
                    out <= inp;
                else 
                    out <= out;
        end
    end
endmodule