module tb_bus;			//tb of BUS

	reg tb_clk, tb_reset_n, tb_M0_req, tb_M0_wr, tb_M1_req, tb_M1_wr;		//input of BUS
	reg[7:0] tb_M0_address, tb_M1_address;
	reg[31:0] tb_M0_dout, tb_M1_dout, tb_S0_dout, tb_S1_dout, tb_S2_dout;
	
	wire tb_M0_grant, tb_M1_grant, tb_S0_sel, tb_S1_sel,tb_S2_sel, tb_S_wr;	//output of BUS
	wire[31:0] tb_M_din, tb_S_din;
	wire[7:0] tb_S_address;
	
	//instance of BUS
	BUS U0_bus(.clk(tb_clk), .reset_n(tb_reset_n), .M0_req(tb_M0_req), .M0_wr(tb_M0_wr), .M0_address(tb_M0_address), .M0_dout(tb_M0_dout)
				, .M1_req(tb_M1_req), .M1_wr(tb_M1_wr), .M1_address(tb_M1_address), .M1_dout(tb_M1_dout), .S0_dout(tb_S0_dout), .S1_dout(tb_S1_dout), .S2_dout(tb_S2_dout)
				, .M0_grant(tb_M0_grant), .M1_grant(tb_M1_grant), .M_din(tb_M_din), .S0_sel(tb_S0_sel), .S1_sel(tb_S1_sel),.S2_sel(tb_S2_sel), .S_address(tb_S_address), .S_wr(tb_S_wr), .S_din(tb_S_din));
				
	
	always	//generate clock pulse
	begin
	tb_clk=0; #5; tb_clk=1; #5;
	end
	
	initial
	begin
	tb_reset_n=0; tb_M0_address=8'h00; tb_M0_req=0; tb_M0_wr=0; tb_M0_dout=32'h0000_0000 ; tb_M1_req=0; tb_M1_address=8'h00; tb_M1_wr=0; tb_M1_dout=32'h0000_0000; tb_S0_dout=32'h0000_0000; tb_S1_dout=32'h0000_0000; tb_S2_dout=32'h0000_0000;
#17; tb_reset_n=1;	
#10;	tb_M0_req=1;	tb_S0_dout=32'h0000_0001; tb_S1_dout=32'h0000_0002; tb_S2_dout=32'h0000_0003;		//M0 req =1 //M0grant	
#10;	tb_M0_wr=1;													//M0_wr=1
#10;	tb_M0_address=8'h01; tb_M0_dout=32'h0000_0002;
#10;	tb_M0_address=8'h02; tb_M0_dout=32'h0000_0004;
#10;	tb_M0_address=8'h03;	tb_M0_dout=32'h0000_0006;
#10;	tb_M0_address=8'h10;	tb_M0_dout=32'h0000_0020; 
#10;	tb_M0_address=8'h11;	tb_M0_dout=32'h0000_0022;
#10;	tb_M0_address=8'h20;	tb_M0_dout=32'h0000_0042;
#10; 	tb_M0_req=0; tb_M1_req=1;								//M0_req=0 M1_req=1  M0_grant --> M1_grant
#20;	$stop;	
	end
	
endmodule
	
	