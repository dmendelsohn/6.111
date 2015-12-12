`timescale 1ns / 1ps
module data_controller #(
		parameter LOOK_AHEAD_1=10, //how far ahead of tick_count read_data_1 should be.
		parameter LOOK_AHEAD_2=300, //how far ahead of tick_count read_data_2 should be.
		parameter NUM_KEYS=13) //how many keys we're trying to do
    (input clk,
    input reset,
    input begin_write,
	 input stop_write,
	 input begin_read,
	 input stop_read,
    input tick,
    input [7:0] write_data,
	 input write_trigger,
	 /*//DEBUG
	 output [NUM_KEYS-1:0] sprite_read_triggers_2,
	 output reg [NUM_KEYS-1:0] sprite_read_triggers_buff_2,
	 output [NUM_KEYS*18-1:0] sprite_read_data_2,
	 output [5:0] current_read_2,
	 *///END DEBUG
    output [17:0] read_data_1,
    output read_trigger_1,
    output [17:0] read_data_2,
    output read_trigger_2
    );
	localparam NUM_UNKEYS = 61 - NUM_KEYS;
	
	wire [NUM_UNKEYS-1:0] zero_buff = 0; 
	wire [NUM_KEYS-1:0] sprite_write_triggers;
	wire [NUM_KEYS-1:0] sprite_read_triggers_1;
	wire [NUM_KEYS-1:0] sprite_read_triggers_2;
	reg [NUM_KEYS-1:0] sprite_read_triggers_buff_1;
	reg [NUM_KEYS-1:0] sprite_read_triggers_buff_2;
	wire [NUM_KEYS*18-1:0] sprite_read_data_1;
	wire [NUM_KEYS*18-1:0] sprite_read_data_2;
	wire [5:0] current_read_1;
	wire [5:0] current_read_2;
	
	reg [17:0] tick_count;
	reg running;
	
	genvar i;
	generate
		for (i = 0; i < NUM_KEYS; i = i + 1) begin : KEYS //CUTTING DOWN ON SPRITES
			data_sprite #(.LOOK_AHEAD_1(LOOK_AHEAD_1),
								.LOOK_AHEAD_2(LOOK_AHEAD_2),
								.PITCH(i))
				dsprite (.clk(clk),.reset(reset),.tick(tick),
							.begin_read(begin_read),.stop_read(stop_read),
							.begin_write(begin_write),.stop_write(stop_write),
							.write_data(write_data[7]),
							.write_trigger(sprite_write_triggers[i]),
							.read_trigger_1(sprite_read_triggers_1[i]),
							.read_trigger_2(sprite_read_triggers_2[i]),
							.read_data_1(sprite_read_data_1[18*i+:18]),
							.read_data_2(sprite_read_data_2[18*i+:18]),
							.tick_count(tick_count));
		end
	endgenerate
	
	genvar j;
	generate
		for (j = 0; j < NUM_KEYS; j = j + 1) begin : WRITE_TRIGGERS
			assign sprite_write_triggers[j] = (write_trigger && write_data[5:0] == j);
		end
	endgenerate
	
	assign read_data_1 = sprite_read_data_1[18*current_read_1+:18];
	assign read_data_2 = sprite_read_data_2[18*current_read_2+:18];
	assign read_trigger_1 = (sprite_read_triggers_buff_1 != 0 && sprite_read_triggers_1 == 0);
	assign read_trigger_2 = (sprite_read_triggers_buff_2 != 0 && sprite_read_triggers_2 == 0);


	priority_encoder_61_to_6 pe1 (.in({zero_buff,sprite_read_triggers_buff_1}),
											.out(current_read_1));
											
	priority_encoder_61_to_6 pe2 (.in({zero_buff,sprite_read_triggers_buff_2}),
											.out(current_read_2));
	
	initial begin
		running = 0;
		tick_count = 0;
		sprite_read_triggers_buff_1 = 0;
		sprite_read_triggers_buff_2 = 0;
	end
	
	always @(posedge clk) begin
		if (reset) begin
			tick_count <= 0;
		end
		else begin
			if (running) begin
				if (tick) begin
					tick_count <= tick_count + 1;
				end
			end
			else begin
				tick_count <= 0;
			end
			
			if (sprite_read_triggers_1 != 0) begin
				sprite_read_triggers_buff_1 <= 
					(sprite_read_triggers_buff_1 | sprite_read_triggers_1);
			end
			else if (sprite_read_triggers_buff_1 != 0) begin
				sprite_read_triggers_buff_1[current_read_1] <= 0; //concurrently being used
			end
			
			if (sprite_read_triggers_2 != 0) begin
				sprite_read_triggers_buff_2 <=
					(sprite_read_triggers_buff_2 | sprite_read_triggers_2);
			end
			else if (sprite_read_triggers_buff_2 != 0) begin
				sprite_read_triggers_buff_2[current_read_2] <= 0;
			end
		end
	end
	
	always @* begin
		running = ((begin_read || begin_write) ? 1 :
						((stop_read || stop_write) ? 0 : running));
	end
endmodule
