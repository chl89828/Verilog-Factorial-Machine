//module of read_operation// raed part of register file
module fifo_out_read_operation(Addr, Data, from_reg0, from_reg1, from_reg2, from_reg3, from_reg4, from_reg5, from_reg6
										, from_reg7, from_reg8, from_reg9, from_reg10, from_reg11, from_reg12, from_reg13, from_reg14
										, from_reg15, from_reg16, from_reg17, from_reg18, from_reg19, from_reg20, from_reg21, from_reg22
										, from_reg23, from_reg24, from_reg25, from_reg26, from_reg27, from_reg28, from_reg29, from_reg30
										, from_reg31);

	//input datas //register value is stored in value selected 
	input [31:0]					from_reg0, from_reg1, from_reg2, from_reg3, from_reg4, from_reg5, from_reg6
										, from_reg7, from_reg8, from_reg9, from_reg10, from_reg11, from_reg12, from_reg13, from_reg14
										, from_reg15, from_reg16, from_reg17, from_reg18, from_reg19, from_reg20, from_reg21, from_reg22
										, from_reg23, from_reg24, from_reg25, from_reg26, from_reg27, from_reg28, from_reg29, from_reg30
										, from_reg31;
										
	input[4:0]Addr;			//address value
	output[31:0]Data;			//selected register

	//instatance of 32_to_1 MUX	// only one from_reg is selected and Data(output) is this value 
	_32_to_1_MUX U0_32_to_1_MUX(.d1(from_reg0),.d2(from_reg1),.d3(from_reg2),.d4(from_reg3),.d5(from_reg4),.d6(from_reg5)
										,.d7(from_reg6),.d8(from_reg7),.d9(from_reg8),.d10(from_reg9),.d11(from_reg10),.d12(from_reg11)
										,.d13(from_reg12),.d14(from_reg13),.d15(from_reg14),.d16(from_reg15),.d17(from_reg16)
										,.d18(from_reg17),.d19(from_reg18),.d20(from_reg19),.d21(from_reg20),.d22(from_reg21)
										,.d23(from_reg22),.d24(from_reg23),.d25(from_reg24),.d26(from_reg25),.d27(from_reg26)
										,.d28(from_reg27),.d29(from_reg28),.d30(from_reg29),.d31(from_reg30),.d32(from_reg31)
										,.sel(Addr),.d_out(Data));
endmodule


										
										