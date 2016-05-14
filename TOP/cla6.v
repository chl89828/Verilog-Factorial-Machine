module cla6(a, b, ci, s, co);			//module of cla6

input [5:0] a, b;							//6-bit two input datas
input ci;									//input port carry in
output [5:0] s;							//6-bit output data
output co;									//output port carry out

wire w_co, w_co2;							//carry wire between fa and fa or between fa and cla

fa U0_fa(.a(a[5]),.b(b[5]),.ci(w_co2),.s(s[5]),.co(co));							//upper 2-bit is calculated by fa
fa U1_fa(.a(a[4]),.b(b[4]),.ci(w_co),.s(s[4]),.co(w_co2));						//
cla4 U2_cla4(.a(a[3:0]), .b(b[3:0]), .ci(ci), .s(s[3:0]), .co(w_co));		//down 4-bit is calculated by cla4

endmodule									//endmodule

