module tb_FIFOTOP_OUT;
	reg clk, reset_n;			//input ports clock and reset_n
	reg sel, wr;					//input ports select, wr -> ==1 : write , ==0 : read
	reg [31:0] din;				//input 32-bit data 
	reg [7:0] address;			//8-bit input port address of fifo
	
	wire [31:0] dout;			//output port 32-bit data
	wire [5:0] fifo_cnt;		//output port selected fifo's data number
	wire [5:0] fifo_flag;		//output port selected fifo's status
	
	always
	begin
		clk=0; #5; clk=1; #5;
	end

	FIFOTOP_OUT U0_FIFOTOP_OUT(clk, reset_n, sel, wr, address, din, dout, fifo_cnt, fifo_flag);

initial
		begin
			reset_n=0; sel=0;			//reset
#3;		reset_n=1; address=8'h21; sel=1; wr=1; din=32'h1000_0000;
//select this fifo_top, select first fifo of fifo_top, write signal
#10;		din=32'h0000_1111;
#10;		din=32'h0000_2222;
#10;		din=32'h0000_3333;
#10;		din=32'h0000_4444;
#10;		din=32'h0000_5555;
#10;		din=32'h0000_6666;
#10;		din=32'h0000_7777;
#10;		din=32'h0000_8888;

#10;		din=32'h0001_1111;
#10;		din=32'h0001_2222;
#10;		din=32'h0001_3333;
#10;		din=32'h0001_4444;
#10;		din=32'h0001_5555;
#10;		din=32'h0001_6666;
#10;		din=32'h0001_7777;
#10;		din=32'h0001_8888;

#10;		din=32'h0011_1111;
#10;		din=32'h0011_2222;
#10;		din=32'h0011_3333;
#10;		din=32'h0011_4444;
#10;		din=32'h0011_5555;
#10;		din=32'h0011_6666;
#10;		din=32'h0011_7777;
#10;		din=32'h0011_8888;

#10;		din=32'h0101_1111;
#10;		din=32'h0101_2222;
#10;		din=32'h0101_3333;
#10;		din=32'h0101_4444;
#10;		din=32'h0101_5555;
#10;		din=32'h0101_6666;
#10;		din=32'h0101_7777;
#10;		din=32'h0101_8888;

#10;		address=8'h20; wr=0;
#50;		address=8'h20; din=32'h1111_1111;	//select last fifo of fifo_top
#10;		wr=1;	 //write signal
#10;		address=8'h21;
#10;		din=32'h2222_2222;	
#10;		din=32'h3333_3333;
#10;		wr=0; address=8'h20;
#10;		wr=0;	address=8'h21;
#350;		$stop;	//read signal
		end
endmodule

