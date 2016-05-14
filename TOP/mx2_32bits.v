module mx2_32bits(d0, d1, s, y ); //module of 32-bits 2-to-1 mux
input [31:0] d0, d1;					 //32-bits input port d0, d1 data 1,2
input	s;									 //input port s select signal
output [31:0] y;						 //32-bits output port y

assign y=(s==0)? d0 : d1;			 //assign if s==0, y=d0, else if y=d1

endmodule								 //end module

