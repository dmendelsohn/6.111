`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:15:40 10/17/2013 
// Design Name: 
// Module Name:    anti_theft_fsm 
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
`define ARMED_STATE 3'd0
`define TRIGGER_STATE 3'd1
`define SOUND_STATE_0 3'd2
`define SOUND_STATE_1 3'd3
`define DISARMED_STATE_0 3'd4
`define DISARMED_STATE_1 3'd5
`define DISARMED_STATE_2 3'd6

`define PARAM_ARM_DELAY 2'b00
`define PARAM_DRIVER_DELAY 2'b01
`define PARAM_PASSENGER_DELAY 2'b10
`define PARAM_ALARM_ON 2'b11

module anti_theft_fsm(
    input ignition,
    input driver,
    input passenger,
    input reprogram,
    input expired,
    input clk,
    input reset,
    output reg [1:0] interval,
    output reg start_timer,
    output reg siren,
    output reg [1:0] status,
    output reg [2:0] state
    );
	 
	reg driver_delayed = 0;
	wire driver_falling = !driver && driver_delayed;
	 
	initial begin
		status = 0;
		interval = 2'b00;
		start_timer = 0;
		siren = 0;
		state = `ARMED_STATE;
	end

	always @(posedge clk) begin
		driver_delayed <= driver;
		if (reprogram || reset) begin
			start_timer <= 0;
			siren <= 0;
			status <= 2'b00;
			state <= `ARMED_STATE;
			interval = 0;
		end
		case (state)
			`ARMED_STATE: begin
				status <= 2;
				siren <= 0;
				if (ignition)
					state <= `DISARMED_STATE_0;
				else if (driver) begin
					interval = `PARAM_DRIVER_DELAY;
					start_timer <= 1;
					state <= `TRIGGER_STATE;
				end
				else if (passenger) begin
					interval = `PARAM_PASSENGER_DELAY;
					start_timer <= 1;
					state <= `TRIGGER_STATE;
				end
			end
			`TRIGGER_STATE: begin
				start_timer <= 0;
				status <= 1;
				siren <= 0;
				if (ignition)
					state <= `DISARMED_STATE_0;
				else if (expired) begin
					state <= `SOUND_STATE_0;
				end
			end
			`SOUND_STATE_0: begin
				siren <= 1;
				status <= 1;
				interval = `PARAM_ALARM_ON;
				if (ignition)
					state <= `DISARMED_STATE_0;
				else if (~driver && ~passenger) begin
					start_timer <= 1;
					state <= `SOUND_STATE_1;
				end
			end
			`SOUND_STATE_1: begin
				siren <= 1;
				status <= 1;
				start_timer <= 0;
				if (ignition)
					state <= `DISARMED_STATE_0;
				else if (driver || passenger)
					state <= `SOUND_STATE_0;
				if (expired)
					state <= `ARMED_STATE;
			end
			`DISARMED_STATE_0: begin
				status <= 0;
				siren <= 0;
				if (~ignition)
					state <= `DISARMED_STATE_1;
			end
			`DISARMED_STATE_1: begin
				interval = `PARAM_ARM_DELAY;
				if (driver_falling) begin
					start_timer <= 1;
					state <= `DISARMED_STATE_2;
				end
			end
			`DISARMED_STATE_2: begin
				start_timer <= 0;
				if (driver || passenger)
					state <= `DISARMED_STATE_1;
				else if (expired)
					state <= `ARMED_STATE;
			end
			default: begin
				start_timer <= 0;
				siren <= 0;
				status <= 2'b00;
				state <= `ARMED_STATE;
			end
		endcase
	end
endmodule
