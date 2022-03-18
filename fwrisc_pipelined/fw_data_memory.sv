module fw_data_memory(input clock, input[31:0] daddr, input dvalid, input dwrite, input[31:0] dwdata,input[3:0] dwstb,output reg[31:0] drdata, output reg drready);
reg [32:0] data_memory[256:0];
always@(*)
begin
if(dvalid)
begin
drdata = data_memory[daddr];
drready = 1;
end
end
always@(*)
begin
if(dwrite)
data_memory[daddr] = dwdata;
end

endmodule
