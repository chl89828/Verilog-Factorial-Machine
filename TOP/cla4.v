module cla4(a, b, ci, s, co);			//module of Carry Look Ahead Adder 

input [3:0] a, b;										//4-bits input port a, b
input ci;												//input port carry in
output [3:0] s;										//4-bits output port s
output co;												//output ports co

wire c1, c2, c3;									//module's nets c1, c2, c3 wire

fa_v2 U0_fa_v2(a[0], b[0], ci, s[0]);			//fa_v2 instance(input : a[1], b[1], ci output : s[0])	//
fa_v2 U1_fa_v2(a[1], b[1], c1, s[1]);			//fa_v2 instance(input : a[1], b[1], c1 output : s[1])
fa_v2 U2_fa_v2(a[2], b[2], c2, s[2]);			//fa_v2 instance(input : a[2], b[2], c2 output : s[2])
fa_v2 U3_fa_v2(a[3], b[3], c3, s[3]);			//fa_v2 instance(input : a[3], b[3], c3 output : s[3] )
clb4 U4_clb4(a, b, ci, c1, c2, c3, co); 		//clb4 instance(input : a, b, ci, c1, c2, c3 output : co) //carry calculation

endmodule												//end module