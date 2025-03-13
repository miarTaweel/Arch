module BranchAdder(
    input wire [15:0] pc,       // 16-bit Program Counter
    input wire [15:0] offset,  // 16-bit Offset
    output wire [15:0] branch_address // 16-bit Branch Address
);

assign branch_address = pc + offset; // Add PC and Offset

endmodule
