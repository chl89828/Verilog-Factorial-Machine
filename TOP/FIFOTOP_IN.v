module FIFOTOP_IN(clk, reset_n, sel, wr, address, din, dout, fifo_cnt, fifo_flag);		//module of fifo_top
	input clk, reset_n;					//input ports clock and reset_n
	input sel, wr;							//input ports select, wr -> ==1 : write , ==0 : read
	input [31:0] din;						//input 32-bit data 
	input [7:0] address;					//8-bit input port address of fifo
	
	output reg [31:0] dout;				//output port 32-bit data
	output reg [3:0] fifo_cnt;			//output port selected fifo's data number
	output reg [5:0] fifo_flag;		//output port selected fifo's status
	
	wire [5:0] w_fifo_flag;				//wire ports
	wire [31:0]	fifo_dout;
	wire [3:0] w_fifo_cnt;	
	
	reg [31:0] next_FIFOFLAG, FIFOFLAG;	//FIFOFLAG register
	
	reg[7:0] next_address;				//next_address
	reg next_sel;							//next_sel
	reg next_wr;							//next_wr
	
	reg wr_en, rd_en;						//input of fifo
	

	
	always@(posedge clk or negedge reset_n)				//register
		if(reset_n==0)	begin 									//initialization
								next_sel<=1'b0; 
								next_address<=8'b0; 
								FIFOFLAG<=32'b0; 
								next_wr<=1'b0;				end
		else				begin 
								next_sel<=sel; 
								next_address<=address; 
								FIFOFLAG<=next_FIFOFLAG; 
								next_wr<=wr;				end
//output logic of dout	
	always@(next_address, FIFOFLAG, fifo_dout, next_wr, next_sel)
		if(next_address==8'h10 && next_sel==1'b1 && next_wr==1'b0)	// next_address 8'h10 means FIFOFLAG's address.
			dout=FIFOFLAG;															//	thus dout is FIFOFLAG value
		else if(next_address==8'h11 && next_sel==1'b1)					// next_address 8'h11 means fifo.
			dout=fifo_dout;														// thus dout is output of fifo 
		else																			// default
			dout=32'b0;

//next logic of FIFOFLAG 					
	always@(w_fifo_flag,sel)
		next_FIFOFLAG={26'b0, w_fifo_flag[5:0]};				//just next_FIFOFLAG is fifo's output flag

//logic of rd_en, wr_en which is input of fifo		
	always@(address, sel, wr)
	if(address==8'h11 && sel==1'b1)				//only after FIFO_TOP is select and FIFO is select, rd_en or wr_en has value.		
		if(wr==1'b1)									//if wr is 1, fifo operates write function.
			begin rd_en=1'b0; wr_en=1'b1; end	//thus wr_en=1
		else												//else (wr is 0), fifo operates read function.
			begin rd_en=1'b1; wr_en=1'b0; end	//thus rd_en=1
	
	else
		begin rd_en=1'b0; wr_en=1'b0; end		//default
	
	FIFO_IN U0_FIFO_IN(.clk(clk), .reset_n(reset_n), .rd_en(rd_en), .wr_en(wr_en), .din(din)
							, .dout(fifo_dout), .full(w_fifo_flag[5]), .empty(w_fifo_flag[4]), .wr_ack(w_fifo_flag[3])
							, .wr_err(w_fifo_flag[2]), .rd_ack(w_fifo_flag[1]), .rd_err(w_fifo_flag[0]), .data_count(w_fifo_cnt));	
	//instance of FIFO_IN

//output logic of fifo_cnt		
	always@(next_sel, w_fifo_cnt, next_address)
		if(next_sel==1'b1 && next_address[3:0]==4'h1 )//only after FIFOTOP is selected and FIFO is selected, fifo_cnt has value
			fifo_cnt=w_fifo_cnt;								 //fifo_cnt is w_fifo_cnt which is output of fifo
		else
			fifo_cnt=4'b0;	
	
	always@(next_sel, w_fifo_flag, next_address)		//only after FIFOTOP is selected and FIFO is selected, fifo_cnt has value
		if(next_sel==1'b1 && next_address[3:0]==4'h1)//fifo_cnt is w_fifo_flag which is output of fifo
			fifo_flag=w_fifo_flag;
		else
			fifo_flag=6'b0;									//default
	
endmodule	

