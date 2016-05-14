module fifo_in_cal_addr(state, head, tail, data_count, we, re, next_head, next_tail, next_data_count);
//module of fifo_cal_addr  // this module calculates next_state, next_head, next_tail, next_data_count.

	input[2:0] state, head, tail;			//input ports
	input[3:0] data_count;					//input ports
	output reg we,re ;						//output ports
	output reg[2:0] next_head, next_tail;//output ports
	output reg[3:0] next_data_count;		 //output ports
	
	parameter IDLE=3'b000;					//parameterize each states
	parameter WRITE=3'b001;
	parameter READ=3'b010;
	parameter WR_ERROR=3'b011;
	parameter RD_ERROR=3'b100; 
	
	always@(state, head, tail,data_count)	//whenever state, head, tail, data_count are changed
		case(state)									//as state value
		IDLE:		//when next_state is INIT
			begin we=0; re=0; next_head=head; next_tail=tail; next_data_count=data_count; end
			//initialize value
		
		WRITE:	//when next_state is WRITE
			begin we=1; re=0; next_head=head; next_tail=tail+3'b001; next_data_count=data_count+4'b0001; end
			//we=1, tail++, data_count++
			
		READ:		//when next_state is READ
			begin we=0; re=1; next_head=head+3'b001; next_tail=tail; next_data_count=data_count-4'b0001; end
			//re=1, head++, data_count--
	
		WR_ERROR:	//when next_state is WR_ERROR
			begin we=0; re=0;next_head=head; next_tail=tail; next_data_count=data_count; end
			//values are not changed	
		
		RD_ERROR:	//when next_state is RD_ERROR
			begin we=0; re=0; next_head=head; next_tail=tail; next_data_count=data_count;end
			//values are not changed
			
		default:		//default value
			begin we=1'bx; re=1'bx; next_head=3'bxxx; next_tail=3'bxxx; next_data_count=4'bxxxx;end
			//values are unknown value
		endcase
		
endmodule		//end module
