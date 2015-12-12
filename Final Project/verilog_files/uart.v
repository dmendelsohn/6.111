`timescale 1ns / 1ps
module uart(
    input in,
    input clk,
    input reset,
    output wire enable,
    output reg [7:0] out
    );

	localparam IDLE = 2'b00;
	localparam START = 2'b01;
	localparam BIT = 2'b10;
	
	reg [1:0] state;
	reg [1:0] next_state;
	reg [2:0] cur_bit;
	wire expired;
	
	divider_32us d (.clk(clk),.reset(reset),.enable(expired));
	
	initial begin
		state = IDLE;
		next_state = IDLE;
		out = 0;
		cur_bit = 0;
	end
	
	always @(posedge clk) begin
		if (next_state == BIT && expired) begin
			out[cur_bit] <= in;
			cur_bit <= cur_bit + 1;
		end
		if (reset) begin
			state <= IDLE;
			cur_bit <= 0;
			out <= 0;
		end
		else
			state <= next_state;
	end

	always @* begin
		case(state)
			IDLE: next_state = (expired && ~in) ? START : IDLE;
			START: next_state = expired ? BIT : START;
			BIT: next_state = (expired && cur_bit == 0) ? IDLE : BIT;
			default: next_state = IDLE;
		endcase
	end
	
	assign enable = (state == BIT) && (next_state == IDLE);
endmodule
