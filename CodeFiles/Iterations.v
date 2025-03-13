module Iterations(
    input wire clk,            // Clock signal
    input wire [15:0] in,      // 16-bit input
    input wire Return_enable,  // Enable signal
    output reg [15:0] out,     // 16-bit output
    output reg Zero_iterations // Flag output: 1 if iterations reach zero
);

always @(posedge Return_enable) begin
    if (Return_enable) begin
        if (out > 1) begin
            out <= out - 1;  // Decrement value if `out > 0

        end else begin
		   #0.01;
            out <= in;       // Load new value if `out == 0`
        end
    end

    // Set Zero_iterations flag
    if (out == 1) begin
        Zero_iterations <= 1;
    end else begin
        Zero_iterations <= 0;
    end
end

endmodule

