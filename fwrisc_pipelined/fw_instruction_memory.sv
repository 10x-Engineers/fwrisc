
module fw_instruction_memory(input[31:0] iaddr, input ivalid, output reg[31:0] idata, output reg iready);

reg[31:0] instruction_mem[256:0];
initial
begin
//hardwire instructions here
instruction_mem[0]=32'h00300093;	//addi x1,x0,3
instruction_mem[4]=32'h00500113;	//addi x2,x0,5
instruction_mem[8]=32'h002083b3;	//add x7,x1,x2
instruction_mem[12]=32'h00112023;	//sw x1,0(x2)
instruction_mem[16]=32'h00400513;	//addi x10,x0,4
instruction_mem[20]=32'h00400593;	//addi x11 x0 4
end
always@(*)
begin

idata = instruction_mem[iaddr];
iready = 1; 

end
endmodule
