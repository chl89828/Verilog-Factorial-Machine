module fifo_in_read_operation(Addr, Data, from_reg0, from_reg1, from_reg2, from_reg3, from_reg4, from_reg5, from_reg6, from_reg7);
//module of read_operation// raed part of register file

	input [31:0] from_reg0, from_reg1, from_reg2, from_reg3, from_reg4, from_reg5, from_reg6, from_reg7;
	//input datas //register value is stored in value selected 
	
	input [2:0]Addr;	//address value
	output[31:0]Data;	//selected register

	_8_to_1_MUX U0_8_to_1_MUX(.a(from_reg0),.b(from_reg1), .c(from_reg2),.d(from_reg3),.e(from_reg4),.f(from_reg5),.g(from_reg6),.h(from_reg7),.sel(Addr),.d_out(Data));
	//instatance of 8_to_1 MUX // only one from_reg is selected and Data(output) is this value 
	
endmodule		//end module
