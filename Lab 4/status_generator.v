`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:53:58 10/17/2013 
// Design Name: 
// Module Name:    status_generator 
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
module status_generator(
    input clk, reset,
	 input [1:0] status,
    output reg power
    );

	reg state;
	wire one_hz;
	divider d(.sync(0),.clk(clk),.reset(reset),.out_sig(one_hz));
	
	always @(posedge clk) begin
		if (one_hz)
			state <= ~state;
		case(status)
			0: power <= 0;
			1: power <= 1;
			2: power <= state;
			default: power <= 0;
		endcase
	end
endmodule
