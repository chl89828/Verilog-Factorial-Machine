module arbiter(M0_req, M1_req, reset_n, clk, M0_grant, M1_grant);		// module of arbiter
	input M0_req, M1_req, reset_n, clk;									//input port M0_req - master0 request, master1 request
																					//clk-clock , reset_n - reset signal
	output reg M0_grant, M1_grant;										//output port : M0_grant - state of master1
																					//M1_grant - state of master2
	reg next_M0_grant, next_M1_grant;									//reg next state
	
	parameter M0GRANT=2'b10;												//parameterize state
	parameter M1GRANT=2'b01;
	
	always@(posedge clk or negedge reset_n)							//when state is changed.
		if(reset_n==0)															//when reset_n is 0
			{M0_grant, M1_grant}=M0GRANT;									//state is M0grant
		else																		//when clock is rising edge
			{M0_grant, M1_grant}={next_M0_grant, next_M1_grant};	//current state is next state
		
			
	always@(M0_req, M1_req, M0_grant, M1_grant)						//next state logic
		case({M0_grant, M1_grant})
		2'b10 : if((M0_req==0 && M1_req==1))							//when current state is M0GRANT
					{next_M0_grant, next_M1_grant}=M1GRANT;			//if M0_req is 0 and M1_req is 1, next state is M1GRANT
					else															//if not, state is not changed.
					{next_M0_grant, next_M1_grant}=M0GRANT;
		2'b01 : if(M0_req==1 && M1_req==0)								//when current state is M1GRANT
					{next_M0_grant, next_M1_grant}=M0GRANT;			//if M0_req is 1 and M1-req is 0, next state is M0GRANT
					else															//if not, state is not changed.
					{next_M0_grant, next_M1_grant}=M1GRANT;
		default : {next_M0_grant, next_M1_grant}=2'bx;				//default value : 
		endcase

endmodule							//endmodule			
			