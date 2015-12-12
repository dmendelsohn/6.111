`timescale 1ns / 1ps
module control_block #(parameter LOOK_AHEAD_1=10, parameter LOOK_AHEAD_2=300)
    (input clk,
    input reset,
    input [7:0] key_data,
    input key_trigger,
    input write_mode_switch,
    input read_mode_switch,
    input run_stop_switch,
    output tick,
    output [17:0] display_note_data,
    output display_note_trigger,
    output [17:0] action_note_data,
    output action_note_trigger
    );
	 
	 reg write_mode_switch_buff, read_mode_switch_buff;
	 reg write_mode_switch_delay, read_mode_switch_delay;
	 wire begin_read, begin_write,stop_read,stop_right;
	 assign begin_write = write_mode_switch_buff & ~write_mode_switch_delay;
	 assign stop_write = ~write_mode_switch_buff & write_mode_switch_delay;
	 assign begin_read = read_mode_switch_buff & ~read_mode_switch_delay;
	 assign stop_read = ~read_mode_switch_buff & read_mode_switch_delay;
	 
	 data_controller #(.LOOK_AHEAD_1(LOOK_AHEAD_1),.LOOK_AHEAD_2(LOOK_AHEAD_2))
			dc (.clk(clk),.reset(reset),.tick(tick),.begin_read(begin_read),
					.stop_read(stop_read),.begin_write(begin_write),
					.stop_write(stop_write),.write_data(key_data),
					.write_trigger(key_trigger),.read_data_1(action_note_data),
					.read_trigger_1(action_note_trigger),
					.read_data_2(display_note_data),
					.read_trigger_2(display_note_trigger));

	 tick_controller tc (.clk(clk),.reset(reset),
								.run_stop_switch(run_stop_switch),.tick(tick));
	 
	 initial begin
		write_mode_switch_buff = 0;
		write_mode_switch_delay = 0;
		read_mode_switch_buff = 0;
		read_mode_switch_delay = 0;
	end
	 
	 always @(posedge clk) begin
		if (reset) begin
			write_mode_switch_buff <= 0;
			write_mode_switch_delay <= 0;
			read_mode_switch_buff <= 0;
			read_mode_switch_delay <= 0;
		end
		else begin
			write_mode_switch_delay <= write_mode_switch_buff;
			read_mode_switch_delay <= read_mode_switch_buff;
			write_mode_switch_buff <= write_mode_switch;
			read_mode_switch_buff <= read_mode_switch;
		end
	end
endmodule
