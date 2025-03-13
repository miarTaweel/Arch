
module datapath(

input clk,
	
); 


wire [15:0] current_pc,instruction_out,next_pc,pc_out1,JTA,Bus_w,B,A,regA, regB,extimm,alu_opernad2,
memo_out,memo_buffer,BTA,retun_pc,address,iterations;  

wire signed [15:0]	alu_output,result_buffer;
wire [3:0] opcode ;
wire [2:0] alu_ctrl,pc_ctrl;
wire [11:0] reg1_rest; 	 
wire [1:0] IR_type;
wire [2:0] func,Rd,Rt,Rs,Rw;	 
wire [5:0] imm;
wire [8:0] offset;
wire zero,write_src,fetch_enable,dst_reg,write_enable, ext_op,alu_src, mem_W,mem_R,return_en,iterations_en,zero_iterations;	  
wire [15:0] total_instructions;
wire [15:0] total_loads;
wire [15:0] total_stores;
wire [15:0] total_alu;
wire [15:0] total_controls;
wire [15:0] clock_cycles;
wire pc_inc;
wire pc_increment;

assign next_pc =  current_pc + 1;   
assign pc_7bits = current_pc[15:9]; 	  


            //---------------------------------instruction fetch ----------------------------------------------

PC pc(.clk(clk),.new_address(address),.pc_out(current_pc));// fetch the instruction address from pc reg

instruction_memory instmemo (
  .address(current_pc), 
  .fetch_en(fetch_enable),
  .instruction(instruction_out));// fetch the instruction from IMemo	
  
  
  
  
PerformanceRegisters performance_unit (
        .clk(clk),                        // Connect clk to the parent module's clk
        .reset(1'b0),                    // Connect reset to the parent module's reset
        .fetch_en(pc_increment),              // Connect fetch_en to the parent module's fetch_en
        .opcode(opcode),                  // Connect opcode to the parent module's opcode
        .func(func),                      // Connect func to the parent module's func
        .total_instructions(total_instructions), // Connect internal wire to output
        .total_loads(total_loads),        
        .total_stores(total_stores),      
        .total_alu(total_alu),            
        .total_controls(total_controls),  
        .clock_cycles(clock_cycles)      

    );
  
  
  

Mux2to1  pc_or_Nextpc(.in0(current_pc), .in1(next_pc), .sel(pc_increment),.out(pc_out1));// choose next_pc if fetch_en=1 or current_pc if fetch_en=0
	
IR_Reg reg1 (.clk(clk), .instruction(instruction_out),.opcode(opcode),.rest(reg1_rest));//store instruction in IR reg

Mux5to1  pcSrc_in(

    .in0(JTA),          // jump target address 
    .in1(BTA),         // branch target address
    .in2(retun_pc),   // Return address
    .in3(pc_out1),   // next pc
    .in4(A),        // for
    .sel(pc_ctrl), // 3-bit selector
	.pc_increment(pc_increment),
    .out(address)	  
);// decide pc next address

Reg1 RR(	  

    .en(return_en),
    .clk(clk),        
    .in(next_pc),  
    .out(retun_pc)

);// store return address	  

Concat JTAddress(
    .pc(current_pc),         
    .jump_offset(offset), 
    .jump_address(JTA)

);// calculate jump targer address

	 //---------------------------------instruction decode ----------------------------------------------

IR_Seg seg (.input_bits(reg1_rest), .IR_type(IR_type), .rd(Rd), .rs(Rs), .rt(Rt),.func(func), .imm(imm), .offset(offset));// divide the instruction into segmennts (ISA)

RegMux2to1 regdst_Mux(.in0(Rd) , .in1(Rt), .sel(dst_reg), .out(Rw));// choose rt-> 1 pr rd-> 0 as a destnation reg	

reg_file regfile(
  .clk(clk),
  .write_en(write_enable),
  .RA(Rs), .RB(Rt), 
  .RW(Rw),
  .bus_w(Bus_w),.bus_A(A),
  .bus_B(B)
); //fetch operands			  

           

FF reg_A (.out(regA), .clk(clk), .in(A), .en(1'b 1)); // store Rs in Reg_A 
FF reg_B (.out(regB), .clk(clk), .in(B), .en(1'b 1)); //store Rt in Reg_A 
extender ext (.imm(imm), .sign_ext(ext_op), .extImm(extimm));// sign extention for imm 	
	
	//--------------------------------------Execution ----------------------------------------------	 
	
Mux2to1 aluSrc (.in0(extimm), .in1(regB) , .sel(alu_src), .out(alu_opernad2));// decide alu source mux , 0-> imm, 1-> rt	

ALU alu(
 	.alu_ctrl(alu_ctrl),
	.a(regA),.b(alu_opernad2), 
	.zero(zero), .overflow(overflow),.neg(neg),
	.alu_out (alu_output)
); 

FF ALU_out (.out(result_buffer), .clk(clk), .in(alu_output),.en(1'b 1)); // store alu output in a buffer   	 

BranchAdder add(
    .pc(current_pc), 
    .offset(extimm),	
    .branch_address(BTA)
	);// calculate branch target address 


	//--------------------------------------Memory --------------------------------------------

FF MDR (.out(memo_buffer), .clk(clk), .in(memo_out),.en(1'b 1));//store memory output in a buffer	  

data_memory data_memo(		
    .address(result_buffer),  
    .data_in(regB),            
    .mem_W(mem_W), .mem_R(mem_R),.clk(clk),              
    .data_out(memo_out) 

);//store or load data from memory	

//-------------------------------------- Write back --------------------------------------------
Mux2to1 reg_writeSrc (.in0(memo_buffer), .in1(result_buffer) , .sel(write_src), .out(Bus_w));// decide reg write src, 0-> memo_out 1-> alu result



Iterations num_iterations(  
    .clk(clk),            
    .in(B),     
    .Return_enable(iterations_en),    
    .Zero_iterations(zero_iterations),
	.out(iterations)
); // calculate number of iterations 

  


   //----------------------------------Control units -----------------------------------

  main_control_unit main(
    .opcode(opcode),    
    .func(func),      
    .zero(zero), 
	.reset(pc_increment),
    .fetch_en(fetch_enable),    
    .ir_type(IR_type),
    .return_en(return_en), 
	.iterations_en(iterations_en),
    .dest_reg(dst_reg),    
    .write_en(write_enable),    
    .ext_op(ext_op),     
    .write_src(write_src),   
    .alu_srcB(alu_src),     
    .mem_w(mem_W),      
    .mem_r(mem_R)        
);	// generate control signals


pcControl pc_control(
    .opcode(opcode),     
    .func(func),     
    .zero(zero),            
    .ir_type(IR_type),    
    .iterationsZero(zero_iterations),  
	.clk_cycles(clock_cycles),
    .pc_ctrl(pc_ctrl), 
	.pc_increment(pc_increment)
); // generate control signals for pc reg 
	
ALUcontrol alu_control(	
    .opcode(opcode), 
    .func(func),   
    .ALU_ctrl(alu_ctrl)	
);// generate alu control signals  




endmodule  	


module datapath_tb2;

// Declare testbench variables
reg clk;
wire [15:0] current_pc, instruction_out, next_pc, pc_out1, JTA, Bus_w, B, A, regA, regB, extimm, alu_opernad2;
wire signed [15:0] alu_output, result_buffer;
wire [3:0] opcode;
wire [2:0] alu_ctrl, pc_ctrl;
wire [11:0] reg1_rest;
wire [1:0] IR_type;
wire [2:0] func, Rd, Rt, Rs, Rw;
wire [5:0] imm;
wire [8:0] offset;
wire zero, write_src, fetch_enable, dst_reg, write_enable, ext_op, alu_src, mem_W, mem_R, return_en, zero_iterations;

// Instantiate the module under test (MUT)
datapath uut (
    .clk(clk)
);

// Generate clock signal with a period of 10 time units (5ns high, 5ns low)
initial begin
    clk = 0;
    forever #5 clk = ~clk; // 10 time unit clock period
end

// Stimulus and sequential monitoring
initial begin
    #57; // Skip the dummy instruction

    // Loop through multiple instructions
    repeat (9) begin
        // Fetch stage
        #3;
        $display("\n=== Instruction %0d ===\n", uut.current_pc);  
		 
        $display("[FETCH]    Time: %0t | PC: %h | Instruction: %h", $time, uut.current_pc, uut.instruction_out);

        #12; // Move to Decode

        // Decode stage
        $display("[DECODE]   Time: %0t", $time);
        $display("           IR_type: %b | Rd: %b | Rs: %b | Rt: %b | Func: %b | Imm: %b | Offset: %b", 
                 uut.IR_type, uut.Rd, uut.Rs, uut.Rt, uut.func, uut.imm, uut.offset);
        $display("           Bus_A: %h | Bus_B: %h | RegA: %h | RegB: %h | ExtImm: %h", 
		uut.A, uut.B, uut.regA, uut.regB, uut.extimm);		
	

        // Execute stage ((for specific instruction types)
        if (uut.opcode != 4'b0001 && uut.opcode != 4'b1000) begin
            #6; 
            $display("[EXECUTE]  Time: %0t", $time);
            $display("           ALU_Output: %h | ALU_Op: %h | Operand1: %h | Operand2: %h | Src: %h", 
                     uut.alu_output, uut.alu_ctrl, uut.regA, uut.alu_opernad2, uut.alu_src);
            #5;
            $display("           Result_Buffer: %h", uut.result_buffer);
        end

        
        if (uut.opcode == 4'b0001 && uut.func == 3'b010) begin
			 $display("           Return register : %h", uut.retun_pc);
            #11;
        end	  
		
		if (uut.opcode == 4'b1000) begin
            #11;
        end

        // Memory stage (for specific instruction types)
        if (uut.opcode != 4'b0000 && uut.opcode != 4'b0010 && uut.opcode != 4'b1000 &&
            uut.opcode != 4'b0011 && uut.opcode != 4'b0111 && uut.opcode != 4'b0110 && uut.opcode != 4'b0001) begin
            #5; 
            $display("[MEMORY]   Time: %0t", $time);
            $display("           Mem_W: %b | Mem_R: %b | Data_in: %h | Data_out: %h | Address: %h", 
                     uut.mem_W, uut.mem_R, uut.regB, uut.memo_out, uut.result_buffer);
            #5;
        end 

        // Write-back stage (for specific instruction types)
        if (uut.opcode != 4'b0101 && uut.opcode != 4'b0111 && uut.opcode != 4'b0110 &&
            uut.opcode != 4'b1000 && uut.opcode != 4'b0001) begin
            #5; 
            $display("[WRITEBACK]Time: %0t", $time);
            $display("           Write_en: %b | Bus_W: %h | Destination_Reg=R%0d", uut.write_enable, uut.Bus_w, uut.Rw);
            #5;
        end  

        #5;
    end	

    // Display Performance Registers
    $display("\n=== Performance Registers ===");
    $display("Total Instructions: %d", uut.total_instructions);
    $display("Total Loads:        %d", uut.total_loads);
    $display("Total Stores:       %d", uut.total_stores);
    $display("Total ALU Ops:      %d", uut.total_alu);
    $display("Total Controls:     %d", uut.total_controls);
    $display("Clock Cycles:       %d", uut.clock_cycles);

    // End the simulation
    $finish;
end

endmodule
