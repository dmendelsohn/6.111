`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:25:14 10/17/2013 
// Design Name: 
// Module Name:    siren_generator 
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
`define HIGH_PITCH_DELAY 19286			//700 Hz
`define LOW_PITCH_DELAY 33750				//400 Hz
`define PITCH_CHANGE_DELAY 27000000		//switch pitch every second
module siren_generator(
    input clk,
    input reset,
    input on,
    output sound,
    output reg pitch_state
    );
	reg zero = 0;
	wire high_pitch_trig, low_pitch_trig, pitch_change_trig;
	reg maybe_sound;
	divider #(.DELAY(`HIGH_PITCH_DELAY))
		high(.sync(zero),.reset(reset),.clk(clk),.out_sig(high_pitch_trig));
	divider #(.DELAY(`LOW_PITCH_DELAY))
		low(.sync(zero),.reset(reset),.clk(clk),.out_sig(low_pitch_trig));
	divider #(.DELAY(`PITCH_CHANGE_DELAY))
		change(.sync(zero),.reset(reset),.clk(clk),.out_sig(pitch_change_trig));
		
	always @(posedge clk) begin
		if ((pitch_state && high_pitch_trig) || (~pitch_state && low_pitch_trig))
			maybe_sound = ~maybe_sound;
		if (pitch_change_trig)
			pitch_state = ~pitch_state;
	end
	
	assign sound = maybe_sound && on;
endmodule
