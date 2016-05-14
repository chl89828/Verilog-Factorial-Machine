module _3_to_8_decoder(d, q);			//module of 3-to-8 decoder
	input [2:0]d;							//input ports
	output reg [7:0]q;					//output ports
	
	always@(d) begin						//whenever d is changed.
		case(d)								//the value is assigned something value as d value
			3'b000 	: q=8'b0000_0001;
			3'b001	: q=8'b0000_0010;
			3'b010	: q=8'b0000_0100;
			3'b011	: q=8'b0000_1000;
			3'b100	: q=8'b0001_0000;
			3'b101	: q=8'b0010_0000;
			3'b110	: q=8'b0100_0000;
			3'b111	: q=8'b1000_0000;
			default 	: q=8'hx;			//default value : q : unknown value
			
		endcase
	end
endmodule									//end module

