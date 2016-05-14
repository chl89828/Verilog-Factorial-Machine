`timescale 1ns/100ps
module tb_TOP;					//testbench of TOP  	// this means processor
	reg clk, reset_n, tb_M0_req, tb_M0_wr;			//input ports of TOP // user can manipulate master0's signals
	reg [7:0] tb_M0_address;
	reg [31:0] tb_M0_dout;
	
	wire tb_M0_grant, tb_interrupt;					//output ports of TOP
	wire [31:0] tb_M_din;
	wire [3:0] tb_fifo_cnt_in; 
	wire [5:0] tb_fifo_cnt_out, tb_fifo_flag_in, tb_fifo_flag_out;
	
	parameter STEP = 10;

	//instance of TOP
	TOP test_TOP(.clk(clk), .reset_n(reset_n), .M0_req(tb_M0_req), .M0_wr(tb_M0_wr), .M0_address(tb_M0_address), .M0_dout(tb_M0_dout),
			.M0_grant(tb_M0_grant), .interrupt(tb_interrupt), .M_din(tb_M_din), .fifo_cnt_in(tb_fifo_cnt_in), .fifo_cnt_out(tb_fifo_cnt_out),
			.fifo_flag_in(tb_fifo_flag_in), .fifo_flag_out(tb_fifo_flag_out));
	
	always		//generate clock purse
		begin
			clk=0; #5; clk=1; #5;
		end
	
	initial
	begin
			reset_n=1'b0; tb_M0_req=1'b1; tb_M0_wr=1'b0; tb_M0_address=8'hff; tb_M0_dout=32'h0;	//initialization 
#7;		reset_n=1'b1;		


//CASE 1 - 8 data to include 0, 1, 2																						
#STEP;	tb_M0_wr=1'b1; tb_M0_address=8'h11; tb_M0_dout=32'h0;			//write data in FIFOTOP_IN 0 	
#STEP;	tb_M0_dout=32'h1; 														//1
#STEP;	tb_M0_dout=32'h2; 														//2
#STEP;	tb_M0_dout=32'h3; 														//3
#STEP;	tb_M0_dout=32'h4; 														//4
#STEP;	tb_M0_dout=32'h5; 														//5
#STEP;	tb_M0_dout=32'h6; 														//6
#STEP;	tb_M0_dout=32'h7; 														//7
		
#STEP;	tb_M0_address=8'h01; tb_M0_dout=32'h1;		//Interrupt_Enable --> 1		
#STEP;	tb_M0_address=8'h03; 							//Operation_Start -->1
#STEP;	tb_M0_req=1'b0; tb_M0_address=8'hff; tb_M0_dout=32'h0; 		//loose grant 
		
		while(tb_interrupt!=1'b1)						//until tb_interrupt is 1 
			#STEP;

		
		tb_M0_req=1'b1; #STEP;							//testbench requests grant
		
		while(tb_M0_grant==1'b0)						//until testbench has tb_M0_grant 
			#STEP;

		
		tb_M0_wr=1'b1; tb_M0_address=8'h02; tb_M0_dout=32'h0; //factorial's interrupt_clear		
#STEP;tb_M0_wr=1'b0; tb_M0_address=8'h21;							//request data to FIFOTOP_OUT's FIFO 
#STEP;
		
		while(tb_fifo_cnt_out!=6'b0)									//dequeue until tb_fifo_cnt_out!=6'b0
			#STEP;

//CASE2 test big number 20 , 19 , 18 , 17...
#STEP; tb_M0_wr=1'b1; tb_M0_address=8'h11; tb_M0_dout=32'h14;	//20
#STEP; tb_M0_dout=32'h13;										  		   //19
#STEP; tb_M0_dout=32'h12;													//18
#STEP; tb_M0_dout=32'h11;													//17
#STEP; tb_M0_dout=32'h10;													//16
#STEP; tb_M0_dout=32'hF;													//15
#STEP; tb_M0_dout=32'hE;													//14
#STEP; tb_M0_dout=32'hD;													//13
#STEP; tb_M0_address=8'h01; tb_M0_dout=32'h1;						//Interrupt_Enable of FACTORIAL 
#STEP; tb_M0_address=8'h03; 												//OperationStart of FACTORIAL
#STEP; tb_M0_req=1'b0; tb_M0_address=8'hff; tb_M0_dout=32'h0;	//loose master grant 
#STEP; 
		while(!tb_interrupt)								//until tb_interrupt is 1 
			#STEP;
		
		 tb_M0_req=1'b1;		 
		
		while(tb_M0_grant==1'b0)						//until testbench has tb_M0_grant
			#STEP;		
			
		tb_M0_wr=1; tb_M0_address=8'h02; tb_M0_dout=32'h0;
#STEP;tb_M0_wr=0;	tb_M0_address=8'h21; tb_M0_dout=32'h0;
#STEP;
		while(tb_fifo_cnt_out!=6'b0)					//dequeue from FIFOTOP_OUT until tb_fifo_cnt_out!=6'b0
			#STEP;

		
		
//CASE3 --> no data enqueue in FIFOTOP_IN	
#STEP;	tb_M0_wr=1'b1; tb_M0_address=8'h01; tb_M0_dout=32'h1;	//Interrupt_Enable of FACTORIAL 
#STEP;	tb_M0_address=8'h03;												//OperationStart of FACTORIAL
#STEP;	tb_M0_req=1'b0; tb_M0_address=8'hff; tb_M0_dout=32'h0;//loose master  grant
#STEP; 
		while(!tb_interrupt)								//until tb_interrupt is 1 
			#STEP;
	
		tb_M0_req=1'b1;		 
		
		
		while(tb_M0_grant==1'b0)						//until testbench has tb_M0_grant
			#STEP;		
			
		tb_M0_wr=1'b1; tb_M0_address=8'h02; tb_M0_dout=32'h0;	//to send 1 in Interrupt of factorial 
#STEP;tb_M0_wr=1'b0;	tb_M0_address=8'h21; tb_M0_dout=32'h0;	
#STEP;
		while(tb_fifo_cnt_out!=6'b0)					//dequeue from FIFOTOP_OUT until tb_fifo_cnt_out!=6'b0
			#STEP;
/////case 4 - to enqueue 4 data in FIFOTOP_IN
#STEP;	tb_M0_wr=1'b1; tb_M0_address=8'h11; tb_M0_dout=32'h4;
#STEP;	tb_M0_dout=32'h8;
#STEP;	tb_M0_dout=32'h6;
#STEP;	tb_M0_dout=32'h2;
#STEP;	tb_M0_address=8'h01; tb_M0_dout=32'h1;						//Interrupt_Enable of FACTORIAL 
#STEP;	tb_M0_address=8'h03;												//OperationStart of FACTORIAL
#STEP;	tb_M0_req=1'b0; tb_M0_address=8'hff; tb_M0_dout=32'h0;//loose master  grant	
#STEP;	
			while(!tb_interrupt)
				#STEP;
			
			tb_M0_req=1'b1;
	
#STEP;	tb_M0_wr=1'b1; tb_M0_address=8'h02; tb_M0_dout=32'h1;	//to send 1 in Interrupt of factorial 
#STEP;	tb_M0_wr=1'b0;	tb_M0_address=8'h21; tb_M0_dout=32'h0;	//read data from FIFO of FIFOTOP_OUT 
#STEP;	
			
			while(tb_fifo_cnt_out!=6'b0)					//dequeue from FIFOTOP_OUT until tb_fifo_cnt_out!=6'b0
				#STEP;
	
$stop;	
	end		
endmodule

	