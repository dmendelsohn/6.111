`timescale 1ns / 1ps
module data_controller_test;
	localparam NUM_KEYS = 13;
	// Inputs
	reg clk;
	reg reset;
	reg begin_write;
	reg stop_write;
	reg begin_read;
	reg stop_read;
	reg tick;
	reg [7:0] write_data;
	reg write_trigger;

	// Outputs
	wire [17:0] read_data_1;
	wire read_trigger_1;
	wire [17:0] read_data_2;
	wire read_trigger_2;
	
	//DEBUG Outputs
	wire [NUM_KEYS-1:0] sprite_read_triggers_2;
	wire [NUM_KEYS-1:0] sprite_read_triggers_buff_2;
	wire [NUM_KEYS*18-1:0] sprite_read_data_2;
	wire [5:0] current_read_2;
	wire [17:0] current_data_2;
	assign current_data_2 = sprite_read_data_2[18*current_read_2+:18];

	// Instantiate the Unit Under Test (UUT)
	data_controller #(.NUM_KEYS(13)) uut (
		.clk(clk), 
		.reset(reset), 
		.begin_write(begin_write), 
		.stop_write(stop_write), 
		.begin_read(begin_read), 
		.stop_read(stop_read), 
		.tick(tick), 
		.write_data(write_data), 
		.write_trigger(write_trigger),
		//DEBUG
		.sprite_read_triggers_2(sprite_read_triggers_2),
		.sprite_read_triggers_buff_2(sprite_read_triggers_buff_2),
		.sprite_read_data_2(sprite_read_data_2),
		.current_read_2(current_read_2),
		//END DEBUG
		.read_data_1(read_data_1), 
		.read_trigger_1(read_trigger_1), 
		.read_data_2(read_data_2), 
		.read_trigger_2(read_trigger_2)
	);

	always #5 clk = ~clk;
	always begin //tick is high for one out of ten cycles
		#90 tick = 1;
		#10 tick = 0;
	end
	
	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;
		begin_write = 0;
		stop_write = 0;
		begin_read = 0;
		stop_read = 0;
		tick = 0;
		write_data = 0;
		write_trigger = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		reset = 1;
		#10;
		reset = 0;
		
		begin_read = 1;
		#10;
		begin_read = 0;
		
		#60300 //wait for stuff to happen
		$stop();
	end
      
endmodule

