module fa_v2(a, b, ci, s);	//module of full adder

input a, b, ci;				//input ports a, b, ci
output s;						//output port s

wire w0;							//wire w0

_xor2 U0_xor2(a, b, w0);	//_xor2 instance(input : a, b output : w0)
_xor2 U1_xor2(w0, ci, s);	//_xor2 instance(input : w0, ci output : s to Full adder)

endmodule						//end module
