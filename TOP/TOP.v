module TOP(clk, reset_n, M0_req, M0_wr, M0_address, M0_dout, M0_grant, interrupt, M_din, fifo_cnt_in
				, fifo_cnt_out, fifo_flag_in, fifo_flag_out);
	input clk, reset_n, M0_req, M0_wr;				//input ports
	input [7:0] M0_address;	
	input [31:0] M0_dout;
	
	output M0_grant, interrupt;						//output ports
	output[31:0] M_din;
	output[3:0] fifo_cnt_in;
	output [5:0] fifo_cnt_out, fifo_flag_in, fifo_flag_out;
	
	wire M1_req, M1_wr, M1_grant;						//wire pors - wires between BUS and (FACTORIAL or FIFOTOP)
	wire [7:0] M1_address;
	wire [31:0] M1_dout;
	
	wire S0_sel, S1_sel, S2_sel, S_wr;				
	wire [7:0] S_address;
	wire [31:0] S_din, S0_dout, S1_dout, S2_dout;

	//instance of BUS
	BUS U0_BUS(.clk(clk), .reset_n(reset_n), .M0_req(M0_req), .M0_wr(M0_wr), .M0_address(M0_address), .M0_dout(M0_dout)
					, .M1_req(M1_req), .M1_wr(M1_wr), .M1_address(M1_address), .M1_dout(M1_dout), .S0_dout(S0_dout), .S1_dout(S1_dout)
					, .S2_dout(S2_dout), .M0_grant(M0_grant), .M1_grant(M1_grant), .M_din(M_din), .S0_sel(S0_sel)
					, .S1_sel(S1_sel), .S2_sel(S2_sel), .S_address(S_address), .S_wr(S_wr), .S_din(S_din));	
	
	//instance of FACTORIAL
	FACTORIAL U1_FACTORIAL(.clk(clk), .reset_n(reset_n), .S_sel(S0_sel), .S_wr(S_wr), .S_address(S_address), .S_din(S_din)
									, .M_grant(M1_grant), .M_din(M_din), .S_dout(S0_dout), .M_req(M1_req), .M_wr(M1_wr), .M_address(M1_address)
									, .M_dout(M1_dout), .interrupt(interrupt));
	
	//instance of FIFOTOP_IN
	FIFOTOP_IN U2_FIFOTOP_IN(.clk(clk), .reset_n(reset_n), .sel(S1_sel), .wr(S_wr), .address(S_address), .din(S_din), .dout(S1_dout)
									, .fifo_cnt(fifo_cnt_in), .fifo_flag(fifo_flag_in));
			
	//instance of FIFOTOP_OUT
	FIFOTOP_OUT U3_FIFOTOP_OUT(.clk(clk), .reset_n(reset_n), .sel(S2_sel), .wr(S_wr), .address(S_address), .din(S_din), .dout(S2_dout)
										, .fifo_cnt(fifo_cnt_out), .fifo_flag(fifo_flag_out));
	
endmodule

