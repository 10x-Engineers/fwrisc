module Pipe4(input clock, input reset,input [31:0] daddr,input dvalid, input dwrite,input [31:0]  dwdata, input drready,input[31:0] drdata,
			output reg[31:0] daddr_p, output reg dvalid_p, output reg dwrite_p, output reg [31:0] dwdata_p,output reg drready_p,output reg[31:0] drdata_p);
always@(posedge clock)
begin
if(reset)
begin
daddr_p		<= 0;
dvalid_p 	<= 0;
dwrite_p 	<= 0;
dwdata_p 	<= 0;
drready_p		<=0;
drdata_p		<=0;
end
else
begin
daddr_p 	<= daddr;
dvalid_p 	<= dvalid;
dwrite_p 	<= dwrite;
dwdata_p 	<= dwdata;
drdata_p	<=drdata;
drready_p	<=drready_p;
end
end
endmodule