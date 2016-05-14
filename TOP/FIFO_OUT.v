module FIFO_OUT(clk, reset_n, rd_en, wr_en, din, dout, full, empty, wr_ack, wr_err, rd_ack, rd_err, data_count);
//module of FIFO_OUT
//first in data is first out
	
	input clk, reset_n, rd_en, wr_en;			//input of fifo
	input[31:0] din;										
	output [31:0]dout;								//output of fifo
	output full, empty, wr_ack, wr_err, rd_ack, rd_err;
	output[5:0] data_count;
	
	wire [4:0] head, next_head;					//wires of fifo
	wire [4:0] tail, next_tail;
	wire [2:0] state, next_state;
	wire [5:0] next_data_count;
	wire we,re;
	wire [31:0]to_mux;
	wire [31:0]to_reg;
	
		
	fifo_out_ns U0_fifo_out_ns(.wr_en(wr_en), .rd_en(rd_en), .state(state), .data_count(data_count), .next_state(next_state));
	//instatnce of fifo_ns // input : state output : next_state
	
	fifo_out_cal_addr U1_fifo_out_cal_addr(.state(next_state), .head(head), .tail(tail), .data_count(data_count), .we(we), .re(re), .next_head(next_head), .next_tail(next_tail), .next_data_count(next_data_count));
	//instance of fifo_cal_addr // head, tail , state, data_count are calculated.

	_dff_3_r U2_dff_3_r(.clk(clk), .reset_n(reset_n), .d(next_state), .q(state));
	//instance of _dff_3_r	// state is saved.
	
	_dff_5_r U3_dff_3_r(.clk(clk), .reset_n(reset_n), .d(next_head), .q(head));
	//instance of _dff_3_r // head is saved.

	_dff_5_r U4_dff_3_r(.clk(clk), .reset_n(reset_n), .d(next_tail), .q(tail));
	//instance of _dff_3_r // tail is saved.
	
	_dff_6_r U5_dff_4_r(.clk(clk), .reset_n(reset_n), .d(next_data_count), .q(data_count));
	//instance of _dff_4_r // data_count is saved
	
	fifo_out_out U6_fifo_out_out(.state(state), .data_count(data_count), .full(full), .empty(empty), .wr_ack(wr_ack), .wr_err(wr_err), .rd_ack(rd_ack), .rd_err(rd_err));
	// instatnce of fifo_out // output logic
	
	fifo_out_register_file U7fifo_out_Register_file(.clk(clk), .reset_n(reset_n), .wAddr(tail), .wData(din), .we(we), .rAddr(head), .rData(to_mux));
	// instance of Register_file  // 32-bit datas are saved.
	
	mx2_32bits U8_mx2_32bits(.d0(32'h0000_0000), .d1(to_mux), .s(re), .y(to_reg));
	// instance of mx2_32bits // only one 32bit datas is selected.

	register32_r_en U9_register32_r_en(.clk(clk), .reset_n(reset_n), .d_in(to_reg), .d_out(dout), .en(1'b1));
	// instance of register32_r_en // 32bits data is saved.
	
endmodule
