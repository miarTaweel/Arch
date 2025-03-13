module Constants;
    // R-type instructions
    localparam [3:0] AND     = 4'b0000; // AND
    localparam [3:0] ADD     = 4'b0000; // ADD
    localparam [3:0] SUB     = 4'b0000; // SUB
    localparam [3:0] SLL     = 4'b0000; // Shift Left Logical
    localparam [3:0] SRL     = 4'b0000; // Shift Right Logical

    // I-type instructions 
    localparam [3:0] ANDI    = 4'b0010; // AND Immediate
    localparam [3:0] ADDI    = 4'b0011; // ADD Immediate
   
    localparam [3:0] LW      = 4'b0100; // Load Word
    localparam [3:0] SW      = 4'b0101; // Store Word

    localparam [3:0] BEQ     = 4'b0110; // Branch if Equal
    localparam [3:0] BNE     = 4'b0111; // Branch if Not Equal
	localparam [3:0] FOR     = 4'b1000; // FOR
    // J-type instructions
    
    localparam [3:0] JMP     = 4'b0001; // Jump to Offset
    localparam [3:0] CALL    = 4'b0001; // CALL Offset
    localparam [3:0] RET     = 4'b0001; // Return

endmodule
