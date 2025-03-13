module Reg(
    input wire clk,        // Clock signal
    input wire [15:0] in, // 16-bit input 
    output reg [15:0] out  // 16-bit output
);

 
always @(posedge clk) begin	
        out <= in; 
    end

endmodule

module Reg1(
	input wire en,
    input wire clk,        // Clock signal
    input wire [15:0] in, // 16-bit input 
    output reg [15:0] out  // 16-bit output
);

 
always @(posedge clk ) begin	
	
	if (en)begin 
        out <= in; 
		
		end 
    end

endmodule
