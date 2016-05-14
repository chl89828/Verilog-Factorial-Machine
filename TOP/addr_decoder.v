module addr_decoder(addr, S0_sel, S1_sel, S2_sel);	//module of address decoder in bus
	input[3:0] addr;									//upper 4bit of address of bus
	output reg S0_sel, S1_sel, S2_sel;						//output port - S0_sel, S1_sel, slave select signal
	
	always@(addr)		
	if(addr==4'h0)					//when addr is 0
		{S0_sel, S1_sel, S2_sel}=3'b100;						//slave 0 is selected.
	else if(addr==4'h1)			//when addr is 1
		{S0_sel, S1_sel, S2_sel}=3'b010;						//slave 1 is selected
	else if(addr==4'h2)			//when addr is 2											
		{S0_sel, S1_sel, S2_sel}=3'b001;						//slave 2 is selected
	else																//default. any slave is not selected.
		{S0_sel, S1_sel, S2_sel}=3'b000;
		
endmodule												//endmodule

