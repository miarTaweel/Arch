module PC(
    input wire clk,           // Clock signal
    input wire [15:0] new_address, // 16-bit input address
    output reg [15:0] pc_out  // 16-bit output: Current PC value
);

 initial begin	
	pc_out = 16'h0000;
end	  

initial begin 	  
	@(posedge clk);
	pc_out = 16'h0000;
	forever@(posedge clk) 
		pc_out <= new_address;
end


endmodule
