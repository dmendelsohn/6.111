`timescale 1ns / 1ps
module data_sprite #(
		parameter LOOK_AHEAD_1=10, //how far ahead of tick_count read_data_1 should be.
		parameter LOOK_AHEAD_2=300, //how far ahead of tick_count read_data_2 should be.
		parameter PITCH=6'b0) //pitch will always be overwritten
    (input clk,
    input reset,
	 input tick,
    input begin_write,
	 input stop_write,
	 input begin_read,
	 input stop_read,
    input [17:0] tick_count,
    input write_data,
    input write_trigger,
	 //output [35:0] ram_data_out, //DEBUG
	 //output reg en, we, clear, //DEBUG
	 //output reg [7:0] read_addr_1, read_addr_2, //DEBUG
	 //output reg [7:0] ram_addr,
	 //output reg [1:0] addr_sel,
    output reg [17:0] read_data_1,
    output read_trigger_1,
    output reg [17:0] read_data_2,
    output read_trigger_2
    );
	 
	localparam IDLE = 2'b00;
	localparam WRITE_MODE = 2'b01;
	localparam READ_MODE = 2'b10;
	
	localparam DEFAULT_NOTE_1 = (PITCH == 2) ? 
			{6'd2,12'd70,18'd450}: 36'd0;
	localparam DEFAULT_NOTE_2 = 36'd0;
	localparam DEFAULT_NOTE_3 = 36'd0;
	localparam DEFAULT_NOTE_4 = 36'd0;
	localparam DEFAULT_DATA = {DEFAULT_NOTE_4,DEFAULT_NOTE_3,DEFAULT_NOTE_2,
											DEFAULT_NOTE_1};
	
	reg [1:0] state, next_state;

	//thse are for reading
	//DEBUG
	reg [7:0] read_addr_1;
	reg [7:0] read_addr_2;
	wire [35:0] ram_data_out;
	 
	//these are for writing
	reg [7:0] write_addr;
	reg [17:0] note_start;
	wire [11:0] note_len;
	reg [35:0] ram_data_in;

	assign note_len = tick_count - note_start;
	
	//these are for internal RAM control 
	reg en, we, clear;
	reg [7:0] ram_addr;
	reg [1:0] addr_sel; //0 is write_addr, 1 is read_addr_1, 2 is read_addr_2
	reg [2:0] seq;
	
	ram_channel #(.ADDR_BITS(8),.HEIGHT(4),.WIDTH(36), //only 4 notes per pitch, for testing
						.DEFAULT_DATA(DEFAULT_DATA))
		rc (.clk(clk),.reset(reset),.en(en),.we(we),.clear(clear),
			.addr(ram_addr),.write_data(ram_data_in),.read_data(ram_data_out));

	initial begin
		note_start = 0;
		write_addr = 0;
		read_addr_1 = 0;
		read_addr_2 = 0;
		ram_addr = 0;
		en = 0;
		we = 0;
		ram_data_in = 0;
		state = IDLE;
		next_state = IDLE;
	end
	 
	always @(posedge clk) begin
		if (reset) begin
			state <= 0;
		end
		else begin
			state <= next_state; //state and sequence logic
			if (tick)
				seq <= 1;
			else if (seq > 0)
				seq <= seq + 1;
				
			if (state == IDLE && next_state == WRITE_MODE) begin
				addr_sel <= 0; //we are in write_mode so we pick write_addr for ram
				write_addr <= 0; //we start the addr at 0
			end
			else if (state == WRITE_MODE && next_state == WRITE_MODE) begin
				if (write_trigger) begin
					if (~write_data) begin
						write_addr <= write_addr + 1; //increment the address
					end
				end
			end
			else if (state == WRITE_MODE && next_state == IDLE) begin
				write_addr <= 0; //Cleaning up.
			end
			else if (state == IDLE && next_state == READ_MODE) begin
				addr_sel <= 1; //read_1 is selected
				read_addr_1 <= 0;
				read_addr_2 <= 0;
			end
			else if (state == READ_MODE && next_state == READ_MODE) begin
				if (seq == 1) begin
					if (ram_data_out[17:0] == tick_count + LOOK_AHEAD_1) begin
						read_addr_1 <= read_addr_1 + 1; //found a note, so increment.
					end
					addr_sel <= 2; //give control over
				end
				else if (seq == 3) begin
					if (ram_data_out[17:0] == tick_count + LOOK_AHEAD_2) begin
						read_addr_2 <= read_addr_2 + 1; //found a note, so increment.
					end
					addr_sel <= 1; //give control over
				end
			end
			else if (state == READ_MODE && next_state == IDLE) begin
				read_addr_1 <= 0;
				read_addr_2 <= 0;
			end
		end
	end
	
	assign read_trigger_1 = (state == READ_MODE && next_state == READ_MODE &&
										seq == 1 && 
										ram_data_out[17:0] == tick_count + LOOK_AHEAD_1);
	assign read_trigger_2 = (state == READ_MODE && next_state == READ_MODE &&
										seq == 3 && 
										ram_data_out[17:0] == tick_count + LOOK_AHEAD_2);							
	 
	always @* begin
		case (state)
			IDLE: next_state = (begin_write ? WRITE_MODE : (begin_read ? READ_MODE : IDLE));
			WRITE_MODE: next_state = (stop_write ? IDLE : WRITE_MODE);
			READ_MODE: next_state = (stop_read ? IDLE : READ_MODE);
			default: next_state = IDLE;
		endcase
		case (state)
			WRITE_MODE: note_start = (write_trigger && write_data) ? tick_count : note_start;
			default: note_start = 0;
		endcase
		en = (state != IDLE);
		we = (state == WRITE_MODE && next_state == WRITE_MODE && write_trigger & write_data);
		clear = (state == IDLE && next_state == WRITE_MODE);
		ram_addr = ((addr_sel == 0) ? write_addr :
						((addr_sel == 1) ? read_addr_1 : read_addr_2));
		read_data_1 = ram_data_out[35:18];
		read_data_2 = ram_data_out[35:18];
		ram_data_in = {PITCH, note_len, tick_count};
	end

endmodule
