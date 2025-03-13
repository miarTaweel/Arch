module Mux5to1(
    input wire [15:0] in0,    // 16-bit input 0
    input wire [15:0] in1,    // 16-bit input 1
    input wire [15:0] in2,    // 16-bit input 2
    input wire [15:0] in3,    // 16-bit input 3
    input wire [15:0] in4,    // 16-bit input 4
    input wire [2:0] sel,     // 3-bit selector
    input wire pc_increment,  // Enable signal
    output reg [15:0] out     // 16-bit output
);

    always @(*) begin
        if (pc_increment) begin
            // Normal selection when pc_increment is 1
            case (sel)
                3'b000: out = in0;  // Jump (pc[15:9] || 9-bit offset)
                3'b001: out = in1;  // Branch taken (pc = pc + extended 6-bit immediate)
                3'b010: out = in2;  // RET (pc = Return address)
                3'b011: out = in3;  // PC = pc + 1
                3'b100: out = in4;  // For loop logic
                default: out = in3; // Default case
            endcase
        end else begin
            // Default output when pc_increment is 0
            out = in3; // PC = pc + 1
        end
    end

endmodule
