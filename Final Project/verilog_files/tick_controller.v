`timescale 1ns / 1ps
module tick_controller #(parameter CYCLES = 270_000) //0.01sec w/ 27mhz clock
    (input clk,
    input reset,
    input run_stop_switch,
    output tick
    );
	 
  reg [23:0] count;
  
  initial begin
		count = 0;
	end

  always@(posedge clk) begin
	 if (reset)
		count <= 0;
	 else if (count == CYCLES)
		count <= 0;
	 else if (run_stop_switch)
		count <= count + 1;
  end
  
  assign tick = (count == CYCLES); 
endmodule
