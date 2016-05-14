module register32_8(clk, reset_n, en, d_in, d_out0,d_out1, d_out2, d_out3, d_out4, d_out5, d_out6, d_out7);
//module of 8 32-bits register // this is used to implement register file of FIFO_IN
	input clk, reset_n;	//input ports clk - clock, reset_n - ~(reset)
	input [7:0]en;			//input port en - 8bits enable signal
	input [31:0]d_in;		//input port d_in - 32-bits data
	output[31:0]d_out0, d_out1, d_out2, d_out3, d_out4, d_out5, d_out6, d_out7;//output ports - 8 32-bits result value
	
	//instance of register 32_r_en // each 8 output is inputted in instance of register 32_r_en
	register32_r_en U0_register32_r_en(.clk(clk), .reset_n(reset_n), .d_in(d_in), .d_out(d_out0), .en(en[0]));
	register32_r_en U1_register32_r_en(.clk(clk), .reset_n(reset_n), .d_in(d_in), .d_out(d_out1), .en(en[1]));
	register32_r_en U2_register32_r_en(.clk(clk), .reset_n(reset_n), .d_in(d_in), .d_out(d_out2), .en(en[2]));
	register32_r_en U3_register32_r_en(.clk(clk), .reset_n(reset_n), .d_in(d_in), .d_out(d_out3), .en(en[3]));
	register32_r_en U4_register32_r_en(.clk(clk), .reset_n(reset_n), .d_in(d_in), .d_out(d_out4), .en(en[4]));
	register32_r_en U5_register32_r_en(.clk(clk), .reset_n(reset_n), .d_in(d_in), .d_out(d_out5), .en(en[5]));
	register32_r_en U6_register32_r_en(.clk(clk), .reset_n(reset_n), .d_in(d_in), .d_out(d_out6), .en(en[6]));
	register32_r_en U7_register32_r_en(.clk(clk), .reset_n(reset_n), .d_in(d_in), .d_out(d_out7), .en(en[7]));	
	
endmodule		//end module


	