module data_memory (
    input [15:0] address,   // 16-bit address input
    input [15:0] data_in,   // 16-bit data input
    input mem_W,            // Memory write enable
    input mem_R,            // Memory read enable
    input clk,              // Clock signal
    output reg [15:0] data_out // 16-bit data output
);


    reg [15:0] memory [0:255]; // 256 words of 16-bit memory

  
    initial begin
        memory[0] = 16'h0000;
        memory[1] = 16'h0034;
        memory[2] = 16'h0078;
        memory[3] = 16'h00BC;
		memory[6] = 16'h000A;
       
    end

    // Read operation (combinational logic)
    always @(*) begin
        if (mem_R) begin
       
            data_out = memory[address];
        end else begin
            // Default output value when not reading
            data_out = 16'h0000;
        end
    end

    // Write operation (synchronized with the clock)
    always @(posedge clk) begin
        if (mem_W) begin
            memory[address] <= data_in;
        end
    end

endmodule
