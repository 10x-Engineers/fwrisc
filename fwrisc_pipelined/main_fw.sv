module main_fw(input clock, input reset);
logic [31:0] iaddr;
logic [31:0]idata;
logic [31:0]idata_p1;
logic ivalid;
logic iready;
logic [31:0] daddr;
logic dvalid;
logic dwrite;
logic [31:0]  dwdata;
logic [3:0] dwstb;
logic [31:0] drdata;
logic drready;
logic flush;

reg irq;

assign irq = 0;
fw_instruction_memory instr_mem(iaddr,ivalid,idata,iready);
fwrisc #(
		.ENABLE_COMPRESSED(  0), 
		.ENABLE_MUL_DIV(     0), 
		.ENABLE_DEP(         0), 
		.ENABLE_COUNTERS(    1),
		.VENDORID(           0),
		.ARCHID(             0),
		.IMPID(              0),
		.HARTID(             0)
		)fw (clock,reset,iaddr,idata,ivalid,iready,dvalid,daddr,dwdata,dwstb,dwrite,drdata,drready,irq,flush);
logic [31:0] daddr_p4;
logic dvalid_p4;
logic dwrite_p4;
logic [31:0]  dwdata_p4;
logic [31:0] drdata_p4;
logic drready_p4;

Pipe1 p1(clock,reset,idata,idata_p1,flush);
always@(posedge clock)
begin
if(reset)
begin
daddr_p4 <= 0;
dvalid_p4 <= 0;
dwrite_p4 <= 0;
dwdata_p4 <= 0;
drready_p4 <= 0;
drdata_p4 <= 0;
end
else
begin
daddr_p4 <= daddr;
dvalid_p4 <= dvalid;
dwrite_p4 <= dwrite;
dwdata_p4 <= dwdata;
drready_p4 <= drready;
drdata_p4 <= drdata;
end
end
//Pipe4 P4(clock,reset,daddr,dvalid,dwrite,dwdata,daddr_p4,dvalid_p4,dwrite_p4,dwdata_p4);
fw_data_memory data_memory(clock,daddr_p4,dvalid_p4,dwrite_p4,dwdata_p4,dwstb,drdata_p4,drready_p4);

endmodule