module fifo_in_write_operation(Addr, we, to_reg);			//module of write_operation // write part of register_file
	input we;															//input data
	input [2:0]Addr;													//address value
	output [7:0] to_reg;												//output  
	
	wire [7:0] write_wire;	
		
	_3_to_8_decoder U0_3_to_8_decoder(.d(Addr), .q(write_wire));
	//instance of 3_to_8 decoder // data can be writed in adopted register 

	//adopting some register
	_and2 U1_and2(.a(we),.b(write_wire[0]),.y(to_reg[0]));
	_and2 U2_and2(.a(we),.b(write_wire[1]),.y(to_reg[1]));
	_and2 U3_and2(.a(we),.b(write_wire[2]),.y(to_reg[2]));
	_and2 U4_and2(.a(we),.b(write_wire[3]),.y(to_reg[3]));
	_and2 U5_and2(.a(we),.b(write_wire[4]),.y(to_reg[4]));
	_and2 U6_and2(.a(we),.b(write_wire[5]),.y(to_reg[5]));
	_and2 U7_and2(.a(we),.b(write_wire[6]),.y(to_reg[6]));
	_and2 U8_and2(.a(we),.b(write_wire[7]),.y(to_reg[7]));
	
	
endmodule	//end module

