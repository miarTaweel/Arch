
module main_control_unit (
    input [3:0] opcode,     // 4-bit opcode
    input [2:0] func,       // 3-bit function
    input zero,             // Zero flag 
    input reset,
    output reg fetch_en,    // Fetch enable
    output reg [1:0] ir_type,// Instruction Register Type
    output reg return_en,   // Return Enable   
    output reg iterations_en,   // Return Enable
    output reg dest_reg,    // Destination Register
    output reg write_en,    // Write Enable
    output reg ext_op,      // Extension Operation
    output reg write_src,   // Write Source
    output reg alu_srcB,    // ALU Source B
    output reg mem_w,       // Memory Write
    output reg mem_r        // Memory Read
);

   reg alu_srcA;
    always @(*) begin
		
		iterations_en=0;
		
        case (opcode) 
			
			//-------------------- R-type instructions------------------------------------
            4'b0000: begin 
				
				fetch_en = 1;		 //instruction memory on
				ir_type = 0;		 // r-type
				return_en = 0;		 // no RR update  
				iterations_en=0;
		        dest_reg = 0;	     // Rd is the destination
		        write_en = 1;        // Write to reg
		        ext_op = 0;          // zero extension
		        write_src = 1;       // the result is from the ALU
		        alu_srcA = 1;        // from Reg_A
		        alu_srcB = 1;        // from Reg_B
		        mem_w = 0;           // No memory write
		        mem_r = 0;           // No memory read

                case (func)
		            3'b000, 3'b011, 3'b100: begin
						//no changes
		            end
		            3'b001, 3'b010: begin //Add sub
		                ext_op = 1;	  //signed extention 
		            end	  
                    
                endcase
            end	
			
		    //-------------------- J-type instructions------------------------------------
			
		   4'b0001: begin 
			   
				fetch_en = 1;		 //instruction memory on
				ir_type = 2;		 //J-type
				return_en = 0;		 // no RR update
				
				//Not identified 
				dest_reg = 1'bx;
		        write_en = 1'bx;
		        ext_op = 1'bx;
		        write_src = 1'bx;
		        alu_srcA = 1'bx;
		        alu_srcB = 1'bx;
		        mem_w = 1'bx;
		        mem_r = 1'bx;

                case (func)
		            3'b000: begin  //Jump
		            end
		            3'b001: begin  //Call
		                return_en = 1;	  
		            end
					3'b010: begin  //RET
		                fetch_en = 1;	  
		            end	
                    
                endcase
		   end	
		   
		   
		   
		   //-------------------- I-type instruction----------------------------------	  
		   
		   //ANDI :
		   4'b0010: begin  
			   
				fetch_en = 1;		 //instruction memory on
				ir_type = 1;		 // I-type
				return_en = 0;		 // no RR update
		        dest_reg = 1;	     // Rt is the destination
		        write_en = 1;        // Write to reg
		        ext_op = 0;          // zero extension
		        write_src = 1;       // the result is from the ALU
		        alu_srcA = 1;        // from Reg_A
		        alu_srcB = 0;        // immediate
		        mem_w = 0;           // No memory write
		        mem_r = 0;           // No memory read

		   end
		   
		   //ADDI :
		   4'b0011: begin  
			   
				fetch_en = 1;		 //instruction memory on
				ir_type = 1;		 // I-type
				return_en = 0;		 // no RR update
		        dest_reg = 1;	     // Rt is the destination
		        write_en = 1;        // Write to reg
		        ext_op = 1;          // signed extension
		        write_src = 1;       // the result is from the ALU
		        alu_srcA = 1;        // from Reg_A
		        alu_srcB = 0;        // immediate
		        mem_w = 0;           // No memory write
		        mem_r = 0;           // No memory read

		   end
		   
		   //LW :
		   4'b0100: begin  
			   
				fetch_en = 1;		 //instruction memory on
				ir_type = 1;		 // I-type
				return_en = 0;		 // RR update
		        dest_reg = 1;	     // Rt is the destination
		        write_en = 1;        // Write to reg
		        ext_op = 1;          // signed extension
		        write_src = 0;       // the result is from the memory
		        alu_srcA = 1;        // from Reg_A
		        alu_srcB = 0;        // immediate
		        mem_w = 0;           // No memory write
		        mem_r = 1;           // memory read

		   end	
		   
		   //SW :
		   4'b0101: begin  
			   
				fetch_en = 1;		 //instruction memory on
				ir_type = 1;		 // I-type
				return_en = 0;		 // no RR update
		        dest_reg = 1'bx;	 // no destination register
		        write_en = 0;        // No write to reg
		        ext_op = 1;          // signed extension
		        write_src = 1'bx;    // No result
		        alu_srcA = 1;        // from Reg_A
		        alu_srcB = 0;        // immediate
		        mem_w = 1;           // memory write
		        mem_r = 0;           // no memory read

		   end	
		   
		   //BEQ, BNE :
		   4'b0110 ,4'b0111: begin //only the subtraction  
			   
				fetch_en = 1;		 //instruction memory on
				ir_type = 1;		 // I-type
				return_en = 0;		 // no RR update
		        dest_reg = 1'bx;	 // no destination register
		        write_en = 0;        // No write to reg
		        ext_op = 1;          // signed extension
		        write_src = 1'bx;    // No result
		        alu_srcA = 1;        // from Reg_A
		        alu_srcB = 1;        // from Reg_B
		        mem_w = 0;           // no memory write
		        mem_r = 0;           // no memory read

		   end	
		   
		   //FOR :
		   4'b1000: begin  
			   
				fetch_en = 1;		 //instruction memory on
				ir_type = 1;		 // I-type
				return_en = 0;		 // RR update 
				iterations_en=1;
		        dest_reg = 1'bx;	 // no destination register
		        write_en = 0;        // No write to reg
		        ext_op = 1;          // signed extension
		        write_src = 1'bx;    // No result to write
		        alu_srcA = 1;        // from Reg_A (loop target address)
		        alu_srcB = 1'bx;     // (iterations) doesnt enter the ALU
		        mem_w = 0;           // no memory write
		        mem_r = 0;           // no memory read

		   end	
		   
		   
            // Default values are undefined
            default: begin
				fetch_en = 1'bx;		
				ir_type = 1'bx;
                return_en = 1'bx;
			   iterations_en=0;
                dest_reg = 1'bx;
		        write_en = 1'bx;
		        ext_op = 1'bx;
		        write_src = 1'bx;
		        alu_srcA = 1'bx;
		        alu_srcB = 1'bx;
		        mem_w = 1'bx;
		        mem_r = 1'bx;
            end
        endcase
		
		if (reset && (opcode == 4'b0000 || opcode == 4'b0010 || opcode == 4'b0011 || opcode == 4'b0100|| opcode == 4'b0001|| opcode == 4'b1000)) begin
			write_en = 1'b1;
			//iterations_en = 1'b0;
		end else begin
		write_en = 1'b0;
		return_en = 1'b0;
		
		end

    end
endmodule



