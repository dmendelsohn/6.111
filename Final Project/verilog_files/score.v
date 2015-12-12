`timescale 1ns / 1ps
module score(
    input clk,
    input reset,
    input tick,
    input [60:0] scoring,
    input [8:0] msg,
    input msg_enable,
    output reg [17:0] score
    );
	 
	localparam GOOD_PRESS = 3'b000;
	localparam BAD_PRESS = 3'b001;
	localparam NO_PRESS = 3'b010;
	localparam GOOD_UNPRESS = 3'b011;
	localparam EARLY_UNPRESS = 3'b100;
	localparam LATE_UNPRESS = 3'b101;
	 
	localparam SCORE_PER_TICK = 1;
	localparam GOOD_PRESS_DELTA = 200;
	localparam BAD_PRESS_DELTA = 200;
	localparam NO_PRESS_DELTA = 400;
	localparam GOOD_UNPRESS_DELTA = 200;
	localparam EARLY_UNPRESS_DELTA = 0;
	localparam LATE_UNPRESS_DELTA = 0;

	wire [5:0] tally; //holds number of 1 in "scoring" buffer
	bit_counter bc (.in(scoring),.out(tally));
	
	initial begin
		score = 0;
	end
	
	always @(posedge clk) begin
		if (reset) begin
			score <= 0;
		end
		else if (msg_enable) begin
			case(msg[8:6])
				GOOD_PRESS: score <= score + GOOD_PRESS_DELTA;
				BAD_PRESS: score <= score - BAD_PRESS_DELTA;
				NO_PRESS: score <= score - NO_PRESS_DELTA;
				GOOD_UNPRESS: score <= score + GOOD_UNPRESS_DELTA;
				LATE_UNPRESS: score <= score - LATE_UNPRESS_DELTA;
				EARLY_UNPRESS: score <= score - EARLY_UNPRESS_DELTA;
				default: score <= score;
			endcase
		end
		else if (tick) begin
			score <= score + tally*SCORE_PER_TICK;
		end
	end
endmodule
