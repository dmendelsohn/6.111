`timescale 1ns / 1ps
module control_block_test;

	// Inputs
	reg clk;
	reg reset;
	reg [7:0] key_data;
	reg key_trigger;
	reg write_mode_switch;
	reg read_mode_switch;
	reg run_stop_switch;

	// Outputs
	wire tick;
	wire [17:0] display_note_data;
	wire display_note_trigger;
	wire [17:0] action_note_data;
	wire action_note_trigger;

	// Instantiate the Unit Under Test (UUT)
	control_block uut (
		.clk(clk), 
		.reset(reset), 
		.key_data(key_data), 
		.key_trigger(key_trigger), 
		.write_mode_switch(write_mode_switch), 
		.read_mode_switch(read_mode_switch), 
		.run_stop_switch(run_stop_switch), 
		.tick(tick), 
		.display_note_data(display_note_data), 
		.display_note_trigger(display_note_trigger), 
		.action_note_data(action_note_data),
		.action_note_trigger(action_note_trigger)
	);
	
	always #19 clk = ~clk;

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;
		key_data = 0;
		key_trigger = 0;
		write_mode_switch = 0;
		read_mode_switch = 0;
		run_stop_switch = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		reset = 1;
		#10;
		reset = 0;
		#100;
		read_mode_switch = 1;
		#100;
		run_stop_switch = 1;
		
		#240_000_000;
		
		$stop();
	end
      
endmodule

