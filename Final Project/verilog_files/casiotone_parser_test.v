`timescale 1ns / 1ps
module casiotone_parser_test;

	// Inputs
	reg clk;
	reg [7:0] in;
	reg trigger;
	reg reset;

	// Outputs
	wire enable;
	wire [7:0] out;

	// Instantiate the Unit Under Test (UUT)
	casiotone_parser uut (
		.clk(clk), 
		.in(in), 
		.trigger(trigger), 
		.reset(reset), 
		.enable(enable), 
		.out(out)
	);

	always #5 clk = ~clk;

	initial begin
		// Initialize Inputs
		clk = 0;
		in = 0;
		trigger = 0;
		reset = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		if(out != 0 || enable != 0) begin
			$display("Initialization values are bad");
			$stop();
		end
		
		in = 8'd60; //middle C
		trigger = 1; //latch up
		#10;	//wait one clock cycle
		trigger = 0;	//latch down	

		#32000; //wait a while
		
		in = 8'h40; //note on
		trigger = 1; //latch up
		#10;	//wait one clock cycle
		trigger = 0; //latch down
		
		#100; //wait a short while
		
		if (out != 8'b10_01_10_00) begin
			$display("Final value is bad");
			$stop();
		end
		else begin
			$display("Correct value");
			$stop();
		end
	end
      
endmodule

