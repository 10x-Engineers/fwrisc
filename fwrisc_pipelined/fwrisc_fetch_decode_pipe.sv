// pipe 1
module fwrisc_fetch_decode_pipe(input clock,
				input reset,
				

				input 		fetch_valid_f,
				input[31:0]	instr_f,
				input		instr_c_f,


				

				output reg 		fetch_valid_d,
				output reg[31:0]	instr_d,
				output reg	instr_c_d
				);
always@(posedge clock)
begin
	if(reset)
	begin
		
		fetch_valid_d  =0;
		instr_d = 0;
		instr_c_d = 0;
	end
	else
	begin
		
		fetch_valid_d  = fetch_valid_f;
		instr_d = instr_f;
		instr_c_d = instr_c_f;
	end
end
endmodule

				
