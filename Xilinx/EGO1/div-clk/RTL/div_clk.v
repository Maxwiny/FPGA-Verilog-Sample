`timescale 1ns / 1ns

module div_clk(
	input	wire	clk,
	input	wire	rstn,
	input	wire	[15:0]	i_div_num,
	input	wire	i_sw,
	
	output	wire	o_div_clk
);

reg	[15:0]	r_div_cnt;
reg	[15:0]	r_div_cnt1;
reg	r_clk_a;
reg	r_clk_b;

wire	w_div_type;	//0 even, 1 odd

assign w_div_type = i_div_num[0];
assign o_div_clk = r_clk_a | r_clk_b;

/*div counter*/
always@(posedge clk or negedge rstn)
	if(rstn == 0)begin
		r_div_cnt <= #1 0;
	end else if(i_sw == 1)begin
		if(r_div_cnt == i_div_num - 1) r_div_cnt <= #1 0;
		else r_div_cnt <= #1 r_div_cnt + 'd1;
	end else begin
		r_div_cnt <= #1 0;
	end
/*div counter1*/
always@(negedge clk or negedge rstn)
	if(rstn == 0)begin
		r_div_cnt1 <= #1 0; 
	end else if(i_sw == 1 && w_div_type == 1)begin
		if(r_div_cnt1 == i_div_num - 1) r_div_cnt1 <= #1 0;
		else r_div_cnt1 <= #1 r_div_cnt1 + 'd1;
	end else r_div_cnt1 <= #1 0;

/* div create*/	
always@(posedge clk or negedge rstn)
	if(rstn == 0)begin
		r_clk_a <= #1 1'b0;
	end else if(w_div_type == 0 && i_sw == 1)begin
		if(r_div_cnt == i_div_num/2 - 1) r_clk_a <= #1 ~r_clk_a;
		else r_clk_a <= #1 r_clk_a;
	end  else if(w_div_type == 1 && i_sw == 1)begin
		if(r_div_cnt == i_div_num - 1) r_clk_a <= #1 1;
		else if(r_div_cnt == (i_div_num - 1'b1)/2 - 1) r_clk_a <= #1 1'b0;
	end else r_clk_a <= #1 1'b0;
	
always@(negedge clk or negedge rstn)
	if(rstn == 0)begin
		r_clk_b <= #1 1'b0;
	end else if(w_div_type == 1 && i_sw == 1)begin
		if(r_div_cnt1 == i_div_num - 1) r_clk_b <= #1 1;
		else if(r_div_cnt1 == (i_div_num - 1'b1)/2 - 1) r_clk_b <= #1 1'b0;
	end else begin
		r_clk_b <= #1 1'b0;
	end
endmodule
