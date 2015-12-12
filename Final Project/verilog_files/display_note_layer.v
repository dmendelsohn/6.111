`timescale 1ns / 1ps
module display_note_layer #(
	parameter LOOK_AHEAD = 300, //3 second look ahead if tick is 10ms
	parameter Y_PRESS=10'd676,
	parameter WHITE_KEY_WIDTH=92,
	parameter BLACK_KEY_WIDTH=58,
	parameter X_MIN=11'd0,
	parameter Y_MIN=10'd0,
	parameter Y_MAX=10'd767,
	parameter BAD_COLOR_TABLE= //288 bit good bad lookup table
		288'hFF0000_FF0000_FF0000_FF0000_FF0000_FF0000_FF0000_FF0000_FF0000_FF0000_FF0000_FF0000,
	parameter GOOD_COLOR_TABLE= //288 bit good color lookup table
		288'h0000FF_0000FF_0000FF_0000FF_0000FF_0000FF_0000FF_0000FF_0000FF_0000FF_0000FF_0000FF
	)
    (input clk,
    input reset,
	 input tick,
    input [17:0] note_data,
    input note_trigger,
    input [60:0] scoring,
    input [10:0] hcount,
    input [9:0] vcount,
    output [23:0] pixel
    );
	localparam NUM_SPRITES = 16;
	localparam PADDING = 61 - NUM_SPRITES;
	
	wire [PADDING-1:0] zero_padding;
	assign zero_badding = 0;
	 
	wire [NUM_SPRITES-1:0] sprite_triggers;
	wire [NUM_SPRITES-1:0] sprites_free;
	wire [5:0] current_sprite;
	wire [NUM_SPRITES*24-1:0] pixel_table;

	genvar i; // It does not strictly need to be 61 sprites. Here is it's a convenience
	generate
		for (i = 0; i < NUM_SPRITES; i = i + 1) begin : NOTES
			note_sprite #(.LOOK_AHEAD(LOOK_AHEAD),.Y_PRESS(Y_PRESS),
								.WHITE_KEY_WIDTH(WHITE_KEY_WIDTH),
								.BLACK_KEY_WIDTH(BLACK_KEY_WIDTH),
								.X_MIN(X_MIN),.Y_MIN(Y_MIN),.Y_MAX(Y_MAX),
								.GOOD_COLOR_TABLE(GOOD_COLOR_TABLE),
								.BAD_COLOR_TABLE(BAD_COLOR_TABLE))
				nsprite (.clk(clk),.reset(reset),.tick(tick),
							.note_pitch(note_data[17:12]),
							.note_dur(note_data[11:0]),
							.note_trigger(sprite_triggers[i]),
							.scoring(scoring[60:0]),
							.hcount(hcount),.vcount(vcount),.free(sprites_free[i]),
							.pixel(pixel_table[24*i+:24]));
		end
	endgenerate
	
	genvar j;
	generate
		for (j = 0; j < NUM_SPRITES; j = j + 1) begin: TRIGGER
			assign sprite_triggers[j] = (current_sprite == j && note_trigger);
		end
	endgenerate

	combiner #(.WIDTH(24)) comb (.in(pixel_table),.out(pixel));
	priority_encoder_61_to_6 pe61to6 (.in({zero_padding,sprites_free}),
													.out(current_sprite));
	
endmodule
