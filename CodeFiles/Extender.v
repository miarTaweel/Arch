
module extender (
	
	input [5:0] imm, 
	input sign_ext, 
	output reg [15:0] extImm
);

	always @(*) begin 
		if (sign_ext && imm[5])
			 extImm = {10'b1111111111, imm};
		else if (sign_ext && ~imm[5])
			extImm = {10'b0000000000, imm};	  
		
			
	end
	
endmodule					
