module fw_comparator(input[5:0] rs, input[5:0] rd, output reg sel_op);
always@(*)
begin
if(rd!=0)
	begin
	if(rd==rs)
	sel_op = 1;
	else
	sel_op = 0;
	end
else
sel_op = 0;
end
endmodule
