`timescale 1ns / 1ps
module graphics #(parameter LOOK_AHEAD = 300)
	 (input clk,
    input reset,
    input [60:0] scoring,
    input [60:0] pressed,
    input tick,
    input [17:0] note_data,
    input note_trigger,
    input [10:0] hcount,
    input [9:0] vcount,
    output [23:0] pixel
    );
	 
	localparam X_EDGE_LEFT = 11'd0;
	localparam Y_EDGE_BOTTOM = 10'd767;
	localparam WHITE_KEY_WIDTH = 28;
	localparam BLACK_KEY_WIDTH=16;
	localparam WHITE_KEY_HEIGHT=161;
	localparam BLACK_KEY_HEIGHT=101;
	localparam COLOR_DEFAULT_BLACK=24'h00_00_00;
	localparam COLOR_DEFAULT_WHITE=24'hFF_FF_FF;
	localparam BAD_COLOR_TABLE= //288 bit good bad lookup table
		288'hFF0000_FF0000_FF0000_FF0000_FF0000_FF0000_FF0000_FF0000_FF0000_FF0000_FF0000_FF0000;
	localparam GOOD_COLOR_TABLE= //288 bit good color lookup table
		288'h0000FF_0000FF_0000FF_0000FF_0000FF_0000FF_0000FF_0000FF_0000FF_0000FF_0000FF_0000FF;
		
	localparam X_MIN = X_EDGE_LEFT;
	localparam Y_MIN = 10'd0;
	localparam Y_MAX = Y_EDGE_BOTTOM;
	localparam Y_PRESS = Y_MAX - WHITE_KEY_HEIGHT;

	wire [23:0] key_pixel, note_pixel;
	
	display_key_layer #(.X_EDGE_LEFT(X_EDGE_LEFT),.Y_EDGE_BOTTOM(Y_EDGE_BOTTOM),
								.WHITE_KEY_WIDTH(WHITE_KEY_WIDTH),
								.BLACK_KEY_WIDTH(BLACK_KEY_WIDTH),
								.WHITE_KEY_HEIGHT(WHITE_KEY_HEIGHT),
								.BLACK_KEY_HEIGHT(BLACK_KEY_HEIGHT),
								.COLOR_DEFAULT_BLACK(COLOR_DEFAULT_BLACK),
								.COLOR_DEFAULT_WHITE(COLOR_DEFAULT_WHITE),
								.BAD_COLOR_TABLE(BAD_COLOR_TABLE),
								.GOOD_COLOR_TABLE(GOOD_COLOR_TABLE))
			dkl (.clk(clk),.reset(reset),.pressed(pressed),.scoring(scoring),
					.hcount(hcount),.vcount(vcount),.pixel(key_pixel));
	
	display_note_layer #(.LOOK_AHEAD(LOOK_AHEAD),.Y_PRESS(Y_PRESS),.Y_MIN(Y_MIN),
								.X_MIN(X_MIN),.Y_MAX(Y_MAX),
								.WHITE_KEY_WIDTH(WHITE_KEY_WIDTH),
								.BLACK_KEY_WIDTH(BLACK_KEY_WIDTH),
								.BAD_COLOR_TABLE(BAD_COLOR_TABLE),
								.GOOD_COLOR_TABLE(GOOD_COLOR_TABLE))
			dnl (.clk(clk),.reset(reset),.tick(tick),.note_data(note_data),
					.note_trigger(note_trigger),.scoring(scoring),
					.hcount(hcount),.vcount(vcount),.pixel(note_pixel));

	assign pixel = note_pixel | key_pixel;
//	assign pixel = key_pixel;

endmodule
