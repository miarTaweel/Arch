module Mux2to1(
    input wire [15:0] in0,    // 16-bit input 0
    input wire [15:0] in1,    // 16-bit input 1
    input wire  sel,          // 1-bit selector
    output reg [15:0] out     // 16-bit output
);


    always @(*) begin
        case (sel)
            1'b0: out = in0;  
            1'b1: out = in1;  
        endcase
    end

endmodule


