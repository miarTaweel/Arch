module IR_Seg(
    input wire [11:0] input_bits,  // 12-bit input
    input wire [1:0] IR_type,      // 2-bit IR type
    output reg [2:0] rd,           // 3-bit destination register
    output reg [2:0] rs,           // 3-bit source register
    output reg [2:0] rt,           // 3-bit target register
    output reg [2:0] func,         // 3-bit function code
    output reg [5:0] imm,          // 6-bit immediate value
    output reg [8:0] offset        // 9-bit offset value
);

always @(*) begin
    if (IR_type == 2'b00) begin	//Rtype   
		
        rd = input_bits[11:9];      
        rs = input_bits[8:6];       
        rt = input_bits[5:3];       
        func = input_bits[2:0];     
        imm = 6'b0;                 
        offset = 9'b0;                
		
    end else if (IR_type == 2'b01) begin //Itype
        rd = 3'b0;
        rs = input_bits[11:9];
        rt = input_bits[8:6];
        func = 3'b0;
        imm = input_bits[5:0];
        offset = 9'b0;
    end	
		else if (IR_type == 2'b10) begin //Jtype
         rd = 3'b0;
        rs = 3'b0;
        rt = 3'b0;
        func = input_bits[2:0];
        imm = 6'b0;
        offset = input_bits[11:3];
    end
	   else begin
        rd = 3'b0;
        rs = 3'b0;
        rt = 3'b0;
        func = 3'b0;
        imm = 6'b0;
        offset = 9'b0;
    end
end

endmodule
