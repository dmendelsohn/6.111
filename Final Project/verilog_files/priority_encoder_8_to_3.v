`timescale 1ns / 1ps
module priority_encoder_8_to_3 (
    input [7:0] in,
    output [2:0] out
    );
	 
	 assign out = ((in[0] != 0) ? 0 :
		(in[1] != 0 ? 1 :
		(in[2] != 0 ? 2 :
		(in[3] != 0 ? 3 :
		(in[4] != 0 ? 4 :
		(in[5] != 0 ? 5 :
		(in[6] != 0 ? 6 :
		(in[7] != 0 ? 7 : 0))))))));

endmodule
