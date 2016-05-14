module cla32(a,b,ci,s,co);		// module of 32-bit carry look ahead adder 

	input[31:0] a,b;				//input signal 32-bit data 1, data2
	input ci;						//input signal 1-bit carry in
	output [31:0] s;				//output signal 32-bit Sum value
	output co;						//output signal 1-bit carry out
	
	wire c1,c2,c3,c4,c5,c6,c7;	//4-bits으로 이루어진 CLA 의 instance 의 carry 값들 
	
	cla4 U0_cla4(.a(a[3:0]), .b(b[3:0]), .s(s[3:0]), .ci(ci), .co(c1)); 		//최하위 4bits data 연산 하는 instance of 4bits CLA
	cla4 U1_cla4(.a(a[7:4]), .b(b[7:4]), .s(s[7:4]), .ci(c1), .co(c2));			//중간 4~7bits data 연산 하는 instance of 4bits CLA
	cla4 U2_cla4(.a(a[11:8]), .b(b[11:8]), .s(s[11:8]), .ci(c2), .co(c3));		//중간 8~11bits data 연산 하는 instance of 4bits CLA
	cla4 U3_cla4(.a(a[15:12]), .b(b[15:12]), .s(s[15:12]), .ci(c3), .co(c4));	//중간 12~15bits data 연산 하는 instance of 4bits CLA
	cla4 U4_cla4(.a(a[19:16]), .b(b[19:16]), .s(s[19:16]), .ci(c4), .co(c5));	//중간 16~19bits data 연산 하는 instance of 4bits CLA
	cla4 U5_cla4(.a(a[23:20]), .b(b[23:20]), .s(s[23:20]), .ci(c5), .co(c6));	//중간 20~23bits data 연산 하는 instance of 4bits CLA
	cla4 U6_cla4(.a(a[27:24]), .b(b[27:24]), .s(s[27:24]), .ci(c6), .co(c7));	//중간 24~27bits data 연산 하는 instance of 4bits CLA
	cla4 U7_cla4(.a(a[31:28]), .b(b[31:28]), .s(s[31:28]), .ci(c7), .co(co));	//최상위 4bits data 연산 하는 instance of 4bits CLA
	
	
	endmodule
	