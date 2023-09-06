`timescale 1ns / 1ns

module uart_rx#(
	parameter	p_sys_clk = 'd50_000_000,
	parameter	p_baud_rate = 'd115200
)(
	input	wire	clk,
	input	wire	rstn,
	input	wire	rxd,
	
	output	reg	done,
	output	reg	[7:0]	data
);

localparam	l_baud_max = (p_sys_clk / p_baud_rate / 16);


reg	[1:0]	r_uart_rx_buf;
reg	en;
reg	[15:0]	baud_cnt;
reg	[7:0]	bps_cnt;
reg	[2:0]	r_data[7:0];
reg	[2:0]	sta_bit;
reg	[2:0]	sto_bit;

wire	nedge_rx_start;
wire	bps_clk_16x = (baud_cnt == l_baud_max / 2);

assign	nedge_rx_start = (r_uart_rx_buf == 2'b10);

/* catch nedge*/
always@(posedge	clk or negedge rstn)
	if(rstn == 0) 
		r_uart_rx_buf <= #1 2'b00;
	else begin
		r_uart_rx_buf[0] <= #1 rxd;
		r_uart_rx_buf[1] <= #1 r_uart_rx_buf[0];
	end

/* en create*/	
always@(posedge clk or negedge rstn)
	if(rstn == 0)
		en <= #1 0;
	 else if(nedge_rx_start == 1)
	 	en <= #1 1;
	 else if(sta_bit[2] == 1 || bps_cnt == 159)
	 	en <= #1 0;
	 
/* div count create*/
always@(posedge clk or negedge rstn)
	if(rstn == 0)begin
		baud_cnt <= #1 0;
	end else if(en == 1)begin
		if(baud_cnt == l_baud_max - 1)begin
			baud_cnt <= #1 0;
		end else begin
			baud_cnt <= #1 baud_cnt + 'd1;
		end
	end else begin
		baud_cnt <= #1 0;
	end
	
/* bps count create*/
always@(posedge clk or negedge rstn)
	if(rstn == 0)begin
		bps_cnt <= #1 0;
	end else if(en == 1)begin
		if(bps_clk_16x == 1)
			if(bps_cnt == 159)begin
				bps_cnt <= #1 0;
			end else begin
				bps_cnt <= #1 bps_cnt + 'd1;
			end
	end else begin
		bps_cnt <= #1 0;
	end
	
/* multi-sample*/
always@(posedge clk or negedge rstn)
	if(rstn == 0)begin
		sta_bit <= #1 0;
		r_data[0] <= #1 0;
		r_data[1] <= #1 0;
		r_data[2] <= #1 0;
		r_data[3] <= #1 0;
		r_data[4] <= #1 0;
		r_data[5] <= #1 0;
		r_data[6] <= #1 0;
		r_data[7] <= #1 0;
		sto_bit <= #1 0;
	end else if(en) 
		if(bps_clk_16x)
			case(bps_cnt)
				0:	begin
					sta_bit <= #1 0;
					r_data[0] <= #1 0;
					r_data[1] <= #1 0;
					r_data[2] <= #1 0;
					r_data[3] <= #1 0;
					r_data[4] <= #1 0;
					r_data[5] <= #1 0;
					r_data[6] <= #1 0;
					r_data[7] <= #1 0;
					sto_bit <= #1 0;
					end
				5,6,7,8,9,10,11: sta_bit <= #1 sta_bit + rxd; 
				21,22,23,24,25,26,27: r_data[0] <= #1 r_data[0] + rxd; 
				37,38,39,40,41,42,43: r_data[1] <= #1 r_data[1] + rxd; 
				53,54,55,56,57,58,59: r_data[2] <= #1 r_data[2] + rxd; 
				69,70,71,72,73,74,75: r_data[3] <= #1 r_data[3] + rxd; 
				85,86,87,88,89,90,91: r_data[4] <= #1 r_data[4] + rxd; 
				101,102,103,104,105,106,107: r_data[5] <= #1 r_data[5] + rxd; 
				117,118,119,120,121,122,123: r_data[6] <= #1 r_data[6] + rxd; 
				133,134,135,136,137,138,139: r_data[7] <= #1 r_data[7] + rxd; 
				149,150,151,152,153,154,155: sto_bit <= #1 sto_bit + rxd; 
			endcase

/* data create*/
always@(posedge clk or negedge rstn)
	if(rstn == 0)
		data <= 8'h00;
	else if(bps_cnt == 159)begin
		data[0] <= #1 r_data[0][2];
		data[1] <= #1 r_data[1][2];
		data[2] <= #1 r_data[2][2];
		data[3] <= #1 r_data[3][2];
		data[4] <= #1 r_data[4][2];
		data[5] <= #1 r_data[5][2];
		data[6] <= #1 r_data[6][2];
		data[7] <= #1 r_data[7][2];
	end
	
/* done create*/
always@(posedge clk or negedge rstn)
	if(rstn == 0)
		done <= #1 0;
	else if(bps_cnt == 159)
		done <= #1 1;
	else
		done <= #1 0;
	
endmodule
