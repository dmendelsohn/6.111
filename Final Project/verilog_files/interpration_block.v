`timescale 1ns / 1ps
module interpretation_block #(parameter LOOK_AHEAD=10)
    (input clk,
    input reset,
    input tick,
    input key_trigger,
    input [7:0] key_data,
    input note_trigger,
    input [17:0] note_data,
    output [8:0] msg,
    output msg_enable,
	 output [60:0] pressed,
    output [60:0] scoring,
    output [17:0] score
    );

	key_state ks (.clk(clk),.reset(reset),.trigger(key_trigger),
						.in(key_data),.out(pressed));
	action_interpreter #(.START_TICK(LOOK_AHEAD))
			ai (.clk(clk),.reset(reset),.tick(tick),
									.key_trigger(key_trigger),
									.key_data({key_data[7],key_data[5:0]}),
									.note_trigger(note_trigger),.note_data(note_data),
									.msg(msg),.enable(msg_enable),.scoring(scoring));
	score sc (.clk(clk),.reset(reset),.tick(tick),.msg(msg),
					.msg_enable(msg_enable),.scoring(scoring),.score(score));

endmodule
