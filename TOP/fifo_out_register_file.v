module fifo_out_register_file(clk, reset_n, wAddr, wData, we, rAddr, rData);	//module of Register_file // register part of FIFO
	input clk, reset_n, we;			//input port
	input [4:0] wAddr, rAddr;		//input ports : register values
	input [31:0]wData;				//32bit input Write data
	output [31:0]rData;				//32bit output Read data
	
	wire [31:0]to_reg;				//wire
	wire [31:0] from_reg[31:0];

//3 parts are elements of Register_file

	//instance of write_operation		
	fifo_out_write_operation U0_write_operation(.Addr(wAddr), .we(we), .to_reg(to_reg));

	//instance of register32_8
	register32_32 U1_register32_32(.clk(clk), .reset_n(reset_n), .en(to_reg), .d_in(wData), .d_out0(from_reg[0]),.d_out1(from_reg[1]), .d_out2(from_reg[2]), .d_out3(from_reg[3]), .d_out4(from_reg[4]), .d_out5(from_reg[5]), .d_out6(from_reg[6]), .d_out7(from_reg[7])
							, .d_out8(from_reg[8]), .d_out9(from_reg[9]), .d_out10(from_reg[10]), .d_out11(from_reg[11]), .d_out12(from_reg[12]), .d_out13(from_reg[13]), .d_out14(from_reg[14]), .d_out15(from_reg[15]), .d_out16(from_reg[16]), .d_out17(from_reg[17])
							, .d_out18(from_reg[18]), .d_out19(from_reg[19]), .d_out20(from_reg[20]), .d_out21(from_reg[21]), .d_out22(from_reg[22]), .d_out23(from_reg[23]), .d_out24(from_reg[24]), .d_out25(from_reg[25]), .d_out26(from_reg[26])
							, .d_out27(from_reg[27]), .d_out28(from_reg[28]), .d_out29(from_reg[29]), .d_out30(from_reg[30]), .d_out31(from_reg[31]));

	//instance of read_operation							
	fifo_out_read_operation U2_read_operation(.Addr(rAddr), .Data(rData), .from_reg0(from_reg[0]), .from_reg1(from_reg[1]), .from_reg2(from_reg[2]), .from_reg3(from_reg[3]), .from_reg4(from_reg[4]), .from_reg5(from_reg[5]), .from_reg6(from_reg[6])
										, .from_reg7(from_reg[7]), .from_reg8(from_reg[8]), .from_reg9(from_reg[9]), .from_reg10(from_reg[10]), .from_reg11(from_reg[11]), .from_reg12(from_reg[12]), .from_reg13(from_reg[13]), .from_reg14(from_reg[14])
										, .from_reg15(from_reg[15]), .from_reg16(from_reg[16]), .from_reg17(from_reg[17]), .from_reg18(from_reg[18]), .from_reg19(from_reg[19]), .from_reg20(from_reg[20]), .from_reg21(from_reg[21]), .from_reg22(from_reg[22])
										, .from_reg23(from_reg[23]), .from_reg24(from_reg[24]), .from_reg25(from_reg[25]), .from_reg26(from_reg[26]), .from_reg27(from_reg[27]), .from_reg28(from_reg[28]), .from_reg29(from_reg[29]), .from_reg30(from_reg[30])
										, .from_reg31(from_reg[31]));
endmodule

										