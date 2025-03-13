module Concat(
    input wire [15:0] pc,         // 16-bit Program Counter
    input wire [8:0] jump_offset, // 9-bit Jump Offset
    output wire [15:0] jump_address // 16-bit Concatenated Address
);

assign jump_address = {pc[15:9], jump_offset}; // Concatenate MSB of PC and Jump Offset

endmodule
