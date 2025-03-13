
module reg_file (
	
	input clk,
	input write_en,
	input [2:0] RA, RB, RW,
	input [15:0] bus_w,
	output reg [15:0] bus_A, bus_B
);
	
reg [15:0] regArray [0:7] = '{	 

    16'h0000, //R0 
    16'h000A, //R1 
    16'h0002, //R2 
    16'h0004, //R3 
    16'h0003, //R4
    16'h0000, //R5
    16'h000B, //R6
    16'h000B  //R7
   
};


	always @(*) begin //The output is taken asynchronously										  
			bus_A = regArray[RA];
			bus_B = regArray[RB];	
	end
	
	always @(posedge clk) begin	
		
		if (write_en)
			regArray[RW] <= bus_w;
			
			
	end
	
	
endmodule	







