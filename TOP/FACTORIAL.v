module FACTORIAL(clk, reset_n, S_sel, S_wr, S_address, S_din, M_grant, M_din, S_dout, M_req, M_wr, M_address, M_dout, interrupt);
//module of FACTORIAL
	
	input 			clk, reset_n, S_sel, S_wr;		//input ports - clk : clock, reset_n : ~reset, S_sel,S_wr : slave select,wr

	input [7:0]		S_address;		//input ports when Factorial is slave, slave address
	input [31:0] 	S_din;			//input ports when Factorial is slave, slave input data
	
	input 			M_grant;			//input port when Factorial is master, M_grant=1.
	input [31:0]	M_din;
	
	output reg[31:0]	S_dout;			//output port when Factorial is slave, slave output data
	output reg			M_req; 			//output port M_req - to request master grant
	
	output reg			M_wr;				//output ports - when Factorial is master, master wr, address, m_dout
	output reg[7:0] 	M_address;
	output reg[31:0] 	M_dout;
	
	output			interrupt;		//output port interrup signal - when factorial's calculation is over, interrupt = 1
	
	//essential registers of FACTORIAL, each registers have address.
	//N_value - 0x0 , Interrupt_Enable - 0x1, Interrupt - 0x2, OperationStart - 0x3
	//Result0 - 0x4 , Result1 - 0x5 , Result2 - 0x6 , Result3 - 0x7
	reg [31:0] N_value, Interrupt_Enable, Interrupt , OperationStart, Result0, Result1, Result2, Result3;
	reg [31:0] next_N_value, next_Interrupt_Enable, next_Interrupt, next_OperationStart, next_Result0, next_Result1, 
				  next_Result2, next_Result3;
 
	reg [5:0] state, next_state;	//state register
	
	wire op_done;						//wire port - output of multiplier
	reg  op_start, op_clear;		//register - input of multiplier
	
	reg[63:0]	multiplier;			//register - input of multiplier
	reg[63:0]	multiplicand;		//register - input of multiplier
	
	wire[127:0]	mul_result;			//wire port - output of multiplier
	reg [127:0]	result, next_result;//register - result to store result factorial temporarily 
	
	//parametrize state
	parameter IDLE=5'b00000;					//IDLE STATE 
	parameter INTERRUPT_ENABLE=5'b00001;	//when interrupt_enable is given from tb 
	parameter BUS_REQUEST=5'b00010;			//when Op_start is given from tb
	parameter BUS_GRANT=5'b00011;				//when Factorial is given master grant
	parameter BUSY=5'b00100;					//though Factorial request master grant, still factorial is not master grant 
	parameter CHECK_FLAG=5'b00101;			//check FIFO_IN flag
	parameter REQUEST_N_VALUE=5'b10101;		//request data to FIFO_IN
	parameter N_VALUE_READ=5'b00110;			//Factorial stores data(N_value) from fifo_in
	parameter CHECK_N_VALUE=5'b00111;		//check N_value
	parameter MULTIPLE_EXECUTE=5'b01000;	//send datas to multiplier
	parameter SUB_MULTIPLE_VALUE=5'b01001;	//ready following value to multiply
	parameter WRITE_RESULT_REGISTER=5'b01010;//Write result of factorial to register of factorail
	parameter BUS_REQUEST2=5'b01011;			//Factorial request master grant
	parameter BUSY2=5'b01100;					//though Factorial request master grant, still factorial is not master grant 
	parameter BUS_GRANT2=5'b01101;			//when Factorial is given master grant
	parameter CHECK_FLAG2=5'b01110;			//check FIFO_OUT flag
	parameter WRITE_RESULT2=5'b01111;		//WRITE result of factorial calculation in FIFO_OUT	
	parameter WRITE_RESULT1=5'b10000;		//WRITE result of factorial calculation in FIFO_OUT	
	parameter WRITE_RESULT0=5'b10001;		//WRITE result of factorial calculation in FIFO_OUT	
	
	parameter NOT_BUS_GRANT2=5'b10010;		//loose master grant
	parameter INTERRUPT_WAIT=5'b10011;		//to wait interrupt will be 0
	parameter INITIALIZATION=5'b10100;		//initialize register value 


//instance of MULTIPLIER	
MULTIPLIER U0_MULTIPLIER(.clk(clk), .reset_n(reset_n), .multiplier(multiplier), .multiplicand(multiplicand)
								, .op_start(op_start), .op_clear(op_clear), .op_done(op_done), .result(mul_result));
								
	always@(posedge clk or negedge reset_n)		//register
		if(reset_n==0)	begin 
									state <= IDLE;			//initialize every register 
									N_value<=32'b0;
									Interrupt_Enable<=32'b0;
									Interrupt<=32'b0;
									OperationStart<=32'b0;
									Result0<=32'b0;
									Result1<=32'b0;
									Result2<=32'b0;
									Result3<=32'b0;
									result<=128'b0;
							end
		
		else 				begin 						//when clock is rising edge , values has next_values.
									state <=next_state;
									N_value<=next_N_value;
									Interrupt_Enable<=next_Interrupt_Enable;
									Interrupt<=next_Interrupt;
									OperationStart<=next_OperationStart;
									Result0<=next_Result0;
									Result1<=next_Result1;
									Result2<=next_Result2;
									Result3<=next_Result3;
									result<=next_result;						
							end

//////next state logic							
	always@(state, Interrupt_Enable, OperationStart, M_grant, M_din, Interrupt, N_value, op_done,multiplier)
		case(state)
		IDLE 					:	if(Interrupt_Enable==32'h1)	next_state=INTERRUPT_ENABLE;	//Interrupt_Enalbe == 1, Move to next stage
									else									next_state=IDLE;
		
		INTERRUPT_ENABLE	:	if(OperationStart==32'h1)	next_state=BUS_REQUEST;		//OperationStart == 1, Move to next stage
									else								next_state=INTERRUPT_ENABLE;
		
		BUS_REQUEST			:	if(M_grant==1)					next_state=BUS_GRANT;		//M_grant == 1 , Move to next stage
									else 								next_state=BUSY;				
		
		BUSY					:	if(M_grant==1)					next_state=BUS_GRANT;		//M_grant == 1, Move to next stage
									else								next_state=BUSY;
		
		BUS_GRANT			:	next_state=CHECK_FLAG;											//diretly Move to next stage
		
		CHECK_FLAG			:	if(M_din[4]==1) 				next_state=NOT_BUS_GRANT2;	//M_din[4] -- FIFO_IN flag(empty)
									else								next_state=REQUEST_N_VALUE;//M_din[4] == 0 --> Move to execute stage
																											//M_din[4] == 1 --> Move to Interrupt stage
		REQUEST_N_VALUE	:  next_state=N_VALUE_READ;				//directly Move to next stage
		
		N_VALUE_READ		:	next_state=CHECK_N_VALUE;				//directly Move to next stage
									
		
		CHECK_N_VALUE		:	if(N_value==32'h2 || N_value==32'h1 || N_value==32'h0)//N_value is value to execute factorial 	
										next_state=WRITE_RESULT_REGISTER;	
									//if N_value is 2 or 1 or 0 --> execute doesn't need thus move to stage to write
									
									else	
										next_state=MULTIPLE_EXECUTE;
									//else(N_value is not 2,1,0) --> move to stage to execute factorial
									
		MULTIPLE_EXECUTE	:	//this state is multiple execution stage
									if(op_done!=1)					next_state=MULTIPLE_EXECUTE;	
									//if op_done == 0 , still program is executing multiple. thus stay this state.
									else								next_state=SUB_MULTIPLE_VALUE;
									//else (op_done==1), execution is exit. thus move to next stage
		
		SUB_MULTIPLE_VALUE:	if(N_value==64'h2)	//this state is to ready following value to multiply
										next_state=WRITE_RESULT_REGISTER;	
									//if N_value is 2, factorial execution is to exit. thus move to stage to write value
									else												
										next_state=MULTIPLE_EXECUTE;
									//else(N_value is not 2), factorial execution is continually executed.
									
		WRITE_RESULT_REGISTER:next_state=BUS_REQUEST2;	//this state is to write value of factorial execution.
																		//thus directly move to next stage
																		
		BUS_REQUEST2		:	if(M_grant==1)					next_state=BUS_GRANT2;	//this state is to request master grant
									else								next_state=BUSY2;			//M_grant is 1 --> move to next stage
		
		BUSY2					:	if(M_grant==1)					next_state=BUS_GRANT2;	//M_grant is 1 --> move to next stage
									else								next_state=BUSY2;
		
		BUS_GRANT2			:	next_state=CHECK_FLAG2;										//this state is to given for factorial
																										//directly move to next stage
		CHECK_FLAG2			: 	if(M_din[5]!=1)					//M_din -- FIFOTOP_OUT flag(full)
										next_state=WRITE_RESULT2;	//if FIFOTOP_OUT is not FULL,
									else									//--> Move to stage to write result in FIFOTOP_OUT
										next_state=NOT_BUS_GRANT2;	//if FIFOTOP_OUT is FULL, -->Move to Interrupt stage
		
		WRITE_RESULT2		:	next_state=WRITE_RESULT1;		//this states are to write result in FIFOTOP_OUT
		WRITE_RESULT1		:	next_state=WRITE_RESULT0;		//directly move to next stage
		WRITE_RESULT0		:	next_state=BUS_GRANT;

	
		NOT_BUS_GRANT2		:	next_state=INTERRUPT_WAIT;		//this state is to release grant
																			//directly move to next stage
		INTERRUPT_WAIT		:	if(Interrupt==0)	next_state=INITIALIZATION;	//Interrupt == 0 --> move to INITIALIZATION
									else					next_state=INTERRUPT_WAIT;	//else stay.		
		
		INITIALIZATION		:	next_state=IDLE;					//INITIALIZATION stage . register is initilized
				
		default				: next_state=5'bx;					//default
		endcase
		
//next_Interrupt_Enable logic
	always@(S_sel, S_wr, S_address, S_din, state, Interrupt_Enable)	
		if(state==IDLE)		//when state is IDLE if address 0x1 is selected, Interrupt_Enable register is S_din.
			if(S_sel==1'b1 && S_wr==1'b1 && S_address==8'h01)
				next_Interrupt_Enable=S_din;
			else					//else stay.
				next_Interrupt_Enable=Interrupt_Enable;	
		else if(state==INITIALIZATION)	//when state is INITIALIZATION, that register is initilized.
				next_Interrupt_Enable=32'b0;
		else										//default. maintain original value.
			next_Interrupt_Enable=Interrupt_Enable;

//next_OperationStart logic	
	always@(S_sel, S_wr, S_address, S_din)
		if(S_sel==1'b1 && S_wr==1'b1 && S_address==8'h03)	
			next_OperationStart=S_din;		//only when S_address - 0x3 is selected, next_OPerationStart is S_din
		else
			next_OperationStart=32'b0;		//default - 0

//next logic of Interrupt			
	always@(S_sel, S_wr, S_address, S_din, state, Interrupt)		
		if(state==NOT_BUS_GRANT2)			//after factorial execution is done, state is NOT_BUS_GRANT2  
			next_Interrupt=32'h1;			//thus in this state, next_Interrupt is set 1
		else if(state==INTERRUPT_WAIT)	//"INTERRUPT_WATI" is state to wait that Interrupt is 0 
			if(S_sel==1'b1 && S_wr==1'b1 && S_address==8'h02)	//if S_Address==0x2, next_Interrupt is S_din
				next_Interrupt=S_din;
			else																//else , next_Interrupt is original value.
				next_Interrupt=Interrupt;
		else										//default
			next_Interrupt=Interrupt;		//next_Interrupt has original value.


//next_N_value logic	
	always@(state, M_din, N_value)		
		case(state)
			N_VALUE_READ			:	next_N_value=M_din;		//when state is N_VALUE_READ, M_din is dequeue value of FIFOTOP_OUT 
																			//thus 
			CHECK_N_VALUE			:	next_N_value=N_value;	//maintain previous value.
			MULTIPLE_EXECUTE		:	next_N_value=N_value;	//maintain previous value.
			SUB_MULTIPLE_VALUE	:	next_N_value=N_value-1;	//next_N_value = N_value - 1 to ready next multiple execution
			WRITE_RESULT_REGISTER:	next_N_value=N_value;	//maintain previous value.
			default					:	next_N_value=32'b0;
		
		endcase
	
//next_Result3,2,1,0 logic	
	always@(state, result, Result3, Result2, Result1, Result0)
		if(state==WRITE_RESULT_REGISTER)
			begin next_Result3=result[127:96]; next_Result2=result[95:64]; next_Result1=result[63:32]; next_Result0=result[31:0]; end
		//execution value of factorial is stored in result[127:0]. 
		//thus when state is WRITE_RESULT_REGISTER, 128-bit of result is stored to next_Result3~0
		
		else if(state==INITIALIZATION)
			begin next_Result3=32'b0;	next_Result2=32'b0;	next_Result1=32'b0;	next_Result0=32'b0;	end
		//when state is INITIALIZATION, that registers are initilized.
		
		else
			begin next_Result3=Result3;	next_Result2=Result2;	next_Result1=Result1;	next_Result0=Result0;	end
		//default : next_Result 3~0 has original value.
		
//next_result logic			
	always@(result, mul_result, state, N_value)
		if(state==CHECK_N_VALUE)	//result is value of factorial execution
			if(N_value==2)				//if N_value==2 2x1 = 1 thus next_result=2
				next_result=128'h2;
			else if(N_value==1 || N_value==0)	//if N_value == 1 or 0 --> next_result =1
				next_result=128'h1;
			else							//except for that next_result = N_value
				next_result={96'b0, N_value};
				
		else if(state==MULTIPLE_EXECUTE)	//when state is MULTIPLE_EXECUTE, next_result has original value.
			next_result=result;
		else if(state==SUB_MULTIPLE_VALUE)//when state is SUB_MULTIPLE_VALUE, next_result has value of execution value of multiplier.
			next_result=mul_result;
		else if(state==WRITE_RESULT_REGISTER)//when state is RESULT_REGISTER, next_result has orignal value.
			next_result=result;
		else
			next_result=128'h0;

//multiplicand logic	
	always@(state, result)													//when state is MULTIPLE_EXECUTE, multiplicand has result. 
		if(state==MULTIPLE_EXECUTE)	multiplicand=result[63:0];	//result has previous execution value of multiplier
		else									multiplicand=64'b0;			//default.

//multiplier logic		
	always@(state, N_value)													//when state is MULTIPLE_EXECUTE, multiplier has N_value -1
		if(state==MULTIPLE_EXECUTE)	multiplier = {32'b0, N_value-1};
		else									multiplier=64'b0;				//default
		
//op_start, op_clear logic				
	always@(state)
		if(state==MULTIPLE_EXECUTE)					//when MULTIPLE_EXECUTE, op_start=1 and op_clear =0 
			begin op_start=1'b1; op_clear=1'b0;end//because multiplier's execution have to start.
		else if(state==SUB_MULTIPLE_VALUE)			//when SUB_MULTIPLE_VALUE, op_start=0 and op_clear=1 
			begin op_start=1'b0;	op_clear=1'b1;end	//because multiplier's state has to be INIT.
		else 													//default. op_start =0 op_clear =0
			begin op_start=1'b0; op_clear=1'b0;end
	
//output logic of M_req, M_address, M_wr	
	always@(state, M_req, M_address, M_wr)			
		case(state)
			BUS_REQUEST		: begin	M_req=1'b1; M_address=8'hff; M_wr=0; end//these states is to request master grant
			BUS_REQUEST2	: begin	M_req=1'b1; M_address=8'hff; M_wr=0; end//thus only M_req is 1
			BUSY				: begin	M_req=1'b1; M_address=8'hff; M_wr=0; end
			BUSY2				: begin	M_req=1'b1; M_address=8'hff; M_wr=0; end
		
			BUS_GRANT		: begin	M_req=1'b1; M_address=8'h10; M_wr=0; end//to request to read FIFOIN_TOP's flag
			CHECK_FLAG		: begin	M_req=1'b1; M_address=8'hff; M_wr=0; end//no function			
			REQUEST_N_VALUE: begin  M_req=1'b1; M_address=8'h11; M_wr=0; end//to request to read FIFOIN_TOP's dequeue value
			
			BUS_GRANT2		: begin	M_req=1'b1; M_address=8'h20; M_wr=0; end//to request to read FIFOOUT_TOP's flag
			CHECK_FLAG2		: begin	M_req=1'b1; M_address=8'h21; M_wr=1; end//to request to write M_dout to FIFOOUT_TOP 
			
			WRITE_RESULT2	: begin	M_req=1'b1; M_address=8'h21; M_wr=1; end//to request to write M_dout to FIFOOUT_TOP 
			WRITE_RESULT1	: begin	M_req=1'b1; M_address=8'h21; M_wr=1; end//to request to write M_dout to FIFOOUT_TOP 
			WRITE_RESULT0	: begin	M_req=1'b1; M_address=8'h21; M_wr=1; end//to request to write M_dout to FIFOOUT_TOP 

			default			: begin	M_req=1'b0; M_address=8'hff; M_wr=0; end//default 
		endcase

//output logic of M_dout	
	always@(state, Result0, Result1, Result2, Result3)		
		case(state)
			CHECK_FLAG2		:	M_dout=Result3;	//to write Result3 to FIFOOUT_TOP 
			WRITE_RESULT2	:	M_dout=Result2;	//to write Result2 to FIFOOUT_TOP 
			WRITE_RESULT1	:	M_dout=Result1;	//to write Result1 to FIFOOUT_TOP 
			WRITE_RESULT0	:	M_dout=Result0;	//to write Result0 to FIFOOUT_TOP 
			default			:	M_dout=32'b0;
		endcase
	
//output logic of S_dout 
	always@(S_wr, S_address, S_sel, N_value,Interrupt_Enable, Result0, Result1, Result2, Result3, Interrupt )
		if(S_sel==1'b1 && S_wr==1'b0)//only when FACTORIAL is slave and master requests to read, this logic is executed.
			if(S_address==8'h00)			//S_address - 0x0
				S_dout=N_value;			//S_dout --> N_value
			else if(S_address==8'h01)	//S_address - 0x1
				S_dout=Interrupt_Enable;//S_dout --> Interrupt_Enable
			else if(S_address==8'h02)	//S_address - 0x2
				S_dout=Interrupt;			//S_dout -->Interrupt
			else if(S_address==8'h04)	//S_address - 0x4
				S_dout=Result0;			//S_dout -->Result0
			else if(S_address==8'h05)	//S_address - 0x5
				S_dout=Result1;			//S_dout -->Result1
			else if(S_address==8'h06)	//S_address - 0x6
				S_dout=Result2;			//S_dout --> Result2
			else if(S_address==8'h07)	//S_address - 0x7
				S_dout=Result3;			//S_dout -->Result3
			else								//except uppter those, S_dout is 0 
				S_dout=32'h0;
		else									//default
			S_dout=32'h0;
	

	assign interrupt=Interrupt[0]&Interrupt_Enable[0];	//output interrupt of factorial is Interrupt[0] & Interrupt_Enable[0]
	
endmodule

	