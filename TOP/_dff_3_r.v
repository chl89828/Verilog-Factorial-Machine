module _dff_3_r(clk, reset_n, d, q); 		//module of 3-bit register
	input clk, reset_n;
	input [2:0] d;
	output[2:0] q;
	_dff_r U0_drr_r(.clk(clk), .reset_n(reset_n), .d(d[0]), .q(q[0]));
	_dff_r U1_drr_r(.clk(clk), .reset_n(reset_n), .d(d[1]), .q(q[1]));
	_dff_r U2_drr_r(.clk(clk), .reset_n(reset_n), .d(d[2]), .q(q[2]));	

	
endmodule

