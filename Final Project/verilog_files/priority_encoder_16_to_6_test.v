`timescale 1ns / 1ps
module priority_encoder_16_to_6_test;

	// Inputs
	reg [15:0] in;

	// Outputs
	wire [5:0] out;

	// Instantiate the Unit Under Test (UUT)
	priority_encoder_16_to_6 uut (
		.in(in), 
		.out(out)
	);

	initial begin
		// Initialize Inputs
		in = 0;

		// Wait 100 ns for global reset to finish
		#100;
		
		in = 16'b0000_0000_0000_0001;
		#10;
		in = 16'b0000_0000_0000_0110;
		#10;
		in = 16'b1000_0000_0000_0000;
      #10;
		$stop();

	end
      
endmodule

