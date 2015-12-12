`timescale 1ns / 1ps
module action_sprite #(parameter START_TICK=10,UNPRESS_TOLERANCE=20)
    (input clk,
    input reset,
    input tick,
    input key_trigger,
    input key_press,
    input note_trigger,
    input [11:0] note_dur,
    output reg [2:0] msg,
    output reg scoring,
    output reg msg_enable
    );
	 
	localparam PRESS_TOLERANCE = START_TICK;
	
	localparam GOOD_PRESS = 3'b000;
	localparam BAD_PRESS = 3'b001;
	localparam NO_PRESS = 3'b010;
	localparam GOOD_UNPRESS = 3'b011;
	localparam EARLY_UNPRESS = 3'b100;
	localparam LATE_UNPRESS = 3'b101;

	reg [11:0] duration, tick_count;
	reg running;
	
	initial begin
		msg = 0;
		scoring = 0;
		duration = 0;
		tick_count = 0;
		msg_enable = 0;
		running = 0;
	end
	
	always @(posedge clk) begin
		if (reset) begin
			msg <= 0;
			scoring <= 0;
			duration <= 0;
			tick_count <= 0;
			msg_enable <= 0;
			running <= 0;
		end
		else begin
			if (key_trigger) begin
				if (key_press) begin //key press event
					if (running && 
							tick_count >= START_TICK - PRESS_TOLERANCE &&
							tick_count < START_TICK + PRESS_TOLERANCE) begin
						msg_enable <= 1;
						msg <= GOOD_PRESS;
						scoring <= 1;
					end
					else begin
						msg_enable <= 1;
						msg <= BAD_PRESS;
						scoring <= 0;
					end
				end
				else if (scoring) begin //key unpress only relevant if scoring
					scoring <= 0;
					running <= 0;
					duration <= 0;
					tick_count <= 0;
					if (tick_count >= START_TICK + duration - UNPRESS_TOLERANCE &&
							tick_count < START_TICK + duration + UNPRESS_TOLERANCE) begin
						msg_enable <= 1;
						msg <= GOOD_UNPRESS;
					end
					else if (tick_count < START_TICK + duration - UNPRESS_TOLERANCE) begin
						msg_enable <= 1;
						msg <= EARLY_UNPRESS;
					end
					else
						msg_enable <= 0;
				end
			end
			else if (note_trigger) begin
				msg_enable <= 0; //make sure enable is off
				running <= 0;
				scoring <= 0;
				tick_count <= 1;
				duration <= note_dur;
			end
			else if (tick && running) begin
				tick_count <= tick_count + 1;
				if (~scoring && tick_count > (START_TICK + PRESS_TOLERANCE)) begin
					msg_enable <= 1;
					msg <= NO_PRESS;
					scoring <= 0;
					running <= 0;
					duration <= 0;
					tick_count <= 0;
				end
				else if (scoring && tick_count > (START_TICK + duration + UNPRESS_TOLERANCE)) begin
					msg_enable <= 1;
					msg <= LATE_UNPRESS;
					scoring <= 0;
					running <= 0;
					duration <= 0;
					tick_count <= 0;
				end
				else 
					msg_enable <= 0;
			end
			else begin
				msg_enable <= 0; //in case it was set high in the last cycle
			end
		end
	end
endmodule
