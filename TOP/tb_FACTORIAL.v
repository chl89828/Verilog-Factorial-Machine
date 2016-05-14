`timescale 1ns/100ps
module tb_FACTORIAL;				//testbench of FACTORIAL
	reg clk, reset_n, S_sel, S_wr;		//input of FACTORIAL
	reg[7:0] S_address;
	reg [31:0] S_din;
	reg M_grant;
	reg [31:0]M_din;
	
	wire[31:0] S_dout;						//output of FACTORIAL
	wire M_req, M_wr;
	wire [7:0] M_address;
	wire [31:0] M_dout;
	wire interrupt;	

//instance of FACTORIAL	
FACTORIAL tb_FACTORIAL(clk, reset_n, S_sel, S_wr, S_address, S_din, M_grant, M_din, S_dout, M_req, M_wr, M_address, M_dout, interrupt);

always		//generate clock purse
begin
	clk=0; #5; clk=1; #5;
end

initial
begin
		reset_n=0;																									
		//IDLE state
#10;	reset_n=1;	S_sel=1; S_wr=1;	S_address=8'h01;	S_din=32'h1;	M_grant=0;	M_din=0;	//write 1 in Interrupt_Enable register 
		//IDLE --> INTERRUPT_ENABLE state

#10;	S_address=8'h03;																							//write 1 in OperationStart register
		//INTERRUPT_ENABLE --> OPERATIONSTART state
#20;	M_grant=1;	S_sel=0;	S_wr=0;	S_address=0;	S_din=0;		//grant = 1 		
		//BUS_REQUEST -->BUS_GRANT state
#20;	M_din=6'b100000;														//FIFOTOP flag 100000 means FULL.  
		//BUS_GRANT --> CHECKFLAG state
#20;	M_din=10;																//M_din is N_value
		//CHECKFLAG --> REQUEST_N_VALUE --> N_VALUE_READ state
#10;	M_grant=0;																//loose M_grant
		//N_VALUE_READ --> CHECK_N_VALUE
		while(M_req==0)
			#10;
		//CHECK_N_VALUE --> MULTIPLE_EXECUTE-->SUB_MULTIPLE_VALUE -->MULTIPLE_EXECUTE --> SUB_MULTIPLE_VALUE repeat.
		//SUB_MULTIPLE_VALUE-->WRITE_RESULT_REGISTER-->BUS_REQUEST2
		M_grant=1;	M_din=6'b010000;										//FIFOTOP_OUT flag 010000 means empty
		//BUS_REQUEST2 -->BUS_GRANT2 -->CHECK_FLAG2
#100;	M_grant=0;
		//CHECK_FLAG2 -->WRITE_RESULT2 -->WRITE_RESULT1 -->WRITE_RESULT0 --> BUS_GRANT -->CHECK_FLAG -->NOT_BUS_GRANT2
		//NOT_BUS_GRANT2 -->INTERRUPT_WAIT
#50;	S_sel=1'b1; S_wr=1'b1; S_address=8'h02; S_din=32'h0;
		//INTERRUPT_WAIT --> INITIALIZATION
#10;	//INITIALIZATION -->IDLE
	$stop;
end
endmodule


