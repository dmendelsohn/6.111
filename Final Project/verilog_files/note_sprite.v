`timescale 1ns / 1ps
module note_sprite #(
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
    input [5:0] note_pitch,
    input [11:0] note_dur,
    input note_trigger,
    input tick,
    input [60:0] scoring,
    input [10:0] hcount,
    input [9:0] vcount,
	 //DEBUG
	 output reg [11:0] tick_count,
	 //END DEBUG
    output reg free,
    output [23:0] pixel
    );
	 
	localparam BLACK_KEY_LUT = 12'b01010_0101010;
	localparam SLOT_OFFSET_TABLE = 48'h01122_3445566;
	
	//movement parameters
	localparam WINDOW_HEIGHT = Y_PRESS - Y_MIN;
	localparam MULTIPLIER_NUM = ((WINDOW_HEIGHT * 256) / LOOK_AHEAD);
	localparam MULTIPLIER_DIV_BITS = 8;
	
	reg [5:0] pitch; //stores the current pitch being processed.  Unspecified while idle.
	reg [11:0] dur;
	reg is_missed; //goes high if user misses the note
	//DEBUG reg [11:0] tick_count;

	//logical variables
	wire [3:0] tone;
	wire [2:0] octave;
	wire [5:0] slot;
	wire is_black_key;
	wire [3:0] index;
	assign index = (4'd11 - tone);
	
	assign tone = (pitch < 12 ? pitch :
						(pitch < 24 ? pitch - 12 :
						(pitch < 36 ? pitch - 24 :
						(pitch <  48 ? pitch - 36 :
						(pitch < 60 ? pitch - 48 : note_pitch - 60)))));
	assign octave = (note_pitch < 12 ? 0 :
						(note_pitch < 24 ? 1 :
						(note_pitch < 36 ? 2 :
						(note_pitch <  48 ? 3 :
						(note_pitch < 60 ? 4 : 5)))));
						
	assign slot = 7*octave + SLOT_OFFSET_TABLE[index];
	assign is_black_key = BLACK_KEY_LUT[index];


	// color variables
	wire [23:0] color_good;
	wire [23:0] color_bad;
	wire [23:0] current_color;
	
	assign color_good = GOOD_COLOR_TABLE[24*index+:24];
	assign color_bad = BAD_COLOR_TABLE[24*index+:24];
	assign current_color = is_missed ? color_bad : color_good;
	
	// position variables
	wire [10:0] note_x_low = X_MIN + WHITE_KEY_WIDTH*slot - (BLACK_KEY_WIDTH >> 1)*is_black_key;
	wire [10:0] note_x_high = note_x_low+ is_black_key*BLACK_KEY_WIDTH + (1-is_black_key)*WHITE_KEY_WIDTH;
	reg [12:0] note_y_low; //these vary tick to tick
	reg [12:0] note_y_high; //these vary tick to tick
	
	//Here is the rendering.
	assign pixel = (vcount >= note_y_low && vcount < note_y_high &&
							hcount >= note_x_low && hcount < note_x_high &&
							tick_count > 0) ? current_color : 24'b0;
	
	initial begin
		pitch = 0;
		dur = 0;
		free = 1;
		is_missed = 0;
		note_y_low = 0;
		note_y_high = 0;
		tick_count = 0;
	end
	
	always @(posedge clk) begin
		if (reset || (tick_count > LOOK_AHEAD + dur)) begin
			tick_count <= 0;
		end
		else if (note_trigger) begin
			tick_count <= 1;
		end
		else if (tick_count >= 1 && tick) begin
			tick_count <= tick_count + 1;
		end
	end
	
	always @* begin
		pitch = note_trigger ? note_pitch : pitch;
		dur = note_trigger ? note_dur : dur;
		free = (tick_count == 0) ? 1 : 0;
		is_missed = (tick_count==0 ? 0 : 
							((~scoring[pitch] && tick_count > LOOK_AHEAD) ? 1 : is_missed));
		note_y_low = (tick_count <= dur) ? Y_MIN : (((tick_count - dur) * MULTIPLIER_NUM) >> MULTIPLIER_DIV_BITS); 
		note_y_high = ((tick_count * MULTIPLIER_NUM) >> MULTIPLIER_DIV_BITS);
	end
endmodule
