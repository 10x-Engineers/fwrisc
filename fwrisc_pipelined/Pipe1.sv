module Pipe1(input clock, input reset, input[31:0] idata, output reg[31:0] idata_p,input flush);
always@(posedge clock)
begin
if(reset || flush)
idata_p <= 0;
else
idata_p <= idata;
end
endmodule
