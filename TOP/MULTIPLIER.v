module MULTIPLIER(clk, reset_n, multiplier, multiplicand, op_start, op_clear, op_done, result);
//module of multiplier - it can operate multiply execution
	
	input clk, reset_n, op_start, op_clear;	//input ports - (clk - clock , reset_n - reset, 
															//					op_strat - execute start, op_clear - multiplier module initialization) 
	input [63:0] multiplier, multiplicand;		//input ports - 2 64-bit input data. 
	output reg op_done;								//output port - op_done - execute over signal.
	output [127:0] result;							//output port - 128-bit result data
			
	reg[1:0] state;							//multiplier module's state
	reg[1:0] next_state;						//next state 

	reg signed[127:0] result;				//multiplier module's result
	reg [127:0] next_result;				//next result
	wire w_ci;									//64'bit cla's carry in
	
	reg[5:0] count;							//execution counting number
	reg[5:0] next_count;						//next_count
	wire[5:0] w_count;						//wire port - result of count+1
	
	reg [64:0]r_multiplier;					//shifted multiplier inputted value as cycle 
	reg [64:0]next_r_multiplier;			//next r_multiplier

	reg [5:0] shift_scale;					//result's scale to shift 
	reg [5:0] next_shift_scale;			//next shift_scale
	
	wire [63:0]w_multiplicand;				//wire port - multiplicand or ~multiplicand 
	wire[5:0] w_shift_scale;				//calculated shift_scale

	parameter IDLE=2'b00;					//parameterize state
	parameter EXECUTE=2'b01;
	parameter DONE=2'b10;
	
	assign w_multiplicand = (r_multiplier[2]==1'b1 && (r_multiplier[1]==1'b0 || r_multiplier[0]==1'b0))? ~multiplicand : multiplicand;
	//x(i) x(i-1) x(i-2) : 1 0 0 --> -2A  in case left three -> w_multiplicand = ~multiplicand
	//x(i) x(i-1) x(i-2) : 1 0 1 --> -A
	//x(i) x(i-1) x(i-2) : 1 1 0 --> -A
													//in case except left three -> w_multiplicand = multiplicand

	assign w_ci= r_multiplier[2]==1'b1 && (r_multiplier[1]==1'b0 || r_multiplier[0]==1'b0);
	//x(i) x(i-1) x(i-2) : 1 0 0 --> -2A  in case left three -> w_co = 1
	//x(i) x(i-1) x(i-2) : 1 0 1 --> -A
	//x(i) x(i-1) x(i-2) : 1 1 0 --> -A
													//in case except left three -> w_co = 0	
	
	wire [127:0] w_result;					//wire port - cla result 
	
	assign w_result[63:0]=result[63:0];	//execution is done with upper 64bit. Thus previous result[63:0] is stored w_result	

	cla64 U0_cla64(.a(w_multiplicand[63:0]), .b(result[127:64]), .ci(w_ci), .s(w_result[127:64]), .co());
	//cla64 instance : upper 64-bit of w_result = w_multiplicand + upper 64-bit of result

	cla6 U1_cla6(.a(count[5:0]),.b(shift_scale),.ci(1'b0), .s(w_count[5:0]),.co());
	//cla6 instance : w_count = count + shift_scale
	
	cla6 U2_cla6(.a(6'b01_1111), .b(~count), .ci(1'b1), .s(w_shift_scale), .co());
	// cla6 instance2 : When execution will exit before all-bit of multiplier is read, shift_scale is decided.
	// Maximum count scale - count : shift_scale.
	
	always@(posedge clk or negedge reset_n)				//register 
		if(reset_n==0) begin state<=IDLE;  result<=128'b0; count<=6'b0; r_multiplier<=64'b0; shift_scale<=6'b0; end	
		//when reset is active low, state, result, count, r_multiplier and shift_scale are initilized.
		else				begin state<=next_state; result<=next_result; count<=next_count; r_multiplier<=next_r_multiplier; shift_scale<=next_shift_scale; end
 		//when clock is postive edge, state, result, count, r_multiplier and shift_scale are stored next values.

////next state logic		
	always@(op_start, op_clear, op_done, state)					
		case(state)																//case statement as state
		
		//in case state == IDLE
		IDLE	:	 	if(op_start==1'b1) next_state=EXECUTE; 		//if(op_start ==1)	IDLE --> EXECUTE
						else next_state=IDLE;								//else					IDLE --> IDLE
		
		//in case state == EXECUTE
		EXECUTE	:	begin if(op_clear==1'b1) next_state=IDLE;		//if(op_clear == 1)		 EXECUTE --> IDLE
								else if(op_done==1'b1) next_state=DONE;//else if(op_done == 1)  EXECUTE --> DONE
								else	next_state=EXECUTE; end				//else						 EXECUTE --> EXECUTE
		
		//in case state == DONE
		DONE	:	begin if(op_clear==1'b1)	next_state=IDLE;  	//if(op_clear==1) 	DONE --> IDLE
							else		next_state=DONE;	end				//else 					DONE -->	DONE
		default : next_state=2'bx;											//set default
		endcase								

////next result logic
	always@(r_multiplier, state, count, result, next_result, w_result, multiplier, shift_scale, multiplicand, op_clear)	
		case(state)
		IDLE		:	begin next_result=128'b0;  end			//when state is IDLE, next_result is 0
		
		EXECUTE	:	if(count>=6'b100000)							//end of EXECUTE state, next_result doesn't need to be operated	
							next_result=result;						
						else if(shift_scale!=1)						//That shift_scale is not '1' means that multiplier's all bit is 0.
							next_result=result>>>(shift_scale<<1);
						else												//in EXECUTE real operate
							//As r_multiplier least 5-bit, next_result is decided.
							
							//if least [2][1][0] is 3'b011 or 3'b100  :  +2A or -2A
							if({r_multiplier[2], r_multiplier[1], r_multiplier[0]}==3'b011 || {r_multiplier[2], r_multiplier[1], r_multiplier[0]}==3'b100)	 
							
								//if [4][3][2] is 3'b 011 or 3'b100 : +2A or -2A .. --> next_result is arithmetic right shift 2-bit of w_result
								if({r_multiplier[4], r_multiplier[3], r_multiplier[2]}==3'b011 || {r_multiplier[4], r_multiplier[3], r_multiplier[2]}== 3'b100)
									next_result={w_result[127], w_result[127], w_result[127:2]};
								
								//else ([4][3][2] is not 3'b 011 and 3'b100) : 0 or +A or -A  --> next result is arithmetic right shift 1-bit of w_result
								else
									next_result={w_result[127], w_result[127:1]};
							
							//if least [2][1][0] is 3'b000 or 3'b111 : 0
							else if({r_multiplier[2], r_multiplier[1], r_multiplier[0]}==3'b111 || {r_multiplier[2], r_multiplier[1], r_multiplier[0]}==3'b000)
								
								//if [4][3][2] is 3'b011 or 3'b100 : +2A or -2A  --> next_result is arithmetic right shift 3-bit of result(original result)
								if({r_multiplier[4], r_multiplier[3], r_multiplier[2]}== 3'b011 ||{r_multiplier[4], r_multiplier[3], r_multiplier[2]}== 3'b100)
									next_result={result[127], result[127], result[127], result[127:3]};
								//else ([4][3][2] is not 3'b011 or 3'b100) : 0 or +A or -A --> next_result is arithmetic right shift 2-bit of result(original result)
								else
									next_result={result[127], result[127], result[127:2]};
									
							//else (least [2][1][0] is 3'b001 or 3'b010 or 3'b101 or 3'b110) : +A or -A
							else 
								
								//if [4][3][2] is 3'b 011 or 3'b100 : +2A or -2A .. --> next_result is arithmetic right shift 3-bit of w_result
								if({r_multiplier[4], r_multiplier[3], r_multiplier[2]}== 3'b011 ||{r_multiplier[4], r_multiplier[3], r_multiplier[2]}== 3'b100)
									next_result={w_result[127], w_result[127], w_result[127], w_result[127:3]};
								//else ([4][3][2] is not 3'b 011 and 3'b100) : 0 or +A or -A  --> next result is arithmetic right shift 2-bit of w_result
								else
									next_result={w_result[127], w_result[127], w_result[127:2]};
		
		DONE		:	begin next_result=result;	end		//when state is DONE , next_result is not changed.
		default	:	begin next_result=128'bx;  end		//set default value
		endcase
	
////next_count logic
	always@(state, count,w_count, next_count, op_clear)			
		case(state)											
		IDLE		:	next_count=6'b0;										//when IDLE, next_count=0
		
		EXECUTE	:	next_count=w_count;									//when EXECUTE, next_count = w_count(calculated count by cla)
		
		DONE		:	if(op_clear==1)	next_count=6'b0;				//when DONE, if op_clear is '1' next_count=0
						else 					next_count=count;				//				 else next_count maintains original value	
					
		default : next_count=6'bx;											//default value
		endcase						

////next_r_multiplier logic	
	always@(state, r_multiplier, count, multiplier)			
		case(state)																
		IDLE		: next_r_multiplier={multiplier[63:0], 1'b0};			//when IDLE, next_r_multiplier is input multiplier + LSB->0
		EXECUTE	: next_r_multiplier={2'b00,r_multiplier[64:2]};			//when EXECUTE, next_r_multiplier is 
																															//LSR 2-bit of r_multiplier 
		DONE		: next_r_multiplier=r_multiplier;							//when DONE, next_r_multiplier is r_multiplier
		default 	: next_r_multiplier=65'bx;										//set default case
		endcase

////next_shift_scale logic		
	always@(state, count, r_multiplier, w_shift_scale,multiplicand)	
		case(state)
			IDLE		:	next_shift_scale=6'b1;		//When IDLE : that shift scale is 1 is normal
			
			EXECUTE	:	if(r_multiplier==65'h0)		//when EXECUTE : that r_multiplier's all bit is 0 means to do only shift
								next_shift_scale=w_shift_scale;
							else								//that shift scale is 1 is normal
								next_shift_scale=6'b1;
			
			DONE		:	next_shift_scale=6'b0;		//because count doesn't have to count.
			default	:	next_shift_scale=6'bx;
		endcase
		
	always@(op_clear, count)			
	 if(op_clear==1)			op_done=0;	//if op_clear is 1 --> op_done sets 0
	 else if(count[5]==1'b1)op_done=1;	//else if count is 6'b100000, op_done is set as '1'
	 else 						op_done=0;  //default. 
endmodule			//endmodule

