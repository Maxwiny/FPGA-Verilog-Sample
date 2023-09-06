`timescale 1ns / 1ps

module tb_div();
reg	clk;
reg	rstn;
reg	[7:0]	i_div_num;
reg	i_sw;
wire	o_div_clk;

div_clk div_inst(
	.clk(clk),
	.rstn(rstn),
	.i_div_num(i_div_num),
	.i_sw(i_sw),
	.o_div_clk(o_div_clk)
);
initial clk = 0;
always#5 clk = ~clk;

initial begin
	rstn = 1;
	i_sw = 0;
	i_div_num = 'd10;
	#20;
	rstn = 0;
	#201
	rstn = 1;
	i_sw = 1;
	#10000;
	$stop;	
end	
endmodule
