`timescale 1ns / 1ps
module display_key_layer #(
	parameter X_EDGE_LEFT=11'd0,
	parameter Y_EDGE_BOTTOM=10'd767,
	parameter WHITE_KEY_WIDTH=28,
	parameter BLACK_KEY_WIDTH=16,
	parameter WHITE_KEY_HEIGHT=161,
	parameter BLACK_KEY_HEIGHT=101,
	parameter COLOR_DEFAULT_BLACK=24'h00_00_00,
	parameter COLOR_DEFAULT_WHITE=24'hFF_FF_FF,
	parameter BAD_COLOR_TABLE= //288 bit good bad lookup table
		288'hFF0000_FF0000_FF0000_FF0000_FF0000_FF0000_FF0000_FF0000_FF0000_FF0000_FF0000_FF0000,
	parameter GOOD_COLOR_TABLE= //288 bit good color lookup table
		288'h0000FF_0000FF_0000FF_0000FF_0000FF_0000FF_0000FF_0000FF_0000FF_0000FF_0000FF_0000FF
	)
   (input clk,
    input reset,
    input [60:0] pressed,
    input [60:0] scoring,
    input [10:0] hcount,
    input [9:0] vcount,
    output [23:0] pixel
    );

	wire [61*24-1:0] pixel_table;

	genvar i;
	generate
		for (i = 0; i < 61; i = i + 1) begin : KEYS
			key_sprite #(.PITCH(i),
								.X_EDGE_LEFT(X_EDGE_LEFT),.Y_EDGE_BOTTOM(Y_EDGE_BOTTOM),
								.WHITE_KEY_WIDTH(WHITE_KEY_WIDTH),.BLACK_KEY_WIDTH(BLACK_KEY_WIDTH),
								.WHITE_KEY_HEIGHT(WHITE_KEY_HEIGHT),.BLACK_KEY_HEIGHT(BLACK_KEY_HEIGHT),
								.COLOR_DEFAULT_BLACK(COLOR_DEFAULT_BLACK),
								.COLOR_DEFAULT_WHITE(COLOR_DEFAULT_WHITE),
								.GOOD_COLOR_TABLE(GOOD_COLOR_TABLE),.BAD_COLOR_TABLE(BAD_COLOR_TABLE))
				ksprite (.clk(clk),.reset(reset),
							.pressed(pressed[i]),.scoring(scoring[i]),
							.hcount(hcount),.vcount(vcount),
							.pixel(pixel_table[24*i+:24]));
		end
	endgenerate

	combiner #(.WIDTH(24)) comb (.in(pixel_table),.out(pixel));
endmodule
