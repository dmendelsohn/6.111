`timescale 1ns / 1ps
module data_sprite_test;

	// Inputs
	reg clk;
	reg reset;
	reg tick;
	reg begin_write;
	reg stop_write;
	reg begin_read;
	reg stop_read;
	reg [17:0] tick_count;
	reg write_data;
	reg write_trigger;

	// Outputs
	wire [17:0] read_data_1;
	wire read_trigger_1;
	wire [17:0] read_data_2;
	wire read_trigger_2;
	
	//DEBUG OUTPUTS
//	wire [7:0] read_addr_1;
//	wire [7:0] read_addr_2;
//	wire en, we, clear;
//	wire [35:0] ram_data_out;
//	wire [7:0] ram_addr;
//	wire [1:0] addr_sel;

	// Instantiate the Unit Under Test (UUT)
	data_sprite uut (
		.clk(clk), 
		.reset(reset), 
		.tick(tick), 
		.begin_write(begin_write), 
		.stop_write(stop_write), 
		.begin_read(begin_read), 
		.stop_read(stop_read), 
		.tick_count(tick_count),
		/*//DEBUG
		.read_addr_1(read_addr_1),
		.read_addr_2(read_addr_2),
		.ram_data_out(ram_data_out),
		.en(en),
		.clear(clear),
		.we(we),
		.addr_sel(addr_sel),
		.ram_addr(ram_addr), */
		.write_data(write_data), 
		.write_trigger(write_trigger), 
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
	always #100 tick_count = tick_count + 1;

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;
		tick = 0;
		begin_write = 0;
		stop_write = 0;
		begin_read = 0;
		stop_read = 0;
		tick_count = 0;
		write_data = 0;
		write_trigger = 0;

		// Wait 100 ns for global reset to finish
		#100;
		reset = 1;
		#10;
		reset = 0;
      
		begin_read = 1;
		#10
		begin_read = 0;
		
		#60300; //should be enough time to see signal
		$stop();
	end
      
endmodule

