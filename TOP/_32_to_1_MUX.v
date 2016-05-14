module _32_to_1_MUX(d1,d2,d3,d4,d5,d6,d7,d8,d9,d10,d11,d12,d13,d14,d15,d16,d17,d18,d19,d20,d21,d22,d23,d24,d25,d26,d27,d28,d29,d30,d31,d32,sel,d_out);
	//32_to_1MUX of module
	
	input[31:0] d1,d2,d3,d4,d5,d6,d7,d8,d9,d10,d11,d12,d13,d14,d15,d16,d17,d18,d19,d20,d21,d22,d23,d24,d25,d26,d27,d28,d29,d30,d31,d32;
	//input ports. only one value is selected.
	
	input [4:0] sel;
	//select signal
	
	output reg[31:0] d_out;
	//32-bit output value selected
	
	
	always@(sel,d1,d2,d3,d4,d5,d6,d7,d8,d9,d10,d11,d12,d13,d14,d15,d16,d17,d18,d19,d20,d21,d22,d23,d24,d25,d26,d27,d28,d29,d30,d31,d32)
	begin
		case(sel)					//as sel value , d_out is assigned adopted value
			5'b00000	:	d_out=d1;//for example sel == 00000 - d1 is selected.
			5'b00001	:	d_out=d2;
			5'b00010	:	d_out=d3;
			5'b00011	:	d_out=d4;
			5'b00100	:	d_out=d5;
			5'b00101	:	d_out=d6;
			5'b00110	:	d_out=d7;
			5'b00111	:	d_out=d8;
			
			5'b01000	:	d_out=d9;
			5'b01001	:	d_out=d10;
			5'b01010	:	d_out=d11;
			5'b01011	:	d_out=d12;
			5'b01100	:	d_out=d13;
			5'b01101	:	d_out=d14;
			5'b01110	:	d_out=d15;
			5'b01111	:	d_out=d16;	

			5'b10000	:	d_out=d17;
			5'b10001	:	d_out=d18;
			5'b10010	:	d_out=d19;
			5'b10011	:	d_out=d20;
			5'b10100	:	d_out=d21;
			5'b10101	:	d_out=d22;
			5'b10110	:	d_out=d23;
			5'b10111	:	d_out=d24;
			
			5'b11000	:	d_out=d25;
			5'b11001	:	d_out=d26;
			5'b11010	:	d_out=d27;
			5'b11011	:	d_out=d28;
			5'b11100	:	d_out=d29;
			5'b11101	:	d_out=d30;
			5'b11110	:	d_out=d31;
			5'b11111	:	d_out=d32;	
			default 	:	d_out=32'hx;		//default value : 32'bit unknown value
		endcase
	end
endmodule
