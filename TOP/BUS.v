module BUS(clk, reset_n, M0_req, M0_wr, M0_address, M0_dout, M1_req, M1_wr, M1_address, M1_dout, S0_dout, S1_dout, S2_dout
				, M0_grant, M1_grant, M_din, S0_sel, S1_sel, S2_sel, S_address, S_wr, S_din); //module of bus // slave and master 
				
	input clk, reset_n, M0_req, M0_wr, M1_req, M1_wr;			//input port : M0_req - master0 request,  M1_req - master1 request
																				//M0_wr,M1_wr - master's request - read or write
	input[7:0] M0_address, M1_address;								//address of requested
	input[31:0] M0_dout, M1_dout, S0_dout, S1_dout, S2_dout;	//M0_dout, M1_dout - master's output, S0_dout,S1_dout,S2_dout - slave's output
	
	output M0_grant, M1_grant, S0_sel, S1_sel, S2_sel, S_wr;	//M0_grant,M1_grant-state in arbiter , S0_sel,S1_sel,S2_sel - slave selected 
																				//S_wr - wr selected
	output[31:0] M_din, S_din;											//M_din-to master slave's data, S_din-to slave master's data
	output[7:0] S_address;												//slave's address
	
	reg S_wr;														
	reg [7:0] S_address;
	reg [31:0] S_din, M_din;
	
	reg next_S0_sel, next_S1_sel, next_S2_sel;					// reg next sel
	
	arbiter U0_arbiter(.M0_req(M0_req), .M1_req(M1_req), .reset_n(reset_n), .clk(clk), .M0_grant(M0_grant), .M1_grant(M1_grant));
	//instance of arbiter

	addr_decoder U1_addr_decoder(.addr(S_address[7:4]), .S0_sel(S0_sel), .S1_sel(S1_sel), .S2_sel(S2_sel));
	//instance of addr_decoder
	
	always@(M0_grant, M1_grant,M0_wr, M0_address, M0_dout, M1_wr, M1_address, M1_dout)
		if(M0_grant==1 && M1_grant==0)	//when M0GRANT is, slave data is master0's data
			begin									
				S_wr=M0_wr;
				S_address=M0_address;
				S_din=M0_dout;
			end
		else if(M0_grant==0 && M1_grant==1)	
			begin									//when M1GRANT is, slave data is master1's data
				S_wr=M1_wr;
				S_address=M1_address;
				S_din=M1_dout;
			end
		else										//default value
			begin
				S_wr=1'bx;
				S_address=8'bx;
				S_din=32'bx;
			end
	
	always@(posedge clk)						//sel signals pass to register 
		begin
		next_S0_sel<=S0_sel;
		next_S1_sel<=S1_sel;
		next_S2_sel<=S2_sel;
		end
	
	always@(next_S0_sel, next_S1_sel, next_S2_sel, S0_dout, S1_dout, S2_dout)	//din data to master is selected as next_sel.
		if(next_S0_sel==1)					//when next_S0_sel==1 and next-S1_sel==0, M_din is S0_dout.
			M_din=S0_dout;
		else if(next_S1_sel==1)				//when next_S0_sel==0 and next_S1_sel==1, M_din is S1_dout
			M_din=S1_dout;
		else if(next_S2_sel==1)
			M_din=S2_dout;
		else										//default value
			M_din=32'h0;
			
endmodule										//end module
