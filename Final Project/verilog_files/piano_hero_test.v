`timescale 1ns / 1ps
module piano_hero_test;

	// Inputs
	reg clk;
	reg reset;
	reg up;
	reg down;
	reg right;
	reg left;
	reg [3:0] buttons;
	reg [7:0] switches;
	reg [10:0] hcount;
	reg [9:0] vcount;
	reg raw_input;

	// Outputs
	wire [7:0] leds;
	wire [63:0] hex_data;
	wire [23:0] pixel;
	
	//TEST outputs
	wire tick;

	// Instantiate the Unit Under Test (UUT)
	piano_hero uut (
		.clk(clk), 
		.reset(reset), 
		.up(up), 
		.down(down), 
		.right(right), 
		.left(left), 
		.buttons(buttons), 
		.switches(switches), 
		.hcount(hcount), 
		.vcount(vcount), 
		.raw_input(raw_input),
		//DEBUG
		.tick(tick),
		//END DEBUG
		.leds(leds), 
		.hex_data(hex_data), 
		.pixel(pixel)
	);
	
	always #19 clk = ~clk;

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;
		up = 0;
		down = 0;
		right = 0;
		left = 0;
		buttons = 0;
		switches = 0;
		hcount = 0;
		vcount = 0;
		raw_input = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		reset = 1;
		#40;
		reset = 0;
		#40;
		
		switches[0] = 1;
		switches[1] = 1;
		
		#240_000_000;
		$stop();
	end
      
endmodule

