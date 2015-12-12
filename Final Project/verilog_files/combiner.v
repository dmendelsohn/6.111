`timescale 1ns / 1ps
module combiner #(parameter WIDTH=24) //does 24bit bit-wise OR for 61 numbers
    (input [61*WIDTH-1:0] in,
    output [WIDTH-1:0] out
    );

	assign out = 
		in[WIDTH-1:0] |
		in[2*WIDTH-1:1*WIDTH] |
		in[3*WIDTH-1:2*WIDTH] |
		in[4*WIDTH-1:3*WIDTH] |
		in[5*WIDTH-1:4*WIDTH] |
		in[6*WIDTH-1:5*WIDTH] |
		in[7*WIDTH-1:6*WIDTH] |
		in[8*WIDTH-1:7*WIDTH] |
		in[9*WIDTH-1:8*WIDTH] |
		in[10*WIDTH-1:9*WIDTH] |
		in[11*WIDTH-1:10*WIDTH] |
		in[12*WIDTH-1:11*WIDTH] |
		in[13*WIDTH-1:12*WIDTH] |
		in[14*WIDTH-1:13*WIDTH] |
		in[15*WIDTH-1:14*WIDTH] |
		in[16*WIDTH-1:15*WIDTH] |
		in[17*WIDTH-1:16*WIDTH] |
		in[18*WIDTH-1:17*WIDTH] |
		in[19*WIDTH-1:18*WIDTH] |
		in[20*WIDTH-1:19*WIDTH] |
		in[21*WIDTH-1:20*WIDTH] |
		in[22*WIDTH-1:21*WIDTH] |
		in[23*WIDTH-1:22*WIDTH] |
		in[24*WIDTH-1:23*WIDTH] |
		in[25*WIDTH-1:24*WIDTH] |
		in[26*WIDTH-1:25*WIDTH] |
		in[27*WIDTH-1:26*WIDTH] |
		in[28*WIDTH-1:27*WIDTH] |
		in[29*WIDTH-1:28*WIDTH] |
		in[30*WIDTH-1:29*WIDTH] |
		in[31*WIDTH-1:30*WIDTH] |
		in[32*WIDTH-1:31*WIDTH] |
		in[33*WIDTH-1:32*WIDTH] |
		in[34*WIDTH-1:33*WIDTH] |
		in[35*WIDTH-1:34*WIDTH] |
		in[36*WIDTH-1:35*WIDTH] |
		in[37*WIDTH-1:36*WIDTH] |
		in[38*WIDTH-1:37*WIDTH] |
		in[39*WIDTH-1:38*WIDTH] |
		in[40*WIDTH-1:39*WIDTH] |
		in[41*WIDTH-1:40*WIDTH] |
		in[42*WIDTH-1:41*WIDTH] |
		in[43*WIDTH-1:42*WIDTH] |
		in[44*WIDTH-1:43*WIDTH] |
		in[45*WIDTH-1:44*WIDTH] |
		in[46*WIDTH-1:45*WIDTH] |
		in[47*WIDTH-1:46*WIDTH] |
		in[48*WIDTH-1:47*WIDTH] |
		in[49*WIDTH-1:48*WIDTH] |
		in[50*WIDTH-1:49*WIDTH] |
		in[51*WIDTH-1:50*WIDTH] |
		in[52*WIDTH-1:51*WIDTH] |
		in[53*WIDTH-1:52*WIDTH] |
		in[54*WIDTH-1:53*WIDTH] |
		in[55*WIDTH-1:54*WIDTH] |
		in[56*WIDTH-1:55*WIDTH] |
		in[57*WIDTH-1:56*WIDTH] |
		in[58*WIDTH-1:57*WIDTH] |
		in[59*WIDTH-1:58*WIDTH] |
		in[60*WIDTH-1:59*WIDTH] |
		in[61*WIDTH-1:60*WIDTH];

endmodule
