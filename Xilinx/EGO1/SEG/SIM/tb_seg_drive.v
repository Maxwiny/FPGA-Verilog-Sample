`timescale 1ns / 1ns

module tb_seg_drive();

reg	clk;
reg	rstn;
reg	[31:0]	i_data;
wire	[3:0]	o_seg_pos;
wire	[7:0]	o_seg;

seg_drive_4bit#(
	.p_system_clk('d100_000_000)
)seg_inst1(
	.clk(clk),
	.rstn(rstn),
	.i_data(i_data),
	.o_seg_pos(o_seg_pos),
	.o_seg(o_seg)
);
initial clk = 1;
always#5 clk = ~clk;

initial begin
	rstn = 1;
	#10;
	rstn = 0;
	#201;
	rstn = 1;
	i_data = "1234";
	#10000000;
	$stop;
end


endmodule
