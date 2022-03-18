module Pipe3(input clock, input reset, input instr_c, input[31:0] op_a, input[31:0] op_b,input[31:0] op_c,
					input [5:0] rd_raddr, input[3:0] op,input[4:0] op_type,
					input decode_valid,input[4:0] opcode,input[5:0] rd_waddr, 	
					input[31:0] rd_wdata,
				       	output reg instr_c_p,
				       	output reg[31:0] op_a_p,
				       	output reg[31:0] op_b_p,
				       	output reg[31:0] op_c_p,
					output reg [5:0] rd_raddr_p,
					output reg[3:0] op_p,
					output reg[4:0] op_type_p,
					output reg decode_valid_p,
					output reg [4:0] opcode_p,
					output reg [5:0] rd_waddr_p,
					output reg [31:0] rd_wdata_p,
					input flush);
always@(posedge clock)
begin
if(reset || flush)
begin
	instr_c_p 	<= 0;
	op_a_p    	<= 0;
	op_b_p	   	<= 0;
	op_c_p	 	<= 0;
	rd_raddr_p 	<= 0;
	op_p 		<= 0;
	op_type_p 	<= 0;
	decode_valid_p	<= 0;
	opcode_p 	<= 0;
	rd_wdata_p 	<= 0;
	rd_waddr_p 	<= 0;
end
else
begin
	instr_c_p 	<= instr_c;
	op_a_p	 	<= op_a;
	op_b_p	 	<= op_b;
	op_c_p	 	<= op_c;
	rd_raddr_p 	<= rd_raddr;
	op_p 		<= op;
	op_type_p 	<= op_type;
	decode_valid_p <= decode_valid;
	opcode_p 	<= opcode;
	rd_wdata_p 	<= rd_wdata;
	rd_waddr_p 	<= rd_waddr;
end
end
endmodule	