module _dff_r(clk, reset_n, d, q);	//module of resettable D flip flop
	input clk, reset_n, d;				//input ports clk - clock , reset_n - ~(reset signal)	, d - input data
	output reg q;							// output q - result value
	
	always@ (posedge clk or negedge reset_n)	//whenever clock purse is rising edge or reset_n is falling edge 
	begin													
		if(reset_n == 0) q <= 1'b0;				//if reset_n is 0 , q is 0
		else q<=d;										//else if reset_n isn't 0, q is d
	end
	
endmodule									//end module


	