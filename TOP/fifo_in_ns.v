module fifo_in_ns(wr_en, rd_en, state, data_count, next_state);	//module of fifo_ns // this module next_state logic
	input wr_en, rd_en;				//input ports
	input[2:0] state;					
	input[3:0] data_count;
	output [2:0] next_state;		//output ports
	reg [2:0] next_state;
	
	parameter IDLE=3'b000;			//parameterize state values
	parameter WRITE=3'b001;
	parameter READ=3'b010;
	parameter WR_ERROR=3'b011;
	parameter RD_ERROR=3'b100;
	
	always@(wr_en, rd_en, state, data_count)	//whenever wr_en, rden, state, data_count are changed.
		case(state)										//as state value
		IDLE:begin										//when current state is INIT state
					if(rd_en==0 && wr_en==1)		//situation next_state is WRITE
						begin
							if(data_count<8)
								next_state<=WRITE;
							else
								next_state<=WR_ERROR;
						end
					else if(rd_en==1 && wr_en==0)	//situation next_state is RD_ERROR
						begin
							if(data_count>0)
								next_state<=READ;
							else
								next_state<=RD_ERROR;
						end				
					else
					next_state<=IDLE;					//situation next_state is INIT
				end
		
		WRITE:begin										//when current state is WRITE state
					if(rd_en==0 && wr_en==1)
						begin
							if(data_count<8)			//situation next_state is WRITE
								next_state<=WRITE;
							else							//situation next_state is FULL
								next_state<=WR_ERROR;
						end
					else if(rd_en==1 && wr_en==0)	
						next_state<=READ;
					else if(rd_en==0 && wr_en==0)									//situation next_state is WRITE
						next_state<=IDLE;
					else
						next_state<=WRITE;
				end
				
		READ:begin										//when current state is READ state
					if(rd_en==0 && wr_en==1)	
						next_state<=WRITE;
					else if(rd_en==1 && wr_en==0)
						begin
							if(data_count>0)			//situation next_state is READ
								next_state<=READ;
							else							//situation next_state is EMPTY	
								next_state<=RD_ERROR;
						end
					else if(rd_en==0 && wr_en==0)
						next_state<=IDLE;				//situation next_state is READ
					else
						next_state<=READ;
				end		

		WR_ERROR:begin									//when current state is WR_ERROR state
						if(rd_en==0 && wr_en==1)	//situation next_state is WR_ERROR
							next_state<=WR_ERROR;
						else if(rd_en==1 && wr_en==0)	//situation next_state is READ
							next_state<=READ;
						else if(rd_en==0 && wr_en==0)								////situation next_state is FULL
							next_state<=IDLE;
						else
							next_state<=WR_ERROR;
					end
		RD_ERROR:begin									//when current state is RD_ERROR state
						if(rd_en==0 && wr_en==1)	//situation next_state is WRITE
							next_state<=WRITE;
						else if(rd_en==1 && wr_en==0)//situation next_state is RD_ERROR
							next_state<=RD_ERROR;
						else if(rd_en==0 && wr_en==0)							 //situation next_state is EMPTY
							next_state<=IDLE;
						else
							next_state<=RD_ERROR;
					end
		default:next_state<=3'bxxx;				//default value : next_state = unknown value
		endcase
		
	
endmodule												//end module
