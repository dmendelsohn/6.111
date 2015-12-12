`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:13:31 10/17/2013 
// Design Name: 
// Module Name:    fuel_pump 
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
module fuel_pump(
    input brake,
    input hidden,
    input ignition,
    input clk,
    input reset,
    output reg power
    );

	always @(posedge clk) begin
		if (reset)
			power <= 0;
		else if (power == 1) begin
			if (~ignition)
				power <= 0;
		end
		else begin
			if (ignition && brake && hidden)
				power <= 1;
		end
	end
endmodule
