module clb4(a, b, ci, c1, c2, c3, co);	//module of fa name basic building block of a design

	input [3:0] a, b;							//4-bits input ports data a, b
	input ci;									//input port carry-in
	output c1, c2, c3, co;					//output ports carry1, carry2, carry3, carry out

	wire [3:0] g, p;							//4-bits wire generate value , propagate value
	
	wire w0_c1;									//wire for carry1
	wire w0_c2, w1_c2;						//wires for carry2
	wire w0_c3, w1_c3, w2_c3;				//wires for carry3
	wire w0_co, w1_co, w2_co, w3_co; 	//wires for carry out
	//generate
	_and2 U0_and2(a[0], b[0], g[0]);		//_and2 instance(input : a[0], b[0] output : g[0])
	_and2 U1_and2(a[1], b[1], g[1]);		//_and2 instance(input : a[1], b[1] output : g[1])
	_and2 U2_and2(a[2], b[2], g[2]);		//_and2 instance(input : a[2], b[2] output : g[2])
	_and2 U3_and2(a[3], b[3], g[3]);		//_and2 instance(input : a[3], b[3] output : g[3])
	
	//propagate
	_or2 	U4_or2(a[0], b[0], p[0]);		//_or2 instance(input : a[0], b[0] output : p[0])
	_or2 	U5_or2(a[1], b[1], p[1]);		//_or2 instance(input : a[1], b[1] output : p[1])
	_or2 	U6_or2(a[2], b[2], p[2]);		//_or2 instance(input : a[2], b[2] output : p[2])
	_or2 	U7_or2(a[3], b[3], p[3]);		//_or2 instance(input : a[3], b[3] output : p[3])
	
	//c1=g[0]|(p[0]&ci)
	_and2 U8_and2(p[0], ci, w0_c1);		//_and2 instance(input : p[0], ci output : w0_c1)
	_or2 U9_or2(g[0], w0_c1, c1);			//_or2 instance(input : g[0], w0_c1 output : c1)
	
	//c2=g[1]|(p[1]&g[0])|(p[1]&p[0],ci)
	_and2 U10_and2(p[1], g[0], w0_c2);	//_and2 instance(input : p[1], g[0] output : w0_c2)
	_and3 U11_and3(p[1], p[0], ci, w1_c2 ); //_and3 instance(input : p[1], p[0], ci output : w1_c2)
	_or3 U12_or3(g[1], w0_c2, w1_c2, c2);	 //_or3 instance(input : g[1], w0_c2, w1_c2 output : c2)
	
	//c3=g[2]|(p[2]&g[1])|(p[2]&p[1],g[0])|(p[2]&p[1],p[0]&ci)
	_and2 U13_and2(p[2], g[1], w0_c3);	//_and2 instance(input : p[2], g[1] output : w0_c3)
	_and3 U14_and3(p[2], p[1], g[0], w1_c3);	//_and3 instance(input : p[2], p[1], g[0] output : w1_c3)
	_and4 U15_and4(p[2], p[1], p[0], ci, w2_c3);	//_and4 instance(input : p[2], p[1], p[0], ci output : w2_c3)
	_or4 U16_or4(g[2], w0_c3, w1_c3, w2_c3, c3);	//_or4 instance(input : g[2], w0_c3, w1_c3, w2_c3 output : c3)
	
	//co=g[3]|(p[3]&g[2])|(p[3]&p[2],g[1])|(p[3]&p[2]&p[1]&g[0])|(p[3]&p[2]&p[1]&p[0]&ci)
	_and2 U17_and2(p[3], g[2], w0_co);								//_and2 instance(input : p[3], g[2] output : w0_co)
	_and3 U18_and3(p[3], p[2], g[1], w1_co);						// _and3 instance(input : p[3], p[2], g[1] output : w1_co)
	_and4 U19_and4(p[3], p[2], p[1], g[0], w2_co);				// _and4 instance(input : p[3], p[2], p[1], g[0] output : w2_co)
	_and5 U20_and6(p[3], p[2], p[1], p[0], ci, w3_co);			// _and5 instance(input : p[3], p[2], p[1], p[0], ci output : w3_co)
	_or5 U21_or6(g[3], w0_co, w1_co, w2_co, w3_co, co);		// _or5 instance(input : g[3], w0_co, w1_co, w2_co, w3_co output : co)
	
endmodule									// end module
