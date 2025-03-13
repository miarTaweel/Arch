module IR_Reg(
    input wire clk,                 // Clock signal
    input wire [15:0] instruction,  // 16-bit instruction input
    output reg [3:0] opcode,        // 4-bit opcode (MSBs of instruction)
    output reg [11:0] rest          // Remaining 12 bits of the instruction
);

always @(posedge clk) begin
    opcode <= instruction[15:12];  // Extract the 4 MSBs as opcode
    rest <= instruction[11:0];     // Extract the remaining 12 bits
end

endmodule