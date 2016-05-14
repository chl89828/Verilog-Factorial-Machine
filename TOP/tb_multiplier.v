`timescale 1ns/100ps
module tb_multiplier;												//testbench of multiplier
	reg tb_clk, tb_reset_n, tb_op_start, tb_op_clear;		//input and output signal
	reg [63:0] tb_multiplier, tb_multiplicand;
	wire tb_op_done;
	wire [127:0] tb_result;

	
	always					//generate clock pulse
	begin
		tb_clk=1'b0; #5; tb_clk=1'b1; #5; 	
	end

	//instance of multiplier
	multiplier test_multiplier(.clk(tb_clk), .reset_n(tb_reset_n), .multiplier(tb_multiplier)
									, .multiplicand(tb_multiplicand), .op_start(tb_op_start), .op_clear(tb_op_clear)
									, .op_done(tb_op_done), .result(tb_result));
	
	initial			//reg values are inputted
	begin				
		tb_reset_n=1'b0; tb_op_start=1'b1; tb_multiplier=6; tb_multiplicand=-6; tb_op_clear=0; //6*(-6) execution
#3;	tb_reset_n=1; 
#360; tb_op_start=0; tb_op_clear=1; 
#10;	tb_op_clear=0; tb_op_start=1; tb_multiplier=-6; tb_multiplicand=6; 			//6*(-6) execution.  
#360; tb_op_start=0; tb_op_clear=1;
#20;	tb_op_clear=0; tb_op_start=1; tb_multiplier=-15; tb_multiplicand=-15;		//minus * minus
#20;	tb_op_start=0;
#360;	tb_op_clear=1;
#20;	tb_op_clear=0; tb_op_start=1; tb_multiplier=64'hA7D2; tb_multiplicand=5;	//A7D2 = 10100111110100010 
																											//this value has all 8 case x(i) x(i-1) x(i-2)
#20;  tb_op_start=0;
#360; tb_op_clear=1;
#10;	tb_op_clear=0;tb_op_start=1; 
#10;	tb_op_start=0;
#40;	tb_op_clear=1;								//When state is 'EXECUTE', op_clear is set to '1'. State must be changed 'IDLE'
#50; $stop;	
	end
		
endmodule
