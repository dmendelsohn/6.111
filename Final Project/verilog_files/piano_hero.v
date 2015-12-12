`timescale 1ns / 1ps
module piano_hero(
    input clk,
    input reset,
    input up,
    input down,
    input right,
    input left,
    input [3:0] buttons,
    input [7:0] switches,
	 input [10:0] hcount,
	 input [9:0] vcount,
	 input raw_input,
	 //DEBUG
	 output tick,
	 //END DEBUG
    output [7:0] leds,
    output [63:0] hex_data,
    output [23:0] pixel
    );
	localparam LOOK_AHEAD_DISPLAY= 300;
	localparam LOOK_AHEAD_ACTION = 10;
	 
	wire key_enable;
	wire [7:0] key_data;
	wire [60:0] pressed;
	wire [60:0] scoring;
	wire [8:0] msg;
	wire msg_enable;
	//DEBUG	wire tick;
	wire [17:0] display_note_data, action_note_data;
	wire display_note_trigger, action_note_trigger;
	wire write_mode_switch, read_mode_switch, run_stop_switch;
	wire [17:0] score;
	
	assign write_mode_switch = switches[2];
	assign read_mode_switch = switches[1];
	assign run_stop_switch = switches[0];
	//assign hex_data = {46'b0,score};
	reg [31:0] display_note_latch;
	reg [31:0] tick_count;
	assign hex_data = {tick_count, display_note_latch};
	
	midi_block mb (.clk(clk),.reset(reset),.raw_input(raw_input),
							.enable(key_enable),.out(key_data));
				
	key_state temp (.clk(clk),.reset(reset),.in(key_data),
							.trigger(key_enable),.out(pressed));

	control_block #(.LOOK_AHEAD_1(LOOK_AHEAD_ACTION),.LOOK_AHEAD_2(LOOK_AHEAD_DISPLAY))
		cb (.clk(clk),.reset(reset),.key_data(key_data),.key_trigger(key_trigger),
				.read_mode_switch(read_mode_switch),.write_mode_switch(write_mode_switch),
				.run_stop_switch(run_stop_switch),.tick(tick),
				.display_note_data(display_note_data),
				.display_note_trigger(display_note_trigger),
				.action_note_data(action_note_data),
				.action_note_trigger(action_note_trigger));
				
	always @(posedge clk) begin
		if (reset) begin
			display_note_latch <= 0;
			tick_count <= 0;
		end
		else begin
			display_note_latch <= display_note_trigger ? display_note_data : display_note_latch;
			tick_count <= tick ? tick_count+1 : tick_count;
		end
	end
			
//	interpretation_block #(.LOOK_AHEAD(LOOK_AHEAD_ACTION))
//		ib (.clk(clk),.reset(reset),.key_data(key_data),.key_trigger(key_trigger),
//				.tick(tick),.msg(msg),.msg_enable(msg_enable),
//				.note_data(action_note_data),.note_trigger(action_note_trigger),
//				.pressed(pressed),.scoring(scoring),.score(score));
				
	graphics #(.LOOK_AHEAD(LOOK_AHEAD_DISPLAY))
		gr (.clk(clk),.reset(reset),.tick(tick),
				.scoring(scoring[60:0]),.pressed(pressed[60:0]),
				.note_data(display_note_data),.note_trigger(display_note_trigger),
				.hcount(hcount),.vcount(vcount),.pixel(pixel));
	
	
endmodule
