`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:06:19 10/17/2013 
// Design Name: 
// Module Name:    divider 
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
`define DEFAULT_DELAY 32'd27_000_000 //1 second on a 27Mhz clock
module divider #(parameter DELAY=`DEFAULT_DELAY)(
    input clk,
    input reset,
    input sync,
    output out_sig
    );

	reg [31:0] counter;

	initial begin
		counter = DELAY;
	end
	
	assign out_sig = (counter == 0);
	
	always @(posedge clk) begin
		if (reset || sync)
			counter <= DELAY;
		else if (counter > 0)
			counter <= counter - 1;
		else
			counter <= DELAY;
	end
endmodule
