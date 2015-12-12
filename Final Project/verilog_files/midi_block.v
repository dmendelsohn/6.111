`timescale 1ns / 1ps
module midi_block(
    input raw_input,
    input clk,
    input reset,
    output enable,
    output [7:0] out
    );

	wire clean_input;
	wire trigger;
	wire [7:0] data_bus;
	
	synchronize sync (.clk(clk),.in(raw_input),.out(clean_input));
	uart u (.clk(clk),.reset(reset),.in(clean_input),
				.enable(trigger),.out(data_bus));
	casiotone_parser cp (.clk(clk),.reset(reset),.in(data_bus),
								.trigger(trigger),.enable(enable),.out(out));

endmodule
