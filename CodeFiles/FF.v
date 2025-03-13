module FF (  
	
	output reg [15:0] out,
	input clk,
	input [15:0] in,
	input en
);
	always @(negedge clk) begin
	
		if (en)
			out <= in;
		
		else 
			out <= 0; 
	end
	
endmodule

