`default_nettype none    // catch typos!
`timescale 1ns / 100ps 

/////////////////////////////////////////////////////////////////////////////////////
// Updated Fall 2012 by GPH
// commented out the next line in order to run ModelSim with ISE vs the command line.
//`include "fir31.v"   // remove if running VSIM directly.



// test fir31 module
// input samples are read from fir31.samples
// output samples are written to fir31.output
module fir31_test();
  reg clk,reset,ready;	// fir31 signals
  reg signed [7:0] x;
  wire signed [17:0] y;
  reg [20:0] scount;    // keep track of which sample we're at
  reg [5:0] cycle;      // wait 64 clocks between samples
  integer fin,fout,code;

  initial begin
    // open input/output files
    fin = $fopen("fir31.samples","r");
    fout = $fopen("fir31.output","w");
    if (fin == 0 || fout == 0) begin
      $display("can't open file...");
      $stop;
    end

    // initialize state, assert reset for one clock cycle
    scount = 0;
    clk = 0;
    cycle = 0;
    ready = 0;
    x = 0;
    reset = 1;
    #10
    reset = 0;
  end

  // clk has 50% duty cycle, 10ns period
  always #5 clk = ~clk;

  always @(posedge clk) begin
    if (cycle == 6'd63) begin
      // assert ready next cycle, read next sample from file
      ready <= 1;
      code = $fscanf(fin,"%d",x);
      // if we reach the end of the input file, we're done
      if (code != 1) begin
        $fclose(fout);
        $stop;
      end
    end
    else begin
      ready <= 0;
    end

    if (ready) begin
      // starting with sample 32, record results in output file
      if (scount > 31) $fdisplay(fout,"%d",y);
      scount <= scount + 1;
    end

    cycle <= cycle+1;
  end

  fir31 dut(.clock(clk),.reset(reset),.ready(ready),
            .x(x),.y(y));

endmodule
