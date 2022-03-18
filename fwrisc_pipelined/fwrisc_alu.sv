module fwrisc_alu (
		input					clock,
		input					reset,
		input[31:0]				op_a,
		input[31:0]				op_b,
		input[3:0]				op,
		output reg[31:0]		out);
	
	`include "fwrisc_alu_op.sv"
	
	always @* begin
		case (op) 
			OP_ADD:  out = op_a + op_b;
			OP_SUB:  out = op_a - op_b; // sub;
			OP_AND:  out = op_a & op_b;
			OP_OR:   out = op_a | op_b;
			OP_CLR:  out = op_b ^ (op_a & op_b); // Used for CSRC
			OP_EQ:   out = {31'b0, op_a == op_b};
			OP_NE:   out = {31'b0, op_a != op_b};
			OP_LT:   out = {31'b0, $signed(op_a) < $signed(op_b)}; // {31'b0, carry};
			OP_GE:   out = {31'b0, $signed(op_a) >= $signed(op_b)}; // {31'b0, carry};
			OP_LTU:  out = {31'b0, op_a < op_b};
			OP_GEU:  out = {31'b0, op_a >= op_b};
			OP_OPA:  out = op_a; // passthrough
			OP_OPB:  out = op_b; // passthrough
			default /*OP_XOR */: out = op_a ^ op_b;
		endcase
	end

endmodule
