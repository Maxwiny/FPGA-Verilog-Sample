`timescale 1ns / 1ns

module uart_echo(
	input	wire	clk,
	input	wire	rstn,
	input	wire	rxd,
	
	output	wire	txd
);
 
reg	r_tx_en;
wire	[7:0]	w_data; 
wire	w_tx_done;
wire	w_rx_done;

/* tx-en create*/
always@(posedge clk or negedge rstn)
	if(rstn == 0)
		r_tx_en <= #1 0;
	else if(w_rx_done == 1)
		r_tx_en <= #1 1;
	else if(w_tx_done == 1)
		r_tx_en <= #1 0;
	else
		r_tx_en <= #1 r_tx_en;
		

uart_tx tx_inst1(
	.clk(clk),
	.rstn(rstn),
	.en(r_tx_en),
	.data(w_data),
	.done(w_tx_done),
	.txd(txd)
);

uart_rx	rx_inst1(
	.clk(clk),
	.rstn(rstn),
	.rxd(rxd),
	.done(w_rx_done),
	.data(w_data)
);
endmodule
