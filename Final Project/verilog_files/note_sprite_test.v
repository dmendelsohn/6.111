`timescale 1ns / 1ps
module note_sprite_test;

	// Inputs
	reg clk;
	reg reset;
	reg [5:0] note_pitch;
	reg [11:0] note_dur;
	reg note_trigger;
	reg tick;
	reg [60:0] scoring;
	reg [10:0] hcount;
	reg [9:0] vcount;

	// Outputs
	wire free;
	wire [23:0] pixel;
	
	// DEBUG Outputs
	wire [11:0] tick_count;

	// Instantiate the Unit Under Test (UUT)
	note_sprite uut (
		.clk(clk), 
		.reset(reset), 
		.note_pitch(note_pitch), 
		.note_dur(note_dur), 
		.note_trigger(note_trigger), 
		.tick(tick), 
		.scoring(scoring), 
		.hcount(hcount), 
		.vcount(vcount),
		//DEBUG
		.tick_count(tick_count),
		//END DEBUG
		.free(free), 
		.pixel(pixel)
	);

	always #19 clk = ~clk;
	always begin
		#38 tick = 0;
		#10_000_000 tick = 1;
	end
	always begin
		#38;
		{vcount, hcount} = {vcount, hcount} + 1;
	end

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;
		note_pitch = 0;
		note_dur = 0;
		note_trigger = 0;
		tick = 0;
		scoring = 0;
		hcount = 0;
		vcount = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		reset = 1;
		note_pitch = 2;
		note_dur = 50; //half a second
		#38;
		reset = 0;
		#38;
		note_trigger = 1;
		#38;
		note_trigger = 0;
		
		#511_000_000;
		
		$stop();
	end
      
endmodule

