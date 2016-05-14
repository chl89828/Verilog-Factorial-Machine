//module of 8 32-bits register // this is used to implement register file of FIFO_OUT
module register32_32(clk, reset_n, en, d_in, d_out0,d_out1, d_out2, d_out3, d_out4, d_out5, d_out6, d_out7
							, d_out8, d_out9, d_out10, d_out11, d_out12, d_out13, d_out14, d_out15, d_out16, d_out17
							, d_out18, d_out19, d_out20, d_out21, d_out22, d_out23, d_out24, d_out25, d_out26
							, d_out27, d_out28, d_out29, d_out30, d_out31);
	
	input clk, reset_n;		//input ports clk - clock, reset_n - ~(reset)
	input [31:0]en, d_in;	//input ports en - 31bits enable signal , d_in- 32-bit input data
									
									//output ports - 32 32-bits result value
	output[31:0]		d_out0 ,d_out1, d_out2, d_out3, d_out4, d_out5, d_out6, d_out7
							, d_out8, d_out9, d_out10, d_out11, d_out12, d_out13, d_out14
							, d_out15, d_out16, d_out17, d_out18, d_out19, d_out20, d_out21
							, d_out22, d_out23, d_out24, d_out25, d_out26 , d_out27, d_out28
							, d_out29, d_out30, d_out31;
	
	//instances of register 32_r_en // each 32 output is inputted in instance of register 32_r_en
	//And as enable signal, only one d_out is selected.
	register32_r_en U0_register32_r_en(.clk(clk), .reset_n(reset_n), .d_in(d_in), .d_out(d_out0), .en(en[0]));
	register32_r_en U1_register32_r_en(.clk(clk), .reset_n(reset_n), .d_in(d_in), .d_out(d_out1), .en(en[1]));
	register32_r_en U2_register32_r_en(.clk(clk), .reset_n(reset_n), .d_in(d_in), .d_out(d_out2), .en(en[2]));
	register32_r_en U3_register32_r_en(.clk(clk), .reset_n(reset_n), .d_in(d_in), .d_out(d_out3), .en(en[3]));
	register32_r_en U4_register32_r_en(.clk(clk), .reset_n(reset_n), .d_in(d_in), .d_out(d_out4), .en(en[4]));
	register32_r_en U5_register32_r_en(.clk(clk), .reset_n(reset_n), .d_in(d_in), .d_out(d_out5), .en(en[5]));
	register32_r_en U6_register32_r_en(.clk(clk), .reset_n(reset_n), .d_in(d_in), .d_out(d_out6), .en(en[6]));
	register32_r_en U7_register32_r_en(.clk(clk), .reset_n(reset_n), .d_in(d_in), .d_out(d_out7), .en(en[7]));	
	register32_r_en U8_register32_r_en(.clk(clk), .reset_n(reset_n), .d_in(d_in), .d_out(d_out8), .en(en[8]));
	register32_r_en U9_register32_r_en(.clk(clk), .reset_n(reset_n), .d_in(d_in), .d_out(d_out9), .en(en[9]));
	register32_r_en U10_register32_r_en(.clk(clk), .reset_n(reset_n), .d_in(d_in), .d_out(d_out10), .en(en[10]));
	register32_r_en U11_register32_r_en(.clk(clk), .reset_n(reset_n), .d_in(d_in), .d_out(d_out11), .en(en[11]));
	register32_r_en U12_register32_r_en(.clk(clk), .reset_n(reset_n), .d_in(d_in), .d_out(d_out12), .en(en[12]));
	register32_r_en U13_register32_r_en(.clk(clk), .reset_n(reset_n), .d_in(d_in), .d_out(d_out13), .en(en[13]));
	register32_r_en U14_register32_r_en(.clk(clk), .reset_n(reset_n), .d_in(d_in), .d_out(d_out14), .en(en[14]));
	register32_r_en U15_register32_r_en(.clk(clk), .reset_n(reset_n), .d_in(d_in), .d_out(d_out15), .en(en[15]));	
	register32_r_en U16_register32_r_en(.clk(clk), .reset_n(reset_n), .d_in(d_in), .d_out(d_out16), .en(en[16]));
	register32_r_en U17_register32_r_en(.clk(clk), .reset_n(reset_n), .d_in(d_in), .d_out(d_out17), .en(en[17]));
	register32_r_en U18_register32_r_en(.clk(clk), .reset_n(reset_n), .d_in(d_in), .d_out(d_out18), .en(en[18]));
	register32_r_en U19_register32_r_en(.clk(clk), .reset_n(reset_n), .d_in(d_in), .d_out(d_out19), .en(en[19]));
	register32_r_en U20_register32_r_en(.clk(clk), .reset_n(reset_n), .d_in(d_in), .d_out(d_out20), .en(en[20]));
	register32_r_en U21_register32_r_en(.clk(clk), .reset_n(reset_n), .d_in(d_in), .d_out(d_out21), .en(en[21]));
	register32_r_en U22_register32_r_en(.clk(clk), .reset_n(reset_n), .d_in(d_in), .d_out(d_out22), .en(en[22]));
	register32_r_en U23_register32_r_en(.clk(clk), .reset_n(reset_n), .d_in(d_in), .d_out(d_out23), .en(en[23]));	
	register32_r_en U24_register32_r_en(.clk(clk), .reset_n(reset_n), .d_in(d_in), .d_out(d_out24), .en(en[24]));
	register32_r_en U25_register32_r_en(.clk(clk), .reset_n(reset_n), .d_in(d_in), .d_out(d_out25), .en(en[25]));
	register32_r_en U26_register32_r_en(.clk(clk), .reset_n(reset_n), .d_in(d_in), .d_out(d_out26), .en(en[26]));
	register32_r_en U27_register32_r_en(.clk(clk), .reset_n(reset_n), .d_in(d_in), .d_out(d_out27), .en(en[27]));
	register32_r_en U28_register32_r_en(.clk(clk), .reset_n(reset_n), .d_in(d_in), .d_out(d_out28), .en(en[28]));
	register32_r_en U29_register32_r_en(.clk(clk), .reset_n(reset_n), .d_in(d_in), .d_out(d_out29), .en(en[29]));
	register32_r_en U30_register32_r_en(.clk(clk), .reset_n(reset_n), .d_in(d_in), .d_out(d_out30), .en(en[30]));
	register32_r_en U31_register32_r_en(.clk(clk), .reset_n(reset_n), .d_in(d_in), .d_out(d_out31), .en(en[31]));		
endmodule
