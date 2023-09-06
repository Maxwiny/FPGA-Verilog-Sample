`timescale 1ns / 1ns

module tb_uart_rx();

reg	clk;
reg	rstn;
reg	rxd;
wire	done;
wire	[7:0]	data;
	
uart_rx uart_rx_inst(
	.clk(clk),
	.rstn(rstn),
	.rxd(rxd),
	.done(done),
	.data(data)
);


initial clk = 1;
always#10 clk = ~clk;

initial begin
	rstn = 0;
	rxd = 1;
	#201;
	rstn = 1;
	#100;
	uart_byte_tx(8'h22);
	#90000;
	uart_byte_tx(8'h11);
	#90000;
	uart_byte_tx(8'h33);
	#90000;
	uart_byte_tx(8'h34);
	#90000;
	$stop;
end

task uart_byte_tx;
	input	[7:0]	tx_data;
	begin
		rxd = 1;
		#20;
		rxd = 0;
		#8680;
		rxd = tx_data[0];
		#8680;
		rxd = tx_data[1];
		#8680;
		rxd = tx_data[2];
		#8680;
		rxd = tx_data[3];
		#8680;
		rxd = tx_data[4];
		#8680;
		rxd = tx_data[5];
		#8680;
		rxd = tx_data[6];
		#8680;
		rxd = tx_data[7];
		#8680;
		rxd = 1;
		#8680;	
	end
endtask

endmodule
