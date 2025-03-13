module instruction_memory (
    input [15:0] address,       // 16-bit address input
    input fetch_en,             // Enable signal
    output reg [15:0] instruction // 16-bit instruction output
);

    reg [15:0] instruction_array [0:255]; // 256 words of 16-bit instructions
	`include "Constants.v"
	initial begin  
		
 
    instruction_array[0] = {Constants.ADD, 3'b000, 3'b000, 3'b000, 3'b001};  // Dummy Instruction: Add R0,R0,R0 (skipped)
    instruction_array[1] = {Constants.SW , 3'b010, 3'b001, 6'b000010};       // SW: rt=1, rs=2, imm=2 => Memory[Register[2] + 2] = Register[1]
    instruction_array[2] = {Constants.LW, 3'b011, 3'b101, 6'b000000};        // LW: rt=5, rs=3, imm=0 => Register[5] = Memory[Register[3] + 0]
    instruction_array[3] = {Constants.ADD, 3'b101, 3'b011, 3'b101, 3'b001};  // ADD: rd=1, rs=2, rt=3, func=0 => Register[1] = Register[2] + Register[3]

    // I-type instructions:
    instruction_array[4] = {Constants.ADDI, 3'b010, 3'b101, 6'b000011};      // ANDI: rs=2, rt=5, imm=3 => Register[2] = Register[5] + 3
    instruction_array[5] = {Constants.BEQ, 3'b111, 3'b110, 6'b000010};       // BEQ: rs=7, rt=6, imm=2 => if (Register[7] == Register[6]) 
		        													         //then PC = PC + 2

   
	instruction_array[6] = {Constants.ADDI, 3'b010, 3'b011, 6'b000010};      // ADDI: rs=2, rt=3, imm=2 => Register[3] = Register[2] + 2
    instruction_array[7] = {4'b0001, 9'b000001001, 3'b001};                  // CALL: Jump to address (PC[15:9] || 9'b000001001) and store return address
    instruction_array[8] = {Constants.SUB, 3'b110, 3'b010, 3'b111, 3'b010};  // SUB: rd=6, rs=2, rt=7, => Register[6] = Register[2] - Register[7]
    instruction_array[9] = {Constants.SLL, 3'b101, 3'b011, 3'b101, 3'b011};  // SLL: rd=5, rs=3, rt=5, => Register[5] = Register[3] << Register[5]
    instruction_array[10] = {4'b0001, 9'b000001001, 3'b010};                 // RET: Jump back to the return address stored in the stack
end

    always @(*) begin
        if (fetch_en) begin
            instruction = instruction_array[address]; 
        end else begin
            instruction = 16'h0000; 
        end
    end
endmodule
