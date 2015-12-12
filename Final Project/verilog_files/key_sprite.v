`timescale 1ns / 1ps
module key_sprite #(
	parameter PITCH=0, //This one will always be overridden
	parameter X_EDGE_LEFT=11'd0,
	parameter Y_EDGE_BOTTOM=10'd767,
	parameter WHITE_KEY_WIDTH=16,
	parameter BLACK_KEY_WIDTH=8,
	parameter WHITE_KEY_HEIGHT=92,
	parameter BLACK_KEY_HEIGHT=58,
	parameter COLOR_DEFAULT_BLACK=24'h00_00_00,
	parameter COLOR_DEFAULT_WHITE=24'hFF_FF_FF,
	parameter BAD_COLOR_TABLE= //288 bit good bad lookup table
		288'hFF0000_FF0000_FF0000_FF0000_FF0000_FF0000_FF0000_FF0000_FF0000_FF0000_FF0000_FF0000,
	parameter GOOD_COLOR_TABLE= //288 bit good color lookup table
		288'h0000FF_0000FF_0000FF_0000FF_0000FF_0000FF_0000FF_0000FF_0000FF_0000FF_0000FF_0000FF
	)
    (input clk,
    input reset,
    input pressed,
    input scoring,
	 input [10:0] hcount,
	 input [9:0] vcount,
    output [23:0] pixel
    );
	 
	//key types
	localparam TYPE_BLACK = 2'd0;
	localparam TYPE_FORWARD_L = 2'd1;
	localparam TYPE_BACKWARD_L = 2'd2;
	localparam TYPE_MIDDLE_WHITE = 2'd3;
	
	//LUTs
	localparam SLOT_OFFSET_TABLE = 48'h01122_3445566;
	localparam KEY_TYPE_TABLE = 24'b01_00_11_00_10__01_00_11_00_11_00_10;
	
	// logical parameters
	localparam OCTAVE = PITCH/12;
	localparam TONE = PITCH%12;
	localparam INDEX = 11 - TONE;
	localparam MY_TYPE = KEY_TYPE_TABLE[2*INDEX+:2];
	localparam SLOT = 7*OCTAVE + SLOT_OFFSET_TABLE[4*INDEX+:4];
	localparam IS_BLACK_KEY = (MY_TYPE == TYPE_BLACK);
	localparam HAS_LEFT_CUT = (MY_TYPE == TYPE_MIDDLE_WHITE || MY_TYPE == TYPE_BACKWARD_L);
	localparam HAS_RIGHT_CUT = ((MY_TYPE == TYPE_MIDDLE_WHITE || MY_TYPE == TYPE_FORWARD_L) && PITCH != 61);
	
	// position parameters
	localparam MAIN_X_LOW = X_EDGE_LEFT + WHITE_KEY_WIDTH*SLOT - IS_BLACK_KEY*BLACK_KEY_WIDTH/2;
	localparam MAIN_Y_LOW = Y_EDGE_BOTTOM - WHITE_KEY_HEIGHT;
	localparam MAIN_HEIGHT = IS_BLACK_KEY*BLACK_KEY_HEIGHT + (1-IS_BLACK_KEY)*WHITE_KEY_HEIGHT;
	localparam MAIN_WIDTH = IS_BLACK_KEY*BLACK_KEY_WIDTH + (1-IS_BLACK_KEY)*WHITE_KEY_WIDTH;

	localparam LEFT_CUT_X_LOW = MAIN_X_LOW;
	localparam LEFT_CUT_Y_LOW = MAIN_Y_LOW;
	localparam LEFT_CUT_HEIGHT = BLACK_KEY_HEIGHT;
	localparam LEFT_CUT_WIDTH = BLACK_KEY_WIDTH/2;

	localparam RIGHT_CUT_X_LOW = MAIN_X_LOW + WHITE_KEY_WIDTH - BLACK_KEY_WIDTH/2;
	localparam RIGHT_CUT_Y_LOW = MAIN_Y_LOW;
	localparam RIGHT_CUT_HEIGHT = BLACK_KEY_HEIGHT;
	localparam RIGHT_CUT_WIDTH = BLACK_KEY_WIDTH/2;

	// define "correct press" color
	localparam COLOR_GOOD = GOOD_COLOR_TABLE[24*INDEX+:24];
	localparam COLOR_BAD = BAD_COLOR_TABLE[24*INDEX+:24];
	localparam COLOR_DEFAULT = IS_BLACK_KEY*COLOR_DEFAULT_BLACK + (1-IS_BLACK_KEY)*COLOR_DEFAULT_WHITE;
	
	wire is_in_main;
	wire is_in_left_cut;
	wire is_in_right_cut;
	wire is_in_key;
	
	wire [23:0] current_color;
	
	assign is_in_main = 
		(vcount >= MAIN_Y_LOW && vcount < MAIN_Y_LOW + MAIN_HEIGHT &&
		hcount >= MAIN_X_LOW && hcount < MAIN_X_LOW + MAIN_WIDTH);
		
	assign is_in_left_cut = 
		(vcount >= LEFT_CUT_X_LOW && vcount < LEFT_CUT_Y_LOW + LEFT_CUT_HEIGHT &&
		hcount >= LEFT_CUT_X_LOW && hcount < LEFT_CUT_X_LOW + LEFT_CUT_WIDTH);
		
	assign is_in_right_cut = 
		(vcount >= RIGHT_CUT_Y_LOW && vcount < RIGHT_CUT_Y_LOW + RIGHT_CUT_HEIGHT &&
		hcount >= RIGHT_CUT_X_LOW && hcount < RIGHT_CUT_X_LOW + RIGHT_CUT_WIDTH);
	
	assign current_color = (scoring ? COLOR_GOOD : (pressed ? COLOR_BAD : COLOR_DEFAULT));
	
	assign pixel = (!is_in_main || 
						(is_in_left_cut && HAS_LEFT_CUT) || 
						(is_in_right_cut && HAS_RIGHT_CUT)) ? 0 : current_color; //set the pixel!

endmodule
