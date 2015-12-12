`timescale 1ns / 1ps
module ram_channel #(
	parameter WIDTH=36, 
	parameter HEIGHT=128, //must be at <= 2**ADDR_BITS
	parameter DEFAULT_DATA=0,
	parameter ADDR_BITS=7
	)
    (input clk,
    input reset,
    input en,
    input we,
	 input clear,
    input [ADDR_BITS-1:0] addr,
    input [WIDTH-1:0] write_data,
    output reg [WIDTH-1:0] read_data
    );
	//localparam CONST = {6'd2,12'd100,18'd320}; //TEST NOTE

	reg [WIDTH-1:0] memory[HEIGHT-1:0];
	integer i;
	
	initial begin
		read_data = 0;
	end

	always @(posedge clk) begin
		if (reset || clear) begin
			read_data <= 0;
			for (i = 0; i < HEIGHT; i = i+1) begin
				memory[i] <= DEFAULT_DATA[i*WIDTH+:WIDTH];
			end
		end
		else if (en) begin
			if (we) begin
				memory[addr] <= write_data;
			end
			read_data <= memory[addr];
		end
	end

endmodule
