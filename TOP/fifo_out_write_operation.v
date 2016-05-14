module fifo_out_write_operation(Addr, we, to_reg);		//module of write_operation of fifo_out // write part of register_file
	input we;														//input port we - write enable
	input [4:0]Addr;												//ipput port 5-bit address 
	output [31:0] to_reg;										//output port 31-bit 
	
	wire [31:0] write_wire;										//wire output of decoder
	
	_5_to_32_decoder U0_5_to_32_decoder(.d(Addr), .q(write_wire));	//as address only 1 bit of write_wire is set. by decoder
	
	
	//we == 1 && write_wrie[i] --> to_reg[i] =1
	_and2 U1_and2(.a(we),.b(write_wire[0]),.y(to_reg[0]));
	_and2 U2_and2(.a(we),.b(write_wire[1]),.y(to_reg[1]));
	_and2 U3_and2(.a(we),.b(write_wire[2]),.y(to_reg[2]));
	_and2 U4_and2(.a(we),.b(write_wire[3]),.y(to_reg[3]));
	_and2 U5_and2(.a(we),.b(write_wire[4]),.y(to_reg[4]));
	_and2 U6_and2(.a(we),.b(write_wire[5]),.y(to_reg[5]));
	_and2 U7_and2(.a(we),.b(write_wire[6]),.y(to_reg[6]));
	_and2 U8_and2(.a(we),.b(write_wire[7]),.y(to_reg[7]));
	
	_and2 U9_and2(.a(we),.b(write_wire[8]),.y(to_reg[8]));
	_and2 U10_and2(.a(we),.b(write_wire[9]),.y(to_reg[9]));
	_and2 U11_and2(.a(we),.b(write_wire[10]),.y(to_reg[10]));
	_and2 U12_and2(.a(we),.b(write_wire[11]),.y(to_reg[11]));
	_and2 U13_and2(.a(we),.b(write_wire[12]),.y(to_reg[12]));
	_and2 U14_and2(.a(we),.b(write_wire[13]),.y(to_reg[13]));
	_and2 U15_and2(.a(we),.b(write_wire[14]),.y(to_reg[14]));
	_and2 U16_and2(.a(we),.b(write_wire[15]),.y(to_reg[15]));
	
	_and2 U17_and2(.a(we),.b(write_wire[16]),.y(to_reg[16]));
	_and2 U18_and2(.a(we),.b(write_wire[17]),.y(to_reg[17]));
	_and2 U19_and2(.a(we),.b(write_wire[18]),.y(to_reg[18]));
	_and2 U20_and2(.a(we),.b(write_wire[19]),.y(to_reg[19]));
	_and2 U21_and2(.a(we),.b(write_wire[20]),.y(to_reg[20]));
	_and2 U22_and2(.a(we),.b(write_wire[21]),.y(to_reg[21]));
	_and2 U23_and2(.a(we),.b(write_wire[22]),.y(to_reg[22]));
	_and2 U24_and2(.a(we),.b(write_wire[23]),.y(to_reg[23]));
	
	_and2 U25_and2(.a(we),.b(write_wire[24]),.y(to_reg[24]));
	_and2 U26_and2(.a(we),.b(write_wire[25]),.y(to_reg[25]));
	_and2 U27_and2(.a(we),.b(write_wire[26]),.y(to_reg[26]));
	_and2 U28_and2(.a(we),.b(write_wire[27]),.y(to_reg[27]));
	_and2 U29_and2(.a(we),.b(write_wire[28]),.y(to_reg[28]));
	_and2 U30_and2(.a(we),.b(write_wire[29]),.y(to_reg[29]));
	_and2 U31_and2(.a(we),.b(write_wire[30]),.y(to_reg[30]));
	_and2 U32_and2(.a(we),.b(write_wire[31]),.y(to_reg[31]));
	
endmodule

	