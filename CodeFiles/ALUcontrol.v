

module ALUcontrol (	  
	
    input [3:0] opcode, 
    input [2:0] func,   
    output reg [2:0] ALU_ctrl
); 

parameter         
    AND = 3'b001,
    ADD = 3'b010,
    SUB = 3'b011,
    SLL = 3'b100,
    SRL = 3'b101;

always @(*) begin 
  
    if (opcode == 4'b0000) begin
     
        case (func) 
	//----------------------- R-type instructions-----------------------------------
            3'b000: ALU_ctrl = AND; // AND
            3'b001: ALU_ctrl = ADD; //ADD
            3'b010: ALU_ctrl = SUB; //SUB
            3'b011: ALU_ctrl = SLL; //SLL
            3'b100: ALU_ctrl = SRL; //SRL
            default: ALU_ctrl = 3'bx;//NONE
        endcase
    end   
	
    else begin
      
        case (opcode)  
	  //----------------------- I-type instructions-----------------------------------
            4'b0010: ALU_ctrl = AND;// ANDI
            4'b0011: ALU_ctrl = ADD;//ADDI
            4'b0100: ALU_ctrl = ADD;//LW
            4'b0101: ALU_ctrl = ADD;//SW
            4'b0110: ALU_ctrl = SUB;//BEQ 
            4'b0111: ALU_ctrl = SUB;//BNE
            default: ALU_ctrl = 3'bx;//NONE  
        endcase
    end
end

endmodule



