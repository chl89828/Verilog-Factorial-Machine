module fa(a,b,ci,s,co);							//full adder module 생성

input a,b,ci;										//input signal
output s,co;										//output signal


assign s=a^b^ci;									//assign s = a^b^c
assign co=(a&b) | (b&ci) | (a&ci);			//assign co = ab + bci + aci


endmodule											//endmoudle


