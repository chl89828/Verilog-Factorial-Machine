module fifo_in_register_file(clk, reset_n, wAddr, wData, we, rAddr, rData);	//module of Register_file // register part of FIFO
	input clk, reset_n, we;		//input port
	input [2:0]wAddr, rAddr;	//input ports : register values
	input [31:0]wData;			//32bit input Write data
	output [31:0]rData;			//32bit output Read data
	
	wire[7:0]to_reg;				//wire
	wire [31:0] from_reg[7:0];

	//3 parts are elements of Register_file
	
	fifo_in_write_operation U0_fifo_in_write_operation(.Addr(wAddr), .we(we), .to_reg(to_reg));
	//instance of write_operation
	
	register32_8 U1_register32_8(.clk(clk), .reset_n(reset_n), .en(to_reg), .d_in(wData), .d_out0(from_reg[0]), .d_out1(from_reg[1]), .d_out2(from_reg[2]), .d_out3(from_reg[3]), .d_out4(from_reg[4]), .d_out5(from_reg[5]), .d_out6(from_reg[6]), .d_out7(from_reg[7]));
	//instance of register32_8
	
	fifo_in_read_operation U2_fifo_in_read_operation(.Addr(rAddr), .Data(rData), .from_reg0(from_reg[0]), .from_reg1(from_reg[1]), .from_reg2(from_reg[2]), .from_reg3(from_reg[3]), .from_reg4(from_reg[4]), .from_reg5(from_reg[5]), .from_reg6(from_reg[6]), .from_reg7(from_reg[7]));
	//instance of read_operation
	
endmodule

