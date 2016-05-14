`timescale 1ns/ 100ps
module tb_FIFOTOP_IN;	//testbench of FIFOTOP_IN
	reg clk, reset_n;		//inputs of FIFOTOP_IN
	reg sel, wr;					
	reg [31:0] din;				
	reg [7:0] address;			
	
	wire [31:0] dout;		//outputs of FIFOTOP_IN		
	wire [3:0] fifo_cnt;			
	wire [5:0] fifo_flag;		
	
	always					//generate clock pulse
	begin
		clk=0; #5; clk=1; #5;
	end
	
	//instance of FIFOTOP_IN
	FIFOTOP_IN test_FIFOTOP_IN(clk, reset_n, sel, wr, address, din, dout, fifo_cnt, fifo_flag);

initial
		begin
			reset_n=0; sel=0;			//reset
#3;		reset_n=1; address=8'h11; sel=1; wr=1; din=32'h0000_0000;
//select this fifo_top, select first fifo of fifo_top, write signal
#10;		din=32'h1111_1111;
#10;		din=32'h2222_2222;
#10;		din=32'h3333_3333;
#10;		din=32'h4444_4444;
#10;		din=32'h5555_5555;
#10;		din=32'h6666_6666;
#10;		din=32'h7777_7777;
#10;		din=32'h8888_8888;
#10;		address=8'h10; wr=0;						//read signal
#50;		address=8'h10; din=32'h1111_1111;	//
#10;		wr=1;	 										//write signal
#10;		address=8'h11;
#10;		wr=0; address=8'h11;						//read signal
#100;		sel=0;										//not sel.
#10;		sel=1; address=8'h12;					//sel and strange address
#80;		$stop;									
		end
endmodule

