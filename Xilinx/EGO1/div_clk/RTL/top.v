`timescale 1ns / 1ns

module top(
	input	wire	clk,
	input	wire	rst,
	input	wire	[1:0]	i_key,
	input	wire	i_sw,
	
	output	wire	o_div_clk
);

reg	[15:0]	r_div_num;

wire	w_key_val;
wire	[1:0]	w_key;
wire	rstn;
assign rstn = ~rst;
key key_inst(
	.clk(clk),
	.rstn(rstn),
	.i_key(i_key),
	.o_key_val(w_key_val),
	.o_key(w_key)
);

div_clk div_inst(
	.clk(clk),
	.rstn(rstn),
	.i_div_num(r_div_num),
	.i_sw(i_sw),
	.o_div_clk(o_div_clk)
);

always@(posedge clk or negedge rstn)
	if(rstn == 0)begin
		r_div_num <= #1 'd200;
	end else if(w_key_val == 1)begin
		case(w_key)
			'b01: r_div_num <= #1 r_div_num + 'd100;
			'b10: r_div_num <= #1 r_div_num - 'd100;
		endcase
	end
    
endmodule
