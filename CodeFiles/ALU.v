module ALU (
	
	input [2:0] alu_ctrl,
	input signed [15:0] a, b, 
	output zero, overflow,neg,
	output reg signed  [15:0] alu_out
	);
	
	reg [1:0] carry;		   
	assign zero = (alu_out == 0);
	assign overflow = ( carry[0] ^ carry[1]);
	assign neg = alu_out [15];
	
	always @(*)begin
		
		case (alu_ctrl)
			
			3'd1 : alu_out = a & b;
			3'd2 : begin 
					{carry[0], alu_out[14:0]} = a[14:0] + b[14:0];
					{carry[1], alu_out[15]} = a[15] + b[15] + carry[0];	
				end	
				
			3'd3 : alu_out = a - b;
			3'd4 : alu_out = a << b[3:0];  
		    3'd5 : alu_out = a >> b[3:0];  
			 default: alu_out = 16'b0;                

		endcase
		
		 end
		
endmodule							  


module tb_ALU;

    // Inputs
    reg [2:0] alu_ctrl;
    reg signed [15:0] a, b;

    // Outputs
    wire zero, overflow, neg;
    wire signed[15:0] alu_out;

    // Instantiate the ALU module
    ALU uut (
        .alu_ctrl(alu_ctrl),
        .a(a),
        .b(b),
        .zero(zero),
        .overflow(overflow),
        .neg(neg),
        .alu_out(alu_out)
    );

    // Test sequence
    initial begin
        $monitor("alu_ctrl=%d, a=%d, b=%d, alu_out=%d, zero=%b, overflow=%b, neg=%b",
                 alu_ctrl, a, b, alu_out, zero, overflow, neg);

        // Test AND operation (alu_ctrl = 1)
        alu_ctrl = 3'd1; a = 16'b1100_1100_1100_1100; b = 16'b1010_1010_1010_1010; #10;

        // Test ADD operation (alu_ctrl = 2)
        alu_ctrl = 3'd2; a = 16'd10; b = 16'd5; #10;
        alu_ctrl = 3'd2; a = 16'sd32767; b = 16'sd1; #10; // Test overflow for signed addition

        // Test SUBTRACT operation (alu_ctrl = 3)
        alu_ctrl = 3'd3; a = 16'd20; b = 16'd30; #10;
        alu_ctrl = 3'd3; a = 16'sd32768; b = 16'sd1; #10; // Test overflow for signed subtraction

        // Test Logical Shift Left (alu_ctrl = 4)
        alu_ctrl = 3'd4; a = 16'b0000_1111_0000_1111; b = 4; #10;

        // Test Logical Shift Right (alu_ctrl = 5)
        alu_ctrl = 3'd5; a = 16'b0000_1111_0000_1111; b = 4; #10;

        // Test Default case (alu_ctrl = invalid)
        alu_ctrl = 3'd6; a = 16'd15; b = 16'd3; #10;

        // Finish simulation
        $finish;
    end
endmodule




