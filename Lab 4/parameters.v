`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:12:33 10/17/2013 
// Design Name: 
// Module Name:    parameters 
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
`define T_ARM_DELAY_DEF 4'b0110
`define T_DRIVER_DELAY_DEF 4'b1000
`define T_PASSENGER_DELAY_DEF 4'b1111
`define T_ALARM_ON_DEF 4'b1010
module parameters(
    input reprogram,
    input [1:0] sel,
    input [1:0] interval,
    input [3:0] time_value,
    input clk,
    input reset,
    output [3:0] value,
    output reg [15:0] params
    );
	 
	initial begin
		params = {`T_ALARM_ON_DEF,`T_PASSENGER_DELAY_DEF,
					`T_DRIVER_DELAY_DEF,`T_ARM_DELAY_DEF};
	end

	assign value = params[4*interval+:4];
	
	always @(posedge clk) begin
		if (reset) begin
			params <= {`T_ALARM_ON_DEF,`T_PASSENGER_DELAY_DEF,
					`T_DRIVER_DELAY_DEF,`T_ARM_DELAY_DEF};
		end
		else if (reprogram) begin
			params[4*sel+3] <= time_value[3];
			params[4*sel+2] <= time_value[2];
			params[4*sel+1] <= time_value[1];
			params[4*sel] <= time_value[0];
		end
	end
endmodule
