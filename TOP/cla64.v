module cla64(a,b,ci,s,co);			//64-bit cla module
	input [63:0] a,b;					//input port data1, data2
	input ci;							//input port carry in
	output [63:0] s;					//output port 64-bit result data
	output co;							//output carry out
	
	wire w_co;							//wire carry

//two instance of cla32	
cla32 U0_cla32(.a(a[31:0]),.b(b[31:0]),.ci(ci),.s(s[31:0]),.co(w_co));
cla32 U1_cla32(.a(a[63:32]),.b(b[63:32]),.ci(w_co),.s(s[63:32]),.co(co));


endmodule

