module fw_testbench;
reg clk,reset;
main_fw fw(clk,reset);
initial
begin
clk = 0;
reset =0;
#10 reset =1;
#100 reset = 0;
end
always
begin
#50; clk = ~clk;
end
endmodule

