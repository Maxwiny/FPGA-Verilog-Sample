`timescale 1ns / 1ns

module uart_tx#(
	parameter	p_sys_clk = 'd50_000_000,
	parameter	p_baud = 'd115200
)(
	input	wire	clk,
	input	wire	rstn,
	input	wire	en,
	input	wire	[7:0]	data,
	
	output	reg	done,
	output	reg	txd
);

localparam	l_baud_max = p_sys_clk / p_baud - 1;

reg	[19:0]	baud_cnt;
reg	[3:0]	bps_cnt; 

/* baud cnt */
always@(posedge clk or negedge rstn)
	if(rstn == 0)begin
		baud_cnt <= #1 0;
	end else if(en == 1)begin
		if(baud_cnt == l_baud_max)begin
			baud_cnt <= #1 0;
		end else begin
			baud_cnt <= #1 baud_cnt + 'd1;
		end
	end else begin
		baud_cnt <= #1 0;
	end

/* bps cnt*/
always@(posedge clk or negedge rstn)
	if(rstn == 0)begin
		bps_cnt <= #1 0;
	end else if(en == 1)begin
		if(baud_cnt == 1)begin
			if(bps_cnt == 'd11)begin
				bps_cnt <= #1 0;
			end else begin
				bps_cnt <= #1 bps_cnt + 'd1;
			end
		end
	end else begin
		bps_cnt <= #1 0;
	end

/* txd create*/
always@(posedge clk or negedge rstn)
	if(rstn == 0)begin
		txd <= #1 1;
		done <= #1 0;
	end else case(bps_cnt)
		'd0: done <= #1 0;
		'd1: txd <= #1 0;
		'd2: txd <= #1 data[0];
		'd3: txd <= #1 data[1];
		'd4: txd <= #1 data[2];
		'd5: txd <= #1 data[3];
		'd6: txd <= #1 data[4];
		'd7: txd <= #1 data[5];
		'd8: txd <= #1 data[6];
		'd9: txd <= #1 data[7];
		'd10: txd <= #1 1;
		'd11: 	begin
			txd <= #1 1;
			done <= #1 1;
			end
		default: txd <= #1 1;
	endcase

endmodule
