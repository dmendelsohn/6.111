`timescale 1ns / 1ps
module priority_encoder_61_to_6(
    input [60:0] in,
    output [5:0] out
    );
	 
	wire [8*3-1:0] buff_out;
	wire [63:0] buff_in;
	assign buff_in = {3'b0, in};
	 
	genvar i;
	generate
		for (i = 0; i < 8; i = i + 1) begin : PE
			priority_encoder_8_to_3 pe8to3 (.in(buff_in[8*i+:8]),.out(buff_out[3*i+:3]));
		end
	endgenerate
	
	assign out[2:0] = (buff_in != 0) ? buff_out[3*out[5:3]+:3] : 7;
	assign out[5:3] = ((buff_in[7:0] != 0) ? 0 :
			(buff_in[15:8] != 0 ? 1 :
			(buff_in[23:16] != 0 ? 2 :
			(buff_in[31:24] != 0 ? 3 :
			(buff_in[39:32] != 0 ? 4 :
			(buff_in[47:40] != 0 ? 5 :
			(buff_in[55:48] != 0 ? 6 :
			(buff_in[63:56] != 0 ? 7 : 7))))))));
endmodule
