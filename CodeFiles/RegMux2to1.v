module RegMux2to1(
    input wire [2:0] in0,    // 3-bit input 0  
    input wire [2:0] in1,    // 3-bit input 1
    input wire  sel,          // 1-bit selector
    output reg [2:0] out     // 3-bit output
);


    always @(*) begin
        case (sel)
            1'b0: out = in0;  //Rd
            1'b1: out = in1;  //Rt
        endcase
    end

endmodule
