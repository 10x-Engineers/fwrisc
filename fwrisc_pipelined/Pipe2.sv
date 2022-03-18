module Pipe2(input clock, input reset, input[31:0] idata,input instr_c, output reg[31:0] idata_p, output reg instr_c_p,input flush,input stall);
always@(posedge clock)
begin
if(reset || flush)
begin 
	idata_p = 0;
	instr_c_p = 0;
end
else 
begin
	idata_p <= idata;
	instr_c_p <= instr_c;
end
end
endmodule
