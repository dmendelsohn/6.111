`timescale 1ns / 1ps
module key_state(
    input [7:0] in,
    input clk,
    input reset,
    input trigger,
    output reg [60:0] out
    );

	initial begin
		out = 0;
	end
	
	always @(posedge clk) begin
		if (reset)
			out <= 0;
		else if (trigger) begin
			out[in[5:0]] <= in[7];
		end
	end

endmodule
