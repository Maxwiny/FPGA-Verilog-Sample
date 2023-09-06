`timescale 1ns / 1ns

module tb_uart_tx();

reg	clk;
reg	rstn;
reg	en;
reg	[7:0]	data;
wire	done;
wire	txd;

uart_tx	tx_isnt1(
	.clk(clk),
	.rstn(rstn),
	.en(en),
	.data(data),
	.done(done),
	.txd(txd)
);

initial clk = 1;
always#10 clk = ~clk;

initial begin
	rstn = 0;
	en = 0;
	#201;
	rstn = 1;
	#100;
	data = 8'h55;
	en = 1;
	@(posedge done);
	en = 0;
	#100000;
	data = 8'h15;
	en = 1;
	@(posedge done);
	en = 0;
	#1000000;

	$stop;
end


endmodule
