// 6.111 Lab 2, Exercise 1

// establish time units for delays used in test module
`timescale 1 ns / 100 ps

// rco corrected to be non-reg GPH 
// module to emulate 74LS163 synchronous counter
// remember load and clear are active low signals!
module LS163(input clk,ent,enp,load,clear,a,b,c,d,
	     output reg qa,qb,qc,qd, output rco);
	     
	assign rco = (qa & qb & qc & qd & ent);

  always @ (posedge clk) begin
    if (~clear) //active low
      {qd, qc, qb, qa} <= 4'b0000;
    else if (~load)
      {qd, qc, qb, qa} <= {d, c, b, a};
    else if (ent & enp) //active low
      {qd, qc, qb, qa} <= {qd, qc, qb, qa} + 1;
  end 
endmodule // LS163

// top level test module
module test();
  integer count;
  reg clk,ent,enp,ld_bar,clr_bar;
  reg [3:0] in,temp;
  wire [3:0] out;
  wire rco;

  // make an instance of LS163
  LS163 test(.clk(clk),.ent(ent),.enp(enp),.load(ld_bar),.clear(clr_bar),
             .a(in[0]),.b(in[1]),.c(in[2]),.d(in[3]),
	     .qa(out[0]),.qb(out[1]),.qc(out[2]),.qd(out[3]),.rco(rco));

  // clk has 50% duty cycle, 100ns period
  initial begin
    clk = 0;
    forever #50 clk = ~clk;
  end
  
  initial begin
    $display("Starting test of LS163...");

    // clear the counter
    in = 13;
    ld_bar = 1;
    clr_bar = 0;
    ent = 0;
    enp = 0;
    #100
    if (out !== 0) begin
      $display("clear was asserted low, but counter didn't clear");
      $display("out = %b, expected 0000",out);
      $stop();
    end

    // make it count to 15
    clr_bar = 1;
    ent = 1;
    enp = 1;
    for (count = 1; count <= 15; count = count + 1) begin
      #100
      temp = count;  // so we can print it nicely!
      if (out !== count) begin
        $display("ent and enp are asserted, but counter didn't count");
        $display("out = %b, expected %b",out,temp);
        $stop();
      end
      if (count === 15) begin
        if (rco !== 1) begin
          $display("ent and enp are asserted and out == 15, but rco isn't 1");
          $stop();
        end
      end
      else begin
        if (rco !== 0) begin
          $display("ent and enp are asserted and out == %b, but rco isn't 0",out);
          $stop();
        end
      end
    end
      
    // deassert ENT, check RCO
    ent = 0;
    #10
    if (rco !== 0) begin
      $display("ent is deasserted, but rco isn't 0");
      $stop();
    end
    #90
    if (out !== 15) begin
      $display("ent is deasserted, but counter incremented");
      $display("out = %b, expected 1111",out);
      $stop();
    end

    // deassert ENP
    ent = 1;
    enp = 0;
    #100
    if (out !== 15) begin
      $display("enp is deasserted, but counter incremented");
      $display("out = %b, expected 1111",out);
      $stop();
    end

    // test that clear is synchronous
    ent = 1;
    enp = 1;
    clr_bar = 0;
    #10
    if (out !== 15) begin
      $display("clear is asserted low, but counter cleared before clock edge");
      $display("out = %b, expected 1111",out);
      $stop();
    end
    #90
    if (out !== 0) begin
      $display("clear is asserted low, but counter didn't clear");
      $display("out = %b, expected 1111",out);
      $stop();
    end

    // test that load is synchronous
    ent = 1;
    enp = 1;
    clr_bar = 1;
    ld_bar = 0;
    #10
    if (out !== 0) begin
      $display("load is asserted low, but counter loaded before clock edge");
      $display("out = %b, expected 0000",out);
      $stop();
    end
    #90
    if (out !== in) begin
      $display("load is asserted low, but counter didn't load");
      $display("out = %b, expected %b",out,in);
      $stop();
    end

    $display("Finished test of LS163...");
    $stop();
  end    
  
endmodule // test
