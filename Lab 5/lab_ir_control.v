`default_nettype none

///////////////////////////////////////////////////////////////////////////////
//
// 6.111 Remote Control Transmitter Module V2.1
//
// Created: February 29, 2009
// Author: Adam Lerer,
// Updated GPH October 6, 2010 
//     - fixed 40Khz modulation, repeat commands exaclty every 45ms. 
//
///////////////////////////////////////////////////////////////////////////////
//
// 6.111 FPGA Labkit -- Template Toplevel Module
//
// For Labkit Revision 004
//
//
// Created: October 31, 2004, from revision 003 file
// Author: Nathan Ickes
//
///////////////////////////////////////////////////////////////////////////////
//
// CHANGES FOR BOARD REVISION 004
//
// 1) Added signals for logic analyzer pods 2-4.
// 2) Expanded "tv_in_ycrcb" to 20 bits.
// 3) Renamed "tv_out_data" to "tv_out_i2c_data" and "tv_out_sclk" to
//    "tv_out_i2c_clock".
// 4) Reversed disp_data_in and disp_data_out signals, so that "out" is an
//    output of the FPGA, and "in" is an input.
//
// CHANGES FOR BOARD REVISION 003
//
// 1) Combined flash chip enables into a single signal, flash_ce_b.
//
// CHANGES FOR BOARD REVISION 002
//
// 1) Added SRAM clock feedback path input and output
// 2) Renamed "mousedata" to "mouse_data"
// 3) Renamed some ZBT memory signals. Parity bits are now incorporated into 
//    the data bus, and the byte write enables have been combined into the
//    4-bit ram#_bwe_b bus.
// 4) Removed the "systemace_clock" net, since the SystemACE clock is now
//    hardwired on the PCB to the oscillator.
//
///////////////////////////////////////////////////////////////////////////////
//
// Complete change history (including bug fixes)
//
// 2006-Mar-08: Corrected default assignments to "vga_out_red", "vga_out_green"
//              and "vga_out_blue". (Was 10'h0, now 8'h0.)
//
// 2005-Sep-09: Added missing default assignments to "ac97_sdata_out",
//              "disp_data_out", "analyzer[2-3]_clock" and
//              "analyzer[2-3]_data".
//
// 2005-Jan-23: Reduced flash address bus to 24 bits, to match 128Mb devices
//              actually populated on the boards. (The boards support up to
//              256Mb devices, with 25 address lines.)
//
// 2004-Oct-31: Adapted to new revision 004 board.
//
// 2004-May-01: Changed "disp_data_in" to be an output, and gave it a default
//              value. (Previous versions of this file declared this port to
//              be an input.)
//
// 2004-Apr-29: Reduced SRAM address busses to 19 bits, to match 18Mb devices
//              actually populated on the boards. (The boards support up to
//              72Mb devices, with 21 address lines.)
//
// 2004-Apr-29: Change history started
//
///////////////////////////////////////////////////////////////////////////////

module labkit (beep, audio_reset_b, ac97_sdata_out, ac97_sdata_in, ac97_synch,
	       ac97_bit_clock,
	       
	       vga_out_red, vga_out_green, vga_out_blue, vga_out_sync_b,
	       vga_out_blank_b, vga_out_pixel_clock, vga_out_hsync,
	       vga_out_vsync,

	       tv_out_ycrcb, tv_out_reset_b, tv_out_clock, tv_out_i2c_clock,
	       tv_out_i2c_data, tv_out_pal_ntsc, tv_out_hsync_b,
	       tv_out_vsync_b, tv_out_blank_b, tv_out_subcar_reset,

	       tv_in_ycrcb, tv_in_data_valid, tv_in_line_clock1,
	       tv_in_line_clock2, tv_in_aef, tv_in_hff, tv_in_aff,
	       tv_in_i2c_clock, tv_in_i2c_data, tv_in_fifo_read,
	       tv_in_fifo_clock, tv_in_iso, tv_in_reset_b, tv_in_clock,

	       ram0_data, ram0_address, ram0_adv_ld, ram0_clk, ram0_cen_b,
	       ram0_ce_b, ram0_oe_b, ram0_we_b, ram0_bwe_b, 

	       ram1_data, ram1_address, ram1_adv_ld, ram1_clk, ram1_cen_b,
	       ram1_ce_b, ram1_oe_b, ram1_we_b, ram1_bwe_b,

	       clock_feedback_out, clock_feedback_in,

	       flash_data, flash_address, flash_ce_b, flash_oe_b, flash_we_b,
	       flash_reset_b, flash_sts, flash_byte_b,

	       rs232_txd, rs232_rxd, rs232_rts, rs232_cts,

	       mouse_clock, mouse_data, keyboard_clock, keyboard_data,

	       clock_27mhz, clock1, clock2,

	       disp_blank, disp_data_out, disp_clock, disp_rs, disp_ce_b,
	       disp_reset_b, disp_data_in,

	       button0, button1, button2, button3, button_enter, button_right,
	       button_left, button_down, button_up,

	       switch,

	       led,
	       
	       user1, user2, user3, user4,
	       
	       daughtercard,

	       systemace_data, systemace_address, systemace_ce_b,
	       systemace_we_b, systemace_oe_b, systemace_irq, systemace_mpbrdy,
	       
	       analyzer1_data, analyzer1_clock,
 	       analyzer2_data, analyzer2_clock,
 	       analyzer3_data, analyzer3_clock,
 	       analyzer4_data, analyzer4_clock);

   output beep, audio_reset_b, ac97_synch, ac97_sdata_out;
   input  ac97_bit_clock, ac97_sdata_in;
   
   output [7:0] vga_out_red, vga_out_green, vga_out_blue;
   output vga_out_sync_b, vga_out_blank_b, vga_out_pixel_clock,
	  vga_out_hsync, vga_out_vsync;

   output [9:0] tv_out_ycrcb;
   output tv_out_reset_b, tv_out_clock, tv_out_i2c_clock, tv_out_i2c_data,
	  tv_out_pal_ntsc, tv_out_hsync_b, tv_out_vsync_b, tv_out_blank_b,
	  tv_out_subcar_reset;
   
   input  [19:0] tv_in_ycrcb;
   input  tv_in_data_valid, tv_in_line_clock1, tv_in_line_clock2, tv_in_aef,
	  tv_in_hff, tv_in_aff;
   output tv_in_i2c_clock, tv_in_fifo_read, tv_in_fifo_clock, tv_in_iso,
	  tv_in_reset_b, tv_in_clock;
   inout  tv_in_i2c_data;
        
   inout  [35:0] ram0_data;
   output [18:0] ram0_address;
   output ram0_adv_ld, ram0_clk, ram0_cen_b, ram0_ce_b, ram0_oe_b, ram0_we_b;
   output [3:0] ram0_bwe_b;
   
   inout  [35:0] ram1_data;
   output [18:0] ram1_address;
   output ram1_adv_ld, ram1_clk, ram1_cen_b, ram1_ce_b, ram1_oe_b, ram1_we_b;
   output [3:0] ram1_bwe_b;

   input  clock_feedback_in;
   output clock_feedback_out;
   
   inout  [15:0] flash_data;
   output [23:0] flash_address;
   output flash_ce_b, flash_oe_b, flash_we_b, flash_reset_b, flash_byte_b;
   input  flash_sts;
   
   output rs232_txd, rs232_rts;
   input  rs232_rxd, rs232_cts;

   input  mouse_clock, mouse_data, keyboard_clock, keyboard_data;

   input  clock_27mhz, clock1, clock2;

   output disp_blank, disp_clock, disp_rs, disp_ce_b, disp_reset_b;  
   input  disp_data_in;
   output  disp_data_out;
   
   input  button0, button1, button2, button3, button_enter, button_right,
	  button_left, button_down, button_up;
   input  [7:0] switch;
   output [7:0] led;

   inout [31:0] user1, user2, user3, user4;
   
   inout [43:0] daughtercard;

   inout  [15:0] systemace_data;
   output [6:0]  systemace_address;
   output systemace_ce_b, systemace_we_b, systemace_oe_b;
   input  systemace_irq, systemace_mpbrdy;

   output [15:0] analyzer1_data, analyzer2_data, analyzer3_data, 
		 analyzer4_data;
   output analyzer1_clock, analyzer2_clock, analyzer3_clock, analyzer4_clock;

   ////////////////////////////////////////////////////////////////////////////
   //
   // I/O Assignments
   //
   ////////////////////////////////////////////////////////////////////////////
   
   // Audio Input and Output
   assign beep= 1'b0;
   assign audio_reset_b = 1'b0;
   assign ac97_synch = 1'b0;
   assign ac97_sdata_out = 1'b0;
   // ac97_sdata_in is an input

   // VGA Output
   assign vga_out_red = 8'h0;
   assign vga_out_green = 8'h0;
   assign vga_out_blue = 8'h0;
   assign vga_out_sync_b = 1'b1;
   assign vga_out_blank_b = 1'b1;
   assign vga_out_pixel_clock = 1'b0;
   assign vga_out_hsync = 1'b0;
   assign vga_out_vsync = 1'b0;

   // Video Output
   assign tv_out_ycrcb = 10'h0;
   assign tv_out_reset_b = 1'b0;
   assign tv_out_clock = 1'b0;
   assign tv_out_i2c_clock = 1'b0;
   assign tv_out_i2c_data = 1'b0;
   assign tv_out_pal_ntsc = 1'b0;
   assign tv_out_hsync_b = 1'b1;
   assign tv_out_vsync_b = 1'b1;
   assign tv_out_blank_b = 1'b1;
   assign tv_out_subcar_reset = 1'b0;
   
   // Video Input
   assign tv_in_i2c_clock = 1'b0;
   assign tv_in_fifo_read = 1'b0;
   assign tv_in_fifo_clock = 1'b0;
   assign tv_in_iso = 1'b0;
   assign tv_in_reset_b = 1'b0;
   assign tv_in_clock = 1'b0;
   assign tv_in_i2c_data = 1'bZ;
   // tv_in_ycrcb, tv_in_data_valid, tv_in_line_clock1, tv_in_line_clock2, 
   // tv_in_aef, tv_in_hff, and tv_in_aff are inputs
   
   // SRAMs
   assign ram0_data = 36'hZ;
   assign ram0_address = 19'h0;
   assign ram0_adv_ld = 1'b0;
   assign ram0_clk = 1'b0;
   assign ram0_cen_b = 1'b1;
   assign ram0_ce_b = 1'b1;
   assign ram0_oe_b = 1'b1;
   assign ram0_we_b = 1'b1;
   assign ram0_bwe_b = 4'hF;
   assign ram1_data = 36'hZ; 
   assign ram1_address = 19'h0;
   assign ram1_adv_ld = 1'b0;
   assign ram1_clk = 1'b0;
   assign ram1_cen_b = 1'b1;
   assign ram1_ce_b = 1'b1;
   assign ram1_oe_b = 1'b1;
   assign ram1_we_b = 1'b1;
   assign ram1_bwe_b = 4'hF;
   assign clock_feedback_out = 1'b0;
   // clock_feedback_in is an input
   
   // Flash ROM
   assign flash_data = 16'hZ;
   assign flash_address = 24'h0;
   assign flash_ce_b = 1'b1;
   assign flash_oe_b = 1'b1;
   assign flash_we_b = 1'b1;
   assign flash_reset_b = 1'b0;
   assign flash_byte_b = 1'b1;
   // flash_sts is an input

   // RS-232 Interface
   assign rs232_txd = 1'b1;
   assign rs232_rts = 1'b1;
   // rs232_rxd and rs232_cts are inputs

   // PS/2 Ports
   // mouse_clock, mouse_data, keyboard_clock, and keyboard_data are inputs

/*
   // LED Displays
   assign disp_blank = 1'b1;
   assign disp_clock = 1'b0;
   assign disp_rs = 1'b0;
   assign disp_ce_b = 1'b1;
   assign disp_reset_b = 1'b0;
   assign disp_data_out = 1'b0;
   // disp_data_in is an input
*/

   // Buttons, Switches, and Individual LEDs
   assign led = 8'hFF;
   // button0, button1, button2, button3, button_enter, button_right,
   // button_left, button_down, button_up, and switches are inputs

   // User I/Os
   assign user1 = 32'hZ;
   assign user2 = 32'hZ;
   assign user3[29:0] = 30'hZ;
   assign user4 = 32'hZ;

   // Daughtercard Connectors
   assign daughtercard = 44'hZ;

   // SystemACE Microprocessor Port
   assign systemace_data = 16'hZ;
   assign systemace_address = 7'h0;
   assign systemace_ce_b = 1'b1;
   assign systemace_we_b = 1'b1;
   assign systemace_oe_b = 1'b1;
   // systemace_irq and systemace_mpbrdy are inputs

   // Logic Analyzer
   assign analyzer1_data = 16'h0;
   assign analyzer1_clock = 1'b1;
   assign analyzer2_data = 16'h0;
   assign analyzer2_clock = 1'b1;
   assign analyzer3_data = 16'h0;
   assign analyzer3_clock = 1'b1;
   assign analyzer4_data = 16'h0;
   assign analyzer4_clock = 1'b1;


  ////////////////////////////////////////////////////////////////////////////
  //
  // Reset Generation
  //
  // A shift register primitive is used to generate an active-high reset
  // signal that remains high for 16 clock cycles after configuration finishes
  // and the FPGA's internal clocks begin toggling.
  //
  ////////////////////////////////////////////////////////////////////////////
  wire reset_init;
  SRL16 reset_sr(.D(1'b0), .CLK(clock_27mhz), .Q(reset_init),
	         .A0(1'b1), .A1(1'b1), .A2(1'b1), .A3(1'b1));
  defparam reset_sr.INIT = 16'hFFFF;
  
  // debounce the down button for reset
  wire button_down_debounced;
  debounce db_down(0, clock_27mhz, button_down, button_down_debounced);
  // reset is the OR of button down and the FPGA reset
  wire reset = reset_init | ~button_down_debounced;
  
  // for the test transmission
  wire button_up_debounced;
  debounce db_up(reset, clock_27mhz, button_up, button_up_debounced);
  
  wire button_0_debounced;
  debounce db_0(reset, clock_27mhz, button0, button_0_debounced);
  
  wire button_1_debounced;
  debounce db_1(reset, clock_27mhz, button1, button_1_debounced);
  
  wire button_2_debounced;
  debounce db_2(reset, clock_27mhz, button2, button_2_debounced);
  
  wire button_3_debounced;
  debounce db_3(reset, clock_27mhz, button3, button_3_debounced);
  
  wire ir_input;
  synchronize ir_sync(.in(~user3[30]),.out(ir_input),.clk(clock_27mhz));
 
///////////////////////////////////////////////////////////////////////////////////////////
// 
// This is the transmitter for the remote.  Set transmit_address and/or 
// transmit_command for the desired function. This example hard codes the up
// button to "channel up"
// 
// Insert your Verilog here to control the TV.  
// 
//
// 
//  wire [4:0]  transmit_address;// = 5'h1; //address is 1 for TV 
//  wire [6:0]  transmit_command;// = 7'h10; //command is 16 (hex 10) for channel up
	wire [4:0] receiver_address;
	reg [4:0] transmit_address;
	wire [6:0] receiver_command;
	reg [6:0] transmit_command;
	wire transmit;
	wire[1:0] top_level_state;
//  wire transmit         = ~button_up_debounced; //up button controls transmit for now
	wire [43:0] my_hex_data = {3'b0, receiver_address, 1'b0, receiver_command, 2'b0, top_level_state, 24'b0};//44'b0;   // use this to display the decoded commands and for debug
//
//
// 
//
////////////////////////////////////////////////////////////////////////////////////////////

	remote_receiver receiver (.clk(clock_27mhz),
										.reset(reset),
										.in(ir_input),
										.b0(button_0_debounced),
										.b1(button_1_debounced),
										.b2(button_2_debounced),
										.b3(button_3_debounced),
										.com(receiver_command),
										.addr(receiver_address),
										.transmit(transmit),
										.state(top_level_state));
										
	remote_transmitter transmitter (.clk(clock_27mhz),
										    .reset(reset),
										    .address(transmit_address),
									  	    .command(transmit_command),
										    .transmit(transmit),
										    .signal_out(user3[31]));					  

	display_16hex disp(reset, clock_27mhz, {my_hex_data,
                                          3'b0,transmit, //1 if transmitting
                                          3'b0,transmit_address, //signal_out address (2 digits)
														1'b0,transmit_command}, //signal_out command (2 digits)
		disp_blank, disp_clock, disp_rs, disp_ce_b,
		disp_reset_b, disp_data_out);

	always @(posedge clock_27mhz) begin
		if (reset) begin
			transmit_address <= 0;
			transmit_command <= 0;
		end
		else if (transmit) begin
			transmit_address <= receiver_address;
			transmit_command <= receiver_command;
		end
	end
						    
endmodule


///////////////////////////////////////////////////////////////////////////////
//
// 6.111 Remote Control Transmitter Module
//
// Outputs a 12-bit Sony remote control signal based on the Sony Infrared Command 
// (SIRC) specification. signal_out can be used to control a TSKS400S Infrared 
// Emitting Diode, using a BJT to produce a stronger driving signal.
// SIRC uses pulse-width modulation to encode the 10-bit signal, with a 600us 
// base frequency modulated by a 40kHz square wave with 25% duty cycle.
//
// Created: February 29, 2009
// Author: Adam Lerer,
// Updated October 4, 2010 - fixed 40Khz modulation, inserted 45ms between commands
//
///////////////////////////////////////////////////////////////////////////////
module remote_transmitter (input wire clk, //27 mhz clock
									input wire reset, //FPGA reset
									input wire [4:0] address, // 5-bit signal address
									input wire [6:0] command, // 7-bit signal command
									input wire transmit, // transmission occurs when transmit is asserted
									output wire signal_out); //output to IR transmitter

  wire [11:0] value = {address, command}; //the value to be transmitted
  
  ///////////////////////////////////////////////////////////////////////////////////////
  //
  // here we count the number of "ones" in the signal, subtract from wait time
  // and pad the wait state to start the next command sequence exactly 45ms later. 
  wire [3:0] sum_ones = address[4] + address[3] + address[2] + address[1] + address[0] +
				command[6] + command[5] + command[4] + command[3] + command[2] + command[1] + command[0];
  wire[9:0] WAIT_TO_45MS = 16'd376 - (sum_ones*8);
  //
  ///////////////////////////////////////////////////////////////////////////////////////
  
  reg [2:0] next_state;
  // cur_value latches the value input when the transmission begins,
  // and gets right shifted in order to transmit each successive bit
  reg [11:0] cur_value;
  // cur_bit keeps track of how many bits have been transmitted
  reg [3:0] cur_bit;
  reg [2:0] state;
  
  wire [15:0] timer_length;  // large number of future options
  
  localparam IDLE =  3'd0;
  localparam WAIT =  3'd1;
  localparam START = 3'd2;
  localparam TRANS = 3'd3;
  localparam BIT =   3'd4;
  
  // this counter is used to modulate the transmitted signal 
  // by a 40kHz 25% duty cycle square wave  gph 10/2/2010
  reg [10:0] mod_count; 
  
  wire start_timer;
  wire expired;
  
  timer t (.clk(clk),
           .reset(reset),
			  .start_timer(start_timer),
			  .length(timer_length),
			  .expired(expired));
			  
  always@(posedge clk) 
  begin
    // signal modulation
	 mod_count <= (mod_count == 674) ? 0 : mod_count + 1;   // was 1349 
    if (reset)
	   state <= IDLE;
	 else begin
	   if (state == START) 
		begin
		  cur_bit <= 0;
		  cur_value <= value;
		end
		// when a bit finishes being transmitted, left shift cur_value
		// so that the next bit can be transmitted, and increment cur_bit
	   if (state == BIT && next_state == TRANS) 
		begin
		  cur_bit <= cur_bit + 1;
		  cur_value <= {1'b0, cur_value[11:1]};
		end
      state <= next_state;
    end
  end
  
  always@* 
  begin
    case(state)
	   IDLE:  next_state = transmit  ? WAIT : IDLE;
		WAIT:  next_state = expired ? (transmit ? START : IDLE) : WAIT;
		START: next_state = expired ? TRANS : START;
		TRANS: next_state = expired ? BIT : TRANS;
		BIT :  next_state = expired ? (cur_bit == 11 ? WAIT : TRANS) : BIT;
		default: next_state = IDLE;
	 endcase 
  end
  // always start the timer on a state transition
  assign start_timer = (state != next_state);
  assign timer_length = (next_state == WAIT) ? WAIT_TO_45MS :  // was 63; 600-4-24-6 = 566
                        (next_state == START) ? 16'd32 :
								(next_state == TRANS) ? 16'd8 :
								(next_state == BIT ) ? (cur_value[0] ? 16'd16 : 16'd8 ) : 16'd0;
  assign signal_out = ((state == START) || (state == BIT)) && (mod_count < 169);	// was 338  gph					
endmodule


//remote_receiver
module remote_receiver (
	input in, b0, b1, b2, b3,clk,reset,
	output reg [6:0] com, output reg [4:0] addr, output reg transmit, output reg [1:0] state);
	
	reg [1:0] next_state;
	reg [1:0] sel;
	reg start_timer;
	reg start_play_timer;
	wire expired;
	wire play_expired;
	reg start_rec = 0;
	wire rec_done;
	reg long = 0;
	wire [6:0] rec_com;
	wire [4:0] rec_addr;
	
	reg [27:0] com_data = 0;
	reg [19:0] addr_data = 0;

	localparam IDLE = 2'd0;
	localparam BUTTON_PRESS = 2'd1;
	localparam PLAY = 2'd2;
	localparam RECORD = 2'd3;
	
	localparam BUTTON_DELAY = 16'd13_133; //one second
	localparam PLAY_DELAY = 16'd2_666;
	
	timer t (.clk(clk),
           .reset(reset),
			  .start_timer(start_timer),
			  .length(BUTTON_DELAY),
			  .expired(expired));
			  
	timer t2 (.clk(clk),
           .reset(reset),
			  .start_timer(start_play_timer),
			  .length(PLAY_DELAY),
			  .expired(play_expired));
			  
	receiver_fsm rf (.in(in),.rec(start_rec),.reset(reset),
							.clk(clk),.com(rec_com),.addr(rec_addr),.done(rec_done));
	
	always @(posedge clk) begin
		if (reset) begin
			state <= IDLE;
			com_data <= {21'b0, 7'h10};
			addr_data <= {15'b0, 5'b1};
			long <= 0;
		end
		else begin
			if (state == IDLE)
				long <= 0;
			if (state == IDLE && next_state == BUTTON_PRESS) begin
				start_timer <= 1;
			end
			else if (state == BUTTON_PRESS && next_state == BUTTON_PRESS) begin
				start_timer <= 0;
				if (expired)
					long <= 1;
				if (~b0)
					sel <= 2'b00;
				else if (~b1)
					sel <= 2'b01;
				else if (~b2)
					sel <= 2'b10;
				else if (~b3)
					sel <= 2'b11;
				else
					sel <= 2'b00;
			end
			else if (state == BUTTON_PRESS && next_state == PLAY) begin
				transmit <= 1;
				com <= com_data[7*sel+:7];
				addr <= addr_data[5*sel+:5];
				start_play_timer <= 1;
			end
			else if (state == PLAY && next_state == PLAY) begin
				start_play_timer <= 0;
			end
			else if (state == PLAY && next_state == IDLE) begin
				transmit <= 0;
			end
			else if (state == BUTTON_PRESS && next_state == RECORD) begin
				start_rec <= 1;
			end
			else if (state == RECORD && next_state == RECORD) begin
				start_rec <= 0;
			end
			else if (state == RECORD && next_state == IDLE) begin
				com_data[7*sel] <= rec_com[0];
				com_data[7*sel+1] <= rec_com[1];
				com_data[7*sel+2] <= rec_com[2];
				com_data[7*sel+3] <= rec_com[3];
				com_data[7*sel+4] <= rec_com[4];
				com_data[7*sel+5] <= rec_com[5];
				com_data[7*sel+6] <= rec_com[6];
				addr_data[5*sel] <= rec_addr[0];
				addr_data[5*sel+1] <= rec_addr[1];
				addr_data[5*sel+2] <= rec_addr[2];
				addr_data[5*sel+3] <= rec_addr[3];
				addr_data[5*sel+4] <= rec_addr[4];
				com <= rec_com;
				addr <= rec_addr;
			end
			state <= next_state;
		end	
	end
	
	always @* begin
		case (state)
			IDLE: next_state = (~b0 || ~b1 || ~b2 || ~b3) ? BUTTON_PRESS : IDLE;
			BUTTON_PRESS: next_state = (~b0 || ~b1 || ~b2 || ~b3) ? BUTTON_PRESS : (long ? RECORD : PLAY);
			PLAY: next_state = play_expired ? IDLE : PLAY;
			RECORD: next_state = (rec_done) ? IDLE : RECORD;
			default: next_state = IDLE;
		endcase
	end	
endmodule

//receiver_fsm
module receiver_fsm (
	input in,rec,reset,clk,
	output[6:0] com, output[4:0] addr, output reg done);

	localparam IDLE =  3'd0;
	localparam WAIT =  3'd1;
	localparam START = 3'd2;
	localparam TRANS = 3'd3;
	localparam BIT =   3'd4;
	
	reg [11:0] value; //the value being recorded
	reg [2:0] next_state;
	reg [2:0] state = IDLE;
	reg [3:0] cur_bit; // cur_bit keeps track of how many bits have been received
	reg rec_bit;
	wire start_timer;
	wire expired;
	
	timer t (.clk(clk),
           .reset(reset),
			  .start_timer(start_timer),
			  .length(16'd9),
			  .expired(expired));

	always@(posedge clk) 
		begin

		if (reset) begin
			state <= IDLE;
			value <= 0;
		end
		else begin
			if (state == START)
			begin
				cur_bit <= 0;
				value <= 0; //reset the current value
				rec_bit <= 0;
			end
			if (state == BIT && ((next_state == TRANS) || next_state == IDLE)) 
			begin
				cur_bit <= cur_bit + 1;
				value[11-cur_bit] <= rec_bit;
				rec_bit <= 0;
			end
			else if (state == BIT && next_state == BIT && expired)
			begin
				rec_bit <= 1;		// time expired, we are in "logical 1" length
			end
			state <= next_state;
		end
		
		if (state == BIT && next_state == IDLE)
			done <= 1;
		else
			done <= 0;
	end
  
	always@* 
	begin
		case(state)
			IDLE:  next_state = rec ? WAIT : IDLE;
			WAIT:  next_state = in ? START : WAIT;
			START: next_state = in ? START : TRANS;
			TRANS: next_state = in ? BIT : TRANS;
			BIT :  next_state = in ? BIT : ((cur_bit == 11) ? IDLE : TRANS);
			default: next_state = IDLE;
		endcase 
	end
  // always start the timer on a state transition
  assign start_timer = (state != next_state);
  assign {com,addr} = {value[5],value[6],value[7],value[8],value[9],
								value[10],value[11],value[0],value[1],value[2],
								value[3],value[4]};
endmodule

///////////////////////////////////////////////////////////////////////////////
// A programmable timer with 75us increments. When start_timer is asserted,
// the timer latches length, and asserts expired for one clock cycle 
// after 'length' 75us intervals have passed. e.g. if length is 10, timer will
// assert expired after 750us.
///////////////////////////////////////////////////////////////////////////////
module timer (input wire clk,
				 input wire reset,
				 input wire start_timer,
				 input wire [15:0] length,
				 output wire expired);
  
  wire enable;
  divider_600us sc(.clk(clk),.reset(start_timer),.enable(enable));
  reg [15:0] count_length;
  reg [15:0] count;
  reg counting;
  
  always@(posedge clk) 
  begin
	 if (reset)
		counting <= 0;
	 else if (start_timer) 
	 begin
		count_length <= length;
		count <= 0;
		counting <= 1;
	 end
	 else if (counting && enable)
		count <= count + 1;
	 else if (expired)
		counting <= 0;
  end
  
  assign expired = (counting && (count == count_length));
endmodule	

///////////////////////////////////////////////////////////////////////////////
// enable goes high every 75us, providing 8x oversampling for 
// 600us width signal (with 27mhz clock)
///////////////////////////////////////////////////////////////////////////////
module divider_600us (input wire clk,
							 input wire reset,
							 output wire enable);

  reg [10:0] count;

  always@(posedge clk) 
  begin
	 if (reset)
		count <= 0;
	 else if (count == 2024)
		count <= 0;
	 else
		count <= count + 1;
  end
  assign enable = (count == 2024);  
endmodule  

// Switch Debounce Module
// use your system clock for the clock input
// to produce a synchronous, debounced output
module debounce #(parameter DELAY=270000)   // .01 sec with a 27Mhz clock
	        (input reset, clock, noisy,
	         output reg clean);

   reg [18:0] count;
   reg new;

   always @(posedge clock)
     if (reset)
       begin
	  count <= 0;
	  new <= noisy;
	  clean <= noisy;
       end
     else if (noisy != new)
       begin
	  new <= noisy;
	  count <= 0;
       end
     else if (count == DELAY)
       clean <= new;
     else
       count <= count+1;
      
endmodule


///////////////////////////////////////////////////////////////////////////////
//
// 6.111 FPGA Labkit -- Hex display driver
//
// File:   display_16hex.v
// Date:   24-Sep-05
//
// Created: April 27, 2004
// Author: Nathan Ickes
//
// 24-Sep-05 Ike: updated to use new reset-once state machine, remove clear
// 28-Nov-06 CJT: fixed race condition between CE and RS (thanks Javier!)
//
// This verilog module drives the labkit hex dot matrix displays, and puts
// up 16 hexadecimal digits (8 bytes).  These are passed to the module
// through a 64 bit wire ("data"), asynchronously.  
//
///////////////////////////////////////////////////////////////////////////////

module display_16hex (reset, clock_27mhz, data, 
		disp_blank, disp_clock, disp_rs, disp_ce_b,
		disp_reset_b, disp_data_out);

   input reset, clock_27mhz;    // clock and reset (active high reset)
   input [63:0] data;		// 16 hex nibbles to display
   
   output disp_blank, disp_clock, disp_data_out, disp_rs, disp_ce_b, 
	  disp_reset_b;
   
   reg disp_data_out, disp_rs, disp_ce_b, disp_reset_b;
   
   ////////////////////////////////////////////////////////////////////////////
   //
   // Display Clock
   //
   // Generate a 500kHz clock for driving the displays.
   //
   ////////////////////////////////////////////////////////////////////////////
   
   reg [4:0] count;
   reg [7:0] reset_count;
   reg clock;
   wire dreset;

   always @(posedge clock_27mhz)
     begin
	if (reset)
	  begin
	     count = 0;
	     clock = 0;
	  end
	else if (count == 26)
	  begin
	     clock = ~clock;
	     count = 5'h00;
	  end
	else
	  count = count+1;
     end
   
   always @(posedge clock_27mhz)
     if (reset)
       reset_count <= 100;
     else
       reset_count <= (reset_count==0) ? 0 : reset_count-1;

   assign dreset = (reset_count != 0);

   assign disp_clock = ~clock;

   ////////////////////////////////////////////////////////////////////////////
   //
   // Display State Machine
   //
   ////////////////////////////////////////////////////////////////////////////
      
   reg [7:0] state;		// FSM state
   reg [9:0] dot_index;		// index to current dot being clocked out
   reg [31:0] control;		// control register
   reg [3:0] char_index;	// index of current character
   reg [39:0] dots;		// dots for a single digit 
   reg [3:0] nibble;		// hex nibble of current character
   
   assign disp_blank = 1'b0; // low <= not blanked
   
   always @(posedge clock)
     if (dreset)
       begin
	  state <= 0;
	  dot_index <= 0;
	  control <= 32'h7F7F7F7F;
       end
     else
       casex (state)
	 8'h00:
	   begin
	      // Reset displays
	      disp_data_out <= 1'b0; 
	      disp_rs <= 1'b0; // dot register
	      disp_ce_b <= 1'b1;
	      disp_reset_b <= 1'b0;	     
	      dot_index <= 0;
	      state <= state+1;
	   end
	 
	 8'h01:
	   begin
	      // End reset
	      disp_reset_b <= 1'b1;
	      state <= state+1;
	   end
	 
	 8'h02:
	   begin
	      // Initialize dot register (set all dots to zero)
	      disp_ce_b <= 1'b0;
	      disp_data_out <= 1'b0; // dot_index[0];
	      if (dot_index == 639)
		state <= state+1;
	      else
		dot_index <= dot_index+1;
	   end
	 
	 8'h03:
	   begin
	      // Latch dot data
	      disp_ce_b <= 1'b1;
	      dot_index <= 31;		// re-purpose to init ctrl reg
	      disp_rs <= 1'b1; // Select the control register
	      state <= state+1;
	   end
	 
	 8'h04:
	   begin
	      // Setup the control register
	      disp_ce_b <= 1'b0;
	      disp_data_out <= control[31];
	      control <= {control[30:0], 1'b0};	// shift left
	      if (dot_index == 0)
		state <= state+1;
	      else
		dot_index <= dot_index-1;
	   end
	  
	 8'h05:
	   begin
	      // Latch the control register data / dot data
	      disp_ce_b <= 1'b1;
	      dot_index <= 39;		// init for single char
	      char_index <= 15;		// start with MS char
	      state <= state+1;
	      disp_rs <= 1'b0;	 	// Select the dot register
	   end
	 
	 8'h06:
	   begin
	      // Load the user's dot data into the dot reg, char by char
	      disp_ce_b <= 1'b0;
	      disp_data_out <= dots[dot_index]; // dot data from msb
	      if (dot_index == 0)
	        if (char_index == 0)
	          state <= 5;			// all done, latch data
		else
		begin
		  char_index <= char_index - 1;	// goto next char
		  dot_index <= 39;
		end
	      else
		dot_index <= dot_index-1;	// else loop thru all dots 
	   end

       endcase

   always @ (data or char_index)
     case (char_index)
       4'h0: 	 	nibble <= data[3:0];
       4'h1: 	 	nibble <= data[7:4];
       4'h2: 	 	nibble <= data[11:8];
       4'h3: 	 	nibble <= data[15:12];
       4'h4: 	 	nibble <= data[19:16];
       4'h5: 	 	nibble <= data[23:20];
       4'h6: 	 	nibble <= data[27:24];
       4'h7: 	 	nibble <= data[31:28];
       4'h8: 	 	nibble <= data[35:32];
       4'h9: 	 	nibble <= data[39:36];
       4'hA: 	 	nibble <= data[43:40];
       4'hB: 	 	nibble <= data[47:44];
       4'hC: 	 	nibble <= data[51:48];
       4'hD: 	 	nibble <= data[55:52];
       4'hE: 	 	nibble <= data[59:56];
       4'hF: 	 	nibble <= data[63:60];
     endcase
      
   always @(nibble)
     case (nibble)
       4'h0: dots <= 40'b00111110_01010001_01001001_01000101_00111110;
       4'h1: dots <= 40'b00000000_01000010_01111111_01000000_00000000;
       4'h2: dots <= 40'b01100010_01010001_01001001_01001001_01000110;
       4'h3: dots <= 40'b00100010_01000001_01001001_01001001_00110110;
       4'h4: dots <= 40'b00011000_00010100_00010010_01111111_00010000;
       4'h5: dots <= 40'b00100111_01000101_01000101_01000101_00111001;
       4'h6: dots <= 40'b00111100_01001010_01001001_01001001_00110000;
       4'h7: dots <= 40'b00000001_01110001_00001001_00000101_00000011;
       4'h8: dots <= 40'b00110110_01001001_01001001_01001001_00110110;
       4'h9: dots <= 40'b00000110_01001001_01001001_00101001_00011110;
       4'hA: dots <= 40'b01111110_00001001_00001001_00001001_01111110;
       4'hB: dots <= 40'b01111111_01001001_01001001_01001001_00110110;
       4'hC: dots <= 40'b00111110_01000001_01000001_01000001_00100010;
       4'hD: dots <= 40'b01111111_01000001_01000001_01000001_00111110;
       4'hE: dots <= 40'b01111111_01001001_01001001_01001001_01000001;
       4'hF: dots <= 40'b01111111_00001001_00001001_00001001_00000001;
     endcase
   
endmodule

// pulse synchronizer
module synchronize #(parameter NSYNC = 2)  // number of sync flops.  must be >= 2
                   (input clk,in,
                    output reg out);

  reg [NSYNC-2:0] sync;

  always @ (posedge clk)
  begin
    {out,sync} <= {sync[NSYNC-2:0],in};
  end
endmodule
	
