`timescale 1ns / 1ps
module action_interpreter #(parameter START_TICK = 12'd10)
   (input clk,
    input reset,
    input tick, //also serves as trigger for note_data
    input key_trigger,
    input [6:0] key_data,
	 input note_trigger,
    input [17:0] note_data, //6 pitch bits, 12 duration bits
    output reg [8:0] msg, //3 bits specify type, last 6 specify pitch
	 output wire [60:0] scoring,
    output reg enable
    );
	localparam PRESS_TOLERANCE = START_TICK; //ten tick tolerance, note binding to START_TICK
	localparam UNPRESS_TOLERANCE = 20; //twenty tick tolerance
	
	wire [60:0] sprite_key_triggers;
	wire [60:0] sprite_note_triggers;
	wire [61*3-1:0] sprite_msgs;
	wire [60:0] sprite_enables;
	
	reg [60:0] sprite_enables_buff;
	
	genvar i;
	generate
		for (i = 0; i < 61; i=i+1) begin : ACTION_SPRITE
			action_sprite #(.START_TICK(START_TICK),
									.UNPRESS_TOLERANCE(UNPRESS_TOLERANCE))
				as (.clk(clk),.reset(reset),.tick(tick),
						.key_trigger(sprite_key_triggers[i]),
						.note_trigger(sprite_note_triggers[i]),
						.key_press(key_data[6]),.note_dur(note_data[11:0]),
						.scoring(scoring[i]),.msg(sprite_msgs[3*i+:3]),
						.msg_enable(sprite_enables[i]));	
		end
	endgenerate
	
	genvar j;
	generate
		for (j = 0; j < 61; j=j+1) begin : TRIGS
			assign sprite_key_triggers[j] = (key_trigger && j == key_data[5:0]);
			assign sprite_note_triggers[j] = (note_trigger && j == note_data[17:12]);
		end
	endgenerate

	wire [5:0] current_pitch;
	priority_encoder_61_to_6 pe (.in(sprite_enables_buff[60:0]),
											.out(current_pitch));

	initial begin
		msg = 0;
		enable = 0;
		sprite_enables_buff = 0;
	end

	always @(posedge clk) begin
		if (reset) begin
			sprite_enables_buff <= 0;
			msg <= 0;
			enable <= 0;
		end
		else begin
			if (sprite_enables != 0) begin
				enable <= 0;
				sprite_enables_buff <= sprite_enables_buff | sprite_enables;
			end
			else if (sprite_enables_buff != 0) begin //process something!
				enable <= 1;
				msg <= sprite_msgs[3*current_pitch+:3];
				sprite_enables_buff[current_pitch] <= 0;
			end
			else begin
				enable <= 0;
			end
		end
	end
endmodule
