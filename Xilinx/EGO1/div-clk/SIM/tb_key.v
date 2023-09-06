`timescale 1ns / 1ps

module tb_key();

reg	clk;
reg	rstn;
reg	[1:0]	i_key;
	
wire	o_key_val;
wire	[1:0]	o_key;
key #(
	.p_system_clk('d100_000)
)key_inst(
	.clk(clk),
	.rstn(rstn),
	.i_key(i_key),
	.o_key_val(o_key_val),
	.o_key(o_key)
);

initial clk = 0;
always#5 clk = ~clk;

initial begin
	rstn = 1;
	#20;
	rstn = 0;
	i_key = 'b11;
	#201;
	rstn = 1;
	#50;
	i_key = 'b10;
	#20000;
	i_key = 'b01;
	#20000;
	i_key = 'b00;
	#20000;	 
	$stop;
end
endmodule
