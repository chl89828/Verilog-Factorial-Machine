module _8_to_1_MUX(a,b,c,d,e,f,g,h,sel,d_out);		//8_to_1MUX of module
	input [31:0]a,b,c,d,e,f,g,h;							//input ports. only one value is selected.
	input [2:0] sel;											//select signal
	output reg[31:0] d_out;									//32-bit output value selected
	
	always@(sel,a,b,c,d,e,f,g,h) begin					//whenever sel, a, b, c, d, e, f, g, h are changed
		case(sel)												//as sel value , d_out is assigned adopted value
			3'b000	: d_out = a;
			3'b001	: d_out = b;
			3'b010	: d_out = c;
			3'b011	: d_out = d;
			3'b100	: d_out = e;
			3'b101	: d_out = f;
			3'b110	: d_out = g;
			3'b111	: d_out = h;
			default  : d_out=32'hx;							//default value : 32'bit unknown value
		endcase
	end	
endmodule														//end module

