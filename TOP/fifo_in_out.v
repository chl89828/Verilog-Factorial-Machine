module fifo_in_out(state, data_count, full, empty, wr_ack, wr_err, rd_ack, rd_err);	//module of fifo_out // output logic
	input [2:0] state;				//input ports
	input [3:0] data_count;			
	
	output full, empty, wr_ack, wr_err, rd_ack, rd_err;	//output ports
	reg full, empty, wr_ack, wr_err, rd_ack, rd_err;
	
	parameter IDLE=3'b000;			//parameterize state value
	parameter WRITE=3'b001;
	parameter READ=3'b010;
	parameter WR_ERROR=3'b011;
	parameter RD_ERROR=3'b100;
				
	always@(state, data_count)		//whenever state, data_count are changed.
		case(state) 					//as state value, output value is allocated 0 or 1
			IDLE  	:	if(data_count==8)
							begin full=1; wr_ack=0; wr_err=0; empty=0 ; rd_ack=0; rd_err=0;	end	//when INIT state, output value
							else if(data_count==0)
							begin full=0; wr_ack=0; wr_err=0; empty=1 ; rd_ack=0; rd_err=0;	end
							else
							begin full=0; wr_ack=0; wr_err=0; empty=0 ; rd_ack=0; rd_err=0;	end
							
			WRITE		: 	if(data_count==8) 
							begin full=1; wr_ack=1; wr_err=0; empty=0; rd_ack=0; rd_err=0;end 
							else
							begin full=0; wr_ack=1; wr_err=0; empty=0; rd_ack=0; rd_err=0;end
			
			READ		: 	if(data_count==0)
							begin full=0; wr_ack=0; wr_err=0; empty=1; rd_ack=1; rd_err=0; end	//when READ state, output value
							else
							begin full=0; wr_ack=0; wr_err=0; empty=0; rd_ack=1; rd_err=0; end
			
			WR_ERROR : begin full=1; wr_ack=0; wr_err=1; empty=0 ; rd_ack=0; rd_err=0; end	//when WR_ERROR state, output value
			
			RD_ERROR : begin full=0; wr_ack=0; wr_err=0; empty=1 ; rd_ack=0; rd_err=1; end	//when RD_ERROR state, output value
			
			default : begin wr_err=1'bx ; wr_ack=1'bx; rd_err=1'bx ; rd_ack=1'bx; full=1'bx; empty=1'bx;end
			//default value : every output values is unknown value
		endcase

endmodule			//end module


		