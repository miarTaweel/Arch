
module pcControl (
    input [3:0] opcode,     // 4-bit opcode (not the primary control)
    input [2:0] func,       // 3-bit function
    input zero,             // Zero flag
    input [1:0] ir_type,    // 2-bit Instruction Register Type
    input iterationsZero,   //a flag if the iterations are zero
	input [15:0] clk_cycles, //Number of clock_cycles	
    output reg [2:0] pc_ctrl, // 3-bit PC control signal
    output reg pc_increment   // a flag for multi_cycle scheduelling             
	
);


reg [15:0] prev_clock_cycles;
reg [3:0] opcode_cycle_counter;

	initial begin
		pc_ctrl = 3'b011;
		pc_increment <= 0;
		opcode_cycle_counter =0;
		prev_clock_cycles=0; 
		
		end 
	 
		
		always @(clk_cycles) begin
    // Detect clock cycle change
    if (clk_cycles != prev_clock_cycles) begin
        prev_clock_cycles <= clk_cycles; // Update the previous clock cycle value

        // Increment the counter for specific opcodes
        if (ir_type == 2'b00 || ir_type == 2'b01 || ir_type == 2'b10) begin
            opcode_cycle_counter <= opcode_cycle_counter + 1;

            // R-type instructions (ir_type == 2'b00)
            if (ir_type == 2'b00) begin
                if (opcode_cycle_counter == 3) begin
                    pc_increment <= 1;
                    opcode_cycle_counter <= 0; // Reset the counter
                end else begin
                    pc_increment <= 0;
                end
		end	
		else if (opcode == 4'b0001 ) begin
                if (opcode_cycle_counter << 2 ) begin
                    pc_increment <= 1;
                    opcode_cycle_counter <= 0; // Reset the counter
                end else begin
                    pc_increment <= 0;
                end
            end

          
            else if (ir_type == 2'b01) begin
                case (opcode)
                    4'b0010, 4'b0011, 4'b0101: begin // ANDI, ADDI, SW
                        if (opcode_cycle_counter == 3) begin
                            pc_increment <= 1;
                            opcode_cycle_counter <= 0; // Reset the counter
                        end else begin
                            pc_increment <= 0;
                        end
                    end
                    4'b0100: begin // LW
                        if (opcode_cycle_counter == 4) begin
                            pc_increment <= 1;
                            opcode_cycle_counter <= 0; // Reset the counter
                        end else begin
                            pc_increment <= 0;
                        end
                    end
                   	4'b0110,4'b0111,4'b1000: begin // BEQ, BNE,FOR
                        if (opcode_cycle_counter == 2) begin
                            pc_increment <= 1;
                            opcode_cycle_counter <= 0; // Reset the counter
                        end else begin
                            pc_increment <= 0;
                        end
	end	 
	
					
					default: begin
                        pc_increment <= 0;
                    end
                endcase
            end
	end 
	  else if (ir_type == 2'b10) begin
                        if (opcode_cycle_counter <= 2) begin
                            pc_increment <= 1;
                            opcode_cycle_counter <= 0; // Reset the counter
                        end else begin
                            pc_increment <= 0;
                        end

            end

else begin
            // Reset counter and pc_increment for other cases
            opcode_cycle_counter <= 0;
            pc_increment <= 0;
        end
    end
end


    always @(*) begin
        // Default pc_ctrl value
	
	
        case (ir_type)
		   
		  //----------------------- R-type instructions-----------------------------------
		  2'b00: begin 
			  
                pc_ctrl = 3'b011;
            end	 
			
           //----------------------- I-type instructions-----------------------------------	

		   2'b01: begin 
			  case (opcode)
				  // ANDI, ADDI , SW ----------------------------------------------
				  4'b0010,4'b0011,4'b0101: begin 
					  pc_ctrl = 3'b011; 
						 
			  end
			   4'b0100: begin //LW
					  pc_ctrl = 3'b011; 
				  end
				  
				  // BEQ---------------------------------------------------------------
				  4'b0110: begin   
		                if (zero) begin
		                    pc_ctrl = 3'b001; // Branch taken 
		                end else begin
		                    pc_ctrl = 3'b011; // Branch not taken
					   end 
			       end 
			  	  
				   // BNE---------------------------------------------------------------
				   4'b0111: begin  
		                if (zero) begin
		                    pc_ctrl = 3'b011; // Branch not taken 
		                end else begin
		                    pc_ctrl = 3'b001; // Branch taken
					   end 
			       end
			  	   //FOR---------------------------------------------------------------
				   4'b1000: begin  
		                if (iterationsZero) begin
		                    pc_ctrl = 3'b011; //Loop
		                end else begin
		                    pc_ctrl = 3'b100; //next_instruction
					   end 
			       end
			  
			  
			  
			  endcase
		  end	
		
            //----------------------- J-type instructions-----------------------------------
		   2'b10: begin 
			   case (func)
				  4'b010: begin  //RET
		              	 pc_ctrl = 3'b010;
				  end
				  default: begin
	                	    pc_ctrl = 3'b000; // Default case
	               end 
			  endcase
            end
           	
			
			
            default: begin
                pc_ctrl = 3'b011; // Default case
            end
        endcase
    end	
	
	 
endmodule


module pcControl_tb;

    // Inputs
    reg [3:0] opcode;
    reg [2:0] func;
    reg zero;
    reg [1:0] ir_type;
    reg iterationsZero;
    reg [15:0] clk_cycles;

    // Outputs
    wire [2:0] pc_ctrl;
    wire pc_increment;

    // Instantiate the pcControl module
    pcControl uut (
        .opcode(opcode),
        .func(func),
        .zero(zero),
        .ir_type(ir_type),
        .iterationsZero(iterationsZero),
        .clk_cycles(clk_cycles),
        .pc_ctrl(pc_ctrl),
        .pc_increment(pc_increment)
    );

    // Testbench Variables
    reg [15:0] test_clock_cycles;

    // Test stimulus
    initial begin
        // Initialize inputs
        opcode = 4'b0000;       // Default opcode
        func = 3'b000;          // Default function
        zero = 0;               // Zero flag not set
        ir_type = 2'b00;        // R-type instruction
        iterationsZero = 0;     // Default iterations flag
        clk_cycles = 0;         // Start with 0 clock cycles

        // Test 1: Increment clk_cycles and verify pc_increment
        $display("=== Test 1: R-type Opcode ===");
        repeat (4) begin
            #10 clk_cycles = clk_cycles + 1;
            #10 $display("Time=%0t | Opcode=%b | Clk Cycles=%0d | Opcode Cycle Counter=%0d |PC Increment=%0d, PC Increment=%b",
                         $time, opcode, clk_cycles, uut.opcode_cycle_counter, uut.prev_clock_cycles, pc_increment);
        end

        // Test 2: Change opcode and verify behavior
        $display("\n=== Test 2: I-type Opcode ===");
        opcode = 4'b0010;       // I-type instruction (ANDI/ADDI)
        ir_type = 2'b01;        // I-type
        

        repeat (4) begin
            #10 clk_cycles = clk_cycles + 1;
            #10 $display("Time=%0t | Opcode=%b | Clk Cycles=%0d | Opcode Cycle Counter=%0d | PC Increment=%b",
                         $time, opcode, clk_cycles, uut.opcode_cycle_counter, pc_increment);
        end

        // Test 3: Change to LW instruction (I-type with 5 cycles)
        $display("\n=== Test 3: I-type Opcode (LW) ===");
        opcode = 4'b0100;       // I-type instruction (LW)
       

        repeat (6) begin
            #10 clk_cycles = clk_cycles + 1;
            #10 $display("Time=%0t | Opcode=%b | Clk Cycles=%0d | Opcode Cycle Counter=%0d | PC Increment=%b",
                         $time, opcode, clk_cycles, uut.opcode_cycle_counter, pc_increment);
        end

        // Test 4: Switch to J-type instruction and verify behavior
        $display("\n=== Test 4: J-type Opcode ===");
        opcode = 4'b0000;       // Back to R-type
        ir_type = 2'b10;        // J-type
        clk_cycles = 0;         // Reset clock cycles

        repeat (4) begin
            #10 clk_cycles = clk_cycles + 1;
            #10 $display("Time=%0t | Opcode=%b | Clk Cycles=%0d | Opcode Cycle Counter=%0d | PC Increment=%b",
                         $time, opcode, clk_cycles, uut.opcode_cycle_counter, pc_increment);
        end

        // Finish simulation
        $finish;
    end
endmodule


