`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:58:53 11/18/2013
// Design Name:   uart
// Module Name:   /afs/athena.mit.edu/user/d/m/dmendels/Desktop/6.111/piano_hero_proj/uart_test.v
// Project Name:  piano_hero_proj
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: uart
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module uart_test;

	// Inputs
	reg in;
	reg clk;
	reg reset;

	// Outputs
	wire data_ready;
	wire [7:0] data;
	wire expired;

	// Instantiate the Unit Under Test (UUT)
	uart uut (
		.in(in), 
		.clk(clk), 
		.reset(reset), 
		.data_ready(data_ready), 
		.data(data),
		.expired(expired)
	);
	
	always #19 clk = ~clk;
	
	initial begin
		// Initialize Inputs
		in = 1;
		clk = 0;
		reset = 0;

		// Wait 100 ns for global reset to finish
		#100;
		if(data != 0 || data_ready != 0) begin
			$display("Initialization values are bad");
			$stop();
		end
		#10000;
		in = 0;
		#32832;
		in = 1;
		#32832;
		in = 0;
		#32832;
		in = 1;
		#32832;
		in = 1;
		#32832;
		in = 1;
		#32832;
		in = 0;
		#32832;
		in = 1;
		#32832;
		in = 1;
		#32832;
		in = 0;
		#32832;
		in = 1;
		
		#32832;
		if (data != 8'b10_11_10_11) begin
			$display("Final value is bad");
			$stop();
		end
		else begin
			$display("Correct value");
			$stop();
		end
	end
      
endmodule

