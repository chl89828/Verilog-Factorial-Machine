module _inv(a,y);			//module of 2-inputs invertor
	input a;					//input port
	output y;				//output port
	
	assign y=~a;			//output : ~a
endmodule					//end module

module _nand2(a,b,y);	//module of 2-inputs NAND gate
	input a,b;				//input port 
	output y;				//output port
	
	assign y=~(a&b);		//assign a NAND b	
endmodule					//end module

module _and2(a,b,y);		//module of 2-inputs AND gate
	input a,b;				//input port
	output y;				//output port
	
	assign y=a&b;			//assign a AND b
endmodule					//end module

module _or2(a,b,y);		//module of 2-inputs OR gate
	input a,b;				//input ports
	output y;				//output port
	
	assign y=a|b;			//assign a OR b
endmodule					//end module

module _xor2(a,b,y);		//module of 2-input XOR gate
	input a, b;				//input ports
	output y;				//output ports
	
	wire inv_a, inv_b;	//wire ports
	wire w0, w1;			//wire ports

	_inv U0_inv(.a(a), .y(inv_a));	//_inv instance(input : a output : inv_a of exclusive-or)
	_inv U1_inv(.a(b), .y(inv_b));	//_inv instance(input : b output : inv_b of exclusive-or)
	_and2 U2_and2(.a(inv_a), .b(b), .y(w0));	//_inv instance(input : inv_a, b output : w0 of exclusive-or)
	_and2 U3_and2(.a(a),.b(inv_b), .y(w1));	//_inv instance(input : a, inv_b output : w1 exclusive-or)
	_or2 U4_or2(.a(w0), .b(w1),.y(y));			//_inv instance(input : w0, w1 output=y of exclusive-or)
endmodule						//end module
	
module _and3(a,b,c,y);		//module of 3-inputs gate
	input a,b,c;				//input ports
	output y;					//output ports

	assign y=a&b&c;			//assign a AND b AND c
endmodule						//end module

module _and4(a,b,c,d,y);	//module of 4-inputs AND gate
	input a,b,c,d;				//input ports
	output y;					//output ports

	assign y=a&b&c&d;			//assign a AND b AND c AND d
endmodule						//end module
	
module _and5(a,b,c,d,e,y);	//module of 5-inputs AND gate
	input a,b,c,d,e;			//input ports
	output y;					//output ports

	assign y=a&b&c&d&e;		//assign a AND b AND c AND d AND e
endmodule						//end module

module _or3(a,b,c,y);		//module of 3-inputs OR gate
	input a,b,c;				//input port
	output y;					//output port

	assign y=a|b|c;			//assign a OR b OR c
endmodule						//end module

module _or4(a,b,c,d,y);		//module of 4-inputs OR gate
	input a,b,c,d;				//input ports
	output y;					//output ports

	assign y=a|b|c|d;			//assign a OR b OR c OR d
endmodule						//end module

module _or5(a,b,c,d,e,y);	//module of 5-inputs OR gate
	input a,b,c,d,e;			//input ports
	output y;					//output ports

	assign y=a|b|c|d|e;		//assign a OR b OR c OR d OR e
endmodule						//end module

module _inv_4bits(a,y);		//module of 4-bits invertor
	input [3:0] a;				//4-bits input ports
	output [3:0] y;			//4-bits output ports
	
	assign y=~a;				//assign NOT 4-bits a
	
endmodule						//end module

module _and2_4bits(a,b,y);	//module of 4-bits 2-input AND gate
input [3:0] a,b;				//4-bits input ports data a, b
output [3:0] y;				//4-bits output port
assign y=a&b;					//assign 4-bits a AND 4-bits b
endmodule						//end module

module _or2_4bits(a,b,y);	//module of 4-bits 2-input OR gate
input [3:0] a,b;				//4-bits input ports data a, b
output [3:0] y;				//4-bits output port
assign y=a|b;					//assign 4-bits a OR 4-bits b
endmodule						//end module

module _xor2_4bits(a,b,y);	//module of 4-bits 2-input XOR gate
input [3:0] a,b;				//4-bits input ports
output [3:0] y;				//4-bits output port
_xor2 U0_xor2(.a(a[0]), .b(b[0]), .y(y[0]));	//4-bits input a, b are inputted in four 1-bit xor gates 
_xor2 U1_xor2(.a(a[1]), .b(b[1]), .y(y[1]));
_xor2 U2_xor2(.a(a[2]), .b(b[2]), .y(y[2]));
_xor2 U3_xor2(.a(a[3]), .b(b[3]), .y(y[3]));
endmodule						//end module

module _xnor2_4bits(a,b,y);	//module of 4-bits 2-input XOR gate
input [3:0] a,b;					//4-bits input ports
output [3:0] y;					//4-bits output port
wire [3:0] w0;						//4-bits XOR gate's output
_xor2_4bits U0_xor2_4bits(.a(a), .b(b), .y(w0));	//4-bits input a, b are inputted in one 4-bit xor gates.
_inv_4bits U1_inv_4bits(.a(w0), .y(y));	//input w0 is inputted in 4-bits _inv
endmodule						//end module


module _inv_32bits(a,y);		//module of 32-bits invertor
input [31:0] a;					//32-bits input port	a
output [31:0] y;					//32-bits output port y
assign y=~a;						//assign ~a in y
endmodule							//end module

module _and2_32bits(a,b,y);	//module of 32-bits 2-input AND gate
input [31:0] a,b;					//32-bits input ports a,b - data1, data2
output [31:0] y;					//32-bits output port y
assign y=a&b;						//assign a AND b in y
endmodule							//end module

module _or2_32bits(a,b,y);		//module of 32-bits 2-input OR gate
input [31:0] a,b;					//32-bits input ports a,b - data1, data2
output [31:0] y;					//32-bits output port y
assign y=a|b;						//assign a OR b in y
endmodule							//end module


module _xor2_32bits(a,b,y);	//module of 32-bits 2-input XOR gate
input [31:0] a,b; 				//32-bits input ports a,b - data1, data2
output [31:0] y; 					//32-bits output port y

//Every a, b are inputted in instance of _xor2_4bits as 4-bits scale.
_xor2_4bits U0_xor2_4bits(.a(a[3:0]), .b(b[3:0]), .y(y[3:0])); 
_xor2_4bits U1_xor2_4bits(.a(a[7:4]), .b(b[7:4]), .y(y[7:4])); 
_xor2_4bits U2_xor2_4bits(.a(a[11:8]), .b(b[11:8]), .y(y[11:8])); 
_xor2_4bits U3_xor2_4bits(.a(a[15:12]), .b(b[15:12]), .y(y[15:12])); 
_xor2_4bits U4_xor2_4bits(.a(a[19:16]), .b(b[19:16]), .y(y[19:16])); 
_xor2_4bits U5_xor2_4bits(.a(a[23:20]), .b(b[23:20]), .y(y[23:20])); 
_xor2_4bits U6_xor2_4bits(.a(a[27:24]), .b(b[27:24]), .y(y[27:24])); 
_xor2_4bits U7_xor2_4bits(.a(a[31:28]), .b(b[31:28]), .y(y[31:28])); 

endmodule							//end module

module _xnor2_32bits(a,b,y); 	//module of 32-bits 2-input XNOR gate
input [31:0] a,b;					//32-bits input ports a,b - data1,2
output [31:0] y;					//32-bits output ports y
//Every a, b are inputted in instance of _xor2_4bits as 4-bits scale.
_xnor2_4bits U0_xnor2_4bits(.a(a[3:0]), .b(b[3:0]), .y(y[3:0]));
_xnor2_4bits U1_xnor2_4bits(.a(a[7:4]), .b(b[7:4]), .y(y[7:4]));
_xnor2_4bits U2_xnor2_4bits(.a(a[11:8]), .b(b[11:8]), .y(y[11:8]));
_xnor2_4bits U3_xnor2_4bits(.a(a[15:12]), .b(b[15:12]), .y(y[15:12]));
_xnor2_4bits U4_xnor2_4bits(.a(a[19:16]), .b(b[19:16]), .y(y[19:16]));
_xnor2_4bits U5_xnor2_4bits(.a(a[23:20]), .b(b[23:20]), .y(y[23:20]));
_xnor2_4bits U6_xnor2_4bits(.a(a[27:24]), .b(b[27:24]), .y(y[27:24]));
_xnor2_4bits U7_xnor2_4bits(.a(a[31:28]), .b(b[31:28]), .y(y[31:28]));
endmodule							//end module

module _nor2(a,b,y);				
input a,b;
output y;
assign y=~(a|b);
endmodule
