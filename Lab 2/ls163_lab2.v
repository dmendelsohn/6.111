`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:24:59 10/03/2013 
// Design Name: 
// Module Name:    ls163_lab2 
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
module ls163_lab2(
    input clk,
    input ent,
    input enp,
    input load,
    input clear,
    input a,
    input b,
    input c,
    input d,
    output reg qa,
    output reg qb,
    output reg qc,
    output reg qd,
    output rco
    );

	assign rco = (qa & qb & qc & qd & ent);
	always @ (posedge clk) begin
    if (~clear) //active low
      {qd, qc, qb, qa} <= 4'b0000;
    else if (~load)
      {qd, qc, qb, qa} <= {d, c, b, a};
    else if (ent & enp) //active low
      {qd, qc, qb, qa} <= {qd, qc, qb, qa} + 1;
  end 
endmodule
