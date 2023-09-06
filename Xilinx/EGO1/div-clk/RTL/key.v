`timescale 1ns / 1ps

module key#(
	parameter	p_system_clk = 'd100_000_000
)(
	input	wire	clk,
	input	wire	rstn,
	input	wire	[1:0]	i_key,
	
	output	reg	o_key_val,
	output	reg	[1:0]	o_key
);
    
reg	[1:0]	r_key_buf;
reg	[1:0]	r_state;
reg	[19:0]	r_delay_cnt;

localparam	l_idle = 'b0;
localparam	l_delay_20ms = 'b1;
localparam	l_out = 'b10;

localparam p_delay_max = p_system_clk / 100 - 1;

always@(posedge clk or negedge rstn)
	if(rstn == 0)begin
		r_key_buf <= #1 'b0;
	end else begin
		r_key_buf <= #1 i_key;
	end
	
always@(posedge clk or negedge rstn)
	if(rstn == 0)begin
		r_delay_cnt <= #1 0;
	end else if(r_state == l_delay_20ms)begin
		if(r_delay_cnt == p_delay_max)begin
			r_delay_cnt <= #1 0;
		end else begin
			r_delay_cnt <= #1 r_delay_cnt + 'b1;
		end
	end else begin
		r_delay_cnt <= #1 'b0;
	end
	
always@(posedge clk or negedge rstn)
	if(rstn == 0)begin
		r_state <= #1 l_idle;
		o_key_val <= #1 1'b0;
		o_key <= #1 'b0;
	end else begin
		case(r_state)
			l_idle:begin
				if(r_key_buf != i_key)begin
					r_state <= #1 l_delay_20ms;
				end else begin
					r_state <= #1 l_idle;
				end
				o_key_val <= #1 1'b0;
			end
			l_delay_20ms:begin
				if(r_delay_cnt == p_delay_max) r_state <= l_out;
				else r_state <= #1 l_delay_20ms;
			end
			l_out:begin
				r_state <= #1 l_idle;
				o_key <= #1 i_key;
				o_key_val <= #1 1;
			end
		endcase
	end
endmodule
