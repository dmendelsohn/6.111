`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:09:11 10/17/2013 
// Design Name: 
// Module Name:    timer 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
`define DEFAULT_TIME 4'b1111
module timer(
    input one_hz,
    input start_timer,
    input [3:0] time_value,
    input clk,
    input reset,
    output reg sync,
    output expired,
    output reg [3:0] current_time
    );

	reg is_running;
	
	initial begin
		current_time = `DEFAULT_TIME;
		is_running = 0;
		sync = 0;
	end
	
	assign expired = (current_time == 0);
	
	always @(posedge clk) begin
		if (reset) begin
			current_time <= `DEFAULT_TIME;
			is_running <= 0;
			sync <= 0;
		end
		else if (start_timer) begin
			current_time <= time_value;
			sync <= 1;
			is_running <= 1;
		end
		else if (current_time == 0) begin
			current_time <= `DEFAULT_TIME;
			is_running <= 0;
			sync <= 0;
		end
		else if (is_running && one_hz) begin
			sync <= 0;
			current_time <= current_time - 1;
		end
	end
endmodule
