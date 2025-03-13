module PerformanceRegisters (
    input clk,                     
    input reset,
    input fetch_en,
    input [3:0] opcode,      
    input [2:0] func,       
    output reg [15:0] total_instructions,   
    output reg [15:0] total_loads,          
    output reg [15:0] total_stores,       
    output reg [15:0] total_alu,            
    output reg [15:0] total_controls,      
    output reg [15:0] clock_cycles             
);

    reg [3:0] opcode_cycle_counter;       // Counter to track cycles for opcode 0000

    // Initialize all values
    initial begin
        total_instructions = 0;
        total_loads = 0;
        total_stores = 0;
        total_alu = 0;
        total_controls = 0;
        clock_cycles = 0;
        opcode_cycle_counter = 0;
    end

    always @(posedge clk) begin
        if (reset) begin
            // Reset all counters and flags
            total_instructions <= 0;
            total_loads <= 0;
            total_stores <= 0;
            total_alu <= 0;
            total_controls <= 0;
            clock_cycles <= 0;
            opcode_cycle_counter <= 0;
        end else begin
            // Increment clock cycle count
            clock_cycles <= clock_cycles + 1;

            // Track total instructions if fetch is enabled
            if (fetch_en) begin
                total_instructions <= total_instructions + 1;

                // Handle R-type instructions
                if (opcode == 4'b0000) begin
                    case (func)
                        3'b000, 3'b001, 3'b010, 3'b011, 3'b100: total_alu <= total_alu + 1;
                        default: ;
                    endcase
				end 	
                    case (opcode)
                        4'b0010, 4'b0011: total_alu <= total_alu + 1;  // I-type ALU => ANDI, ADDI
                        4'b0100: total_loads <= total_loads + 1;       // Load => LW
                        4'b0101: total_stores <= total_stores + 1;     // Store => SW
                        4'b0110, 4'b0111, 4'b0001,4'b1000: total_controls <= total_controls + 1; // Control => BEQ, BNE, J-type
                        default: ;
                    endcase
                
            end
        end
    end
endmodule 


module PerformanceRegisters_tb;
    reg clk, reset, fetch_en;
    reg [3:0] opcode;
    reg [2:0] func;
    wire [15:0] total_instructions, total_loads, total_stores, total_alu, total_controls, clock_cycles;
    wire pc_increment;

    // Instantiate the module
    PerformanceRegisters uut (
        .clk(clk),
        .reset(reset),
        .fetch_en(fetch_en),
        .opcode(opcode),
        .func(func),
        .total_instructions(total_instructions),
        .total_loads(total_loads),
        .total_stores(total_stores),
        .total_alu(total_alu),
        .total_controls(total_controls),
        .clock_cycles(clock_cycles)
    );

    // Generate clock
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10 time unit clock period
    end

    // Test stimulus
    initial begin
        // Reset and initialize
        reset = 1; fetch_en = 0; opcode = 4'b0000; func = 3'b000;
        #10 reset = 0; fetch_en = 1;

        // Test opcode 0000 for 4 cycles
        #50; opcode = 4'b0000; // Switch to a different opcode
        #10; opcode = 4'b0000; // Switch back to 0000 for another 4 cycles
        #50;

        $finish;
    end

    // Monitor outputs
    initial begin
        $monitor("Time=%0t | Opcode=%b | Total_Alu=%d | Clock_Cycles=%d", 
                 $time, opcode, total_alu, clock_cycles);
    end
endmodule


