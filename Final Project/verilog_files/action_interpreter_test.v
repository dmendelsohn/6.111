`timescale 1ns / 1ps
module action_interpreter_test;

	// Inputs
	reg clk;
	reg reset;
	reg tick;
	reg key_trigger;
	reg [6:0] key_data;
	reg note_trigger;
	reg [17:0] note_data;

	// Outputs
	wire [2:0] msg;
	wire [63:0] scoring;
	wire enable;
	
	wire [63:0] running_x;
	wire [11:0] duration_x, tick_count_x;

	// Instantiate the Unit Under Test (UUT)
	action_interpreter uut (
		.clk(clk), 
		.reset(reset), 
		.tick(tick), 
		.key_trigger(key_trigger), 
		.key_data(key_data), 
		.note_trigger(note_trigger), 
		.note_data(note_data), 
		.msg(msg), 
		.scoring(scoring),
		.running_x(running_x),
		.duration_x(duration_x),
		.tick_count_x(tick_count_x),
		.enable(enable)
	);

	always #5 clk = ~clk;
	always begin
		#10000000 tick = 1;
		#10 tick = 0;
	end

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;
		tick = 0;
		key_trigger = 0;
		key_data = 0;
		note_trigger = 0;
		note_data = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		
		/* //NO_PRESS_TEST
		note_data[17:12] = 6'd9;
		note_data[11:0] = 12'd200;
		note_trigger = 1;
		#10;
		note_trigger = 0;
		#800_000_000; //wait 0.8sec (80 ticks
		$stop();
		*/
		
		//BAD_PRESS_TEST
		/*note_data[17:12] = 6'd9;
		note_data[11:0] = 12'd200;
		note_trigger = 1;
		#10;
		note_trigger = 0;
		#700_000_000; //wait 0.7sec (within window of press tolerance)
		key_data[6] = 1; //press
		key_data[5:0] = 6'd10; //wrong key
		key_trigger = 1;
		#10;
		key_trigger = 0;
		#100; //wait a short while
		$stop();*/
		
		//SINGLE GOOD_PRESS_TEST
		/*note_data[17:12] = 6'd9;
		note_data[11:0] = 12'd200;
		note_trigger = 1;
		#10;
		note_trigger = 0;
		#700_000_000; //wait 0.7sec (within window of press tolerance)
		key_data[6] = 1; //press
		key_data[5:0] = 6'd09; //correct key
		key_trigger = 1;
		#10;
		key_trigger = 0;
		#100; //wait a short while
		$stop(); */
		
		// GOOD PRESS FOLLOWED BY LATE UNPRESS
		/*note_data[17:12] = 6'd9;
		note_data[11:0] = 12'd20;
		note_trigger = 1;
		#10;
		note_trigger = 0;
		#320_000_000; //wait 0.32sec (within window of press tolerance)
		key_data[6] = 1; //press
		key_data[5:0] = 6'd09; //correct key
		key_trigger = 1;
		#10;
		key_trigger = 0;
		#400_000_000; //wait until note expires
		$stop();*/
		
		// GOOD PRESS FOLLOWED BY GOOD UNPRESS
		/*note_data[17:12] = 6'd9;
		note_data[11:0] = 12'd20;
		note_trigger = 1;
		#10;
		note_trigger = 0;
		#320_000_000; //wait 0.32sec (within window of press tolerance)
		key_data[6] = 1; //press
		key_data[5:0] = 6'd09; //correct key
		key_trigger = 1;
		#10;
		key_trigger = 0;
		#200_000_000; //wait til appropriate time
		key_data[6] = 0; //unpress
		key_data[5:0] = 6'd09; // same key
		key_trigger = 1;
		#10;
		key_trigger = 0;
		#20_000_000; //wait a short while for good unpress to process
		$stop();*/
		
		// GOOD PRESS FOLLOWED BY EARLY UNPRESS
		note_data[17:12] = 6'd9;
		note_data[11:0] = 12'd40;
		note_trigger = 1;
		#10;
		note_trigger = 0;
		#320_000_000; //wait 0.32sec (within window of press tolerance)
		key_data[6] = 1; //press
		key_data[5:0] = 6'd09; //correct key
		key_trigger = 1;
		#10;
		key_trigger = 0;
		#150_000_000; //release slightly early
		key_data[6] = 0; //unpress
		key_data[5:0] = 6'd09; // same key
		key_trigger = 1;
		#10;
		key_trigger = 0;
		#20_000_000; //wait a short while for good unpress to process
		$stop();	
		
	end
      
endmodule

