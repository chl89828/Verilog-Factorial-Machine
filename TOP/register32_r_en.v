module register32_r_en(clk, reset_n, d_in, d_out, en);		//module of 32-bit resettable and enable register
	input clk, reset_n, en;					//input ports clk - clock, reset_n - ~reset, en - enable signal 
	input [31:0] d_in;						//32-bit input data to register
	output reg[31:0] d_out;					//32-bit output data from register
	
	always@(posedge clk or negedge reset_n)	//always statement, whenever clk is rising edge or reset_n is falling edge
	begin
		if(reset_n==0) d_out<=32'b0;				//if reset_n is 0 , d_out is 0 - reset activated
		else if(en==1) d_out<=d_in;				//else if en==1, d_dout is d_in
	else				d_out<=d_out;					//else(en==0), register print previous d_out
	end
endmodule												//endmodule

