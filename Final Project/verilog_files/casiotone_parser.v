`timescale 1ns / 1ps
module casiotone_parser(
    input clk,
    input [7:0] in,
    input trigger,
    input reset,
    output enable,
    output reg [7:0] out
    );

	localparam IDLE = 2'b00;
	localparam COMMAND = 2'b01;
	localparam PARAM_ONE = 2'b10;

	reg [1:0] state;
	reg [1:0] next_state;
	reg [7:0] param_one;
	reg valid;
	
	initial begin
		state = IDLE;
		next_state = IDLE;
		param_one = 0;
		out = 0;
		valid = 0;
	end
	
	always @(posedge clk) begin
		if (reset)
			state <= IDLE;
		else
			state <= next_state;
		//------------------------------------------------	
		if (state == IDLE && next_state == PARAM_ONE)
			param_one <= in;
		else if (state == PARAM_ONE && next_state == COMMAND) begin
			out[7] <= in[6];
			out[6:0] <= param_one-7'd36; //Shift key mapping so Middle C = 32, Leading 1 is note on
		end
	end
	
	always @* begin
		case(state)
			IDLE: next_state = trigger ? PARAM_ONE : IDLE;
			COMMAND: next_state = IDLE;
			PARAM_ONE: next_state = trigger ? (valid ? COMMAND : IDLE) : PARAM_ONE;
			default: next_state = IDLE;
		endcase
		case(state)
			COMMAND: valid = (in[7:4] == 0 || in[7:4] == 4);
			PARAM_ONE: valid = (param_one >= 36 && param_one <= 96);
			default: valid = 0;
		endcase
	end
	
	assign enable = (state == COMMAND && next_state == IDLE && valid);
endmodule
