`timescale 1ns / 1ps
module display_note_layer_test;

	// Inputs
	reg clk;
	reg reset;
	reg tick;
	reg [17:0] note_data;
	reg note_trigger;
	reg [60:0] scoring;
	reg [10:0] hcount;
	reg [9:0] vcount;

	// Outputs
	wire [23:0] pixel;

	// Instantiate the Unit Under Test (UUT)
	display_note_layer uut (
		.clk(clk), 
		.reset(reset), 
		.tick(tick), 
		.note_data(note_data), 
		.note_trigger(note_trigger), 
		.scoring(scoring), 
		.hcount(hcount), 
		.vcount(vcount), 
		.pixel(pixel)
	);

	always #19 clk = ~clk;

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;
		tick = 0;
		note_data = 0;
		note_trigger = 0;
		scoring = 0;
		hcount = 0;
		vcount = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

