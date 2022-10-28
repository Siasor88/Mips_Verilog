

module Shifter(in, out);

parameter INPUT_LEN = 26;

parameter OUTPUT_LEN = 28;

input [INPUT_LEN - 1 : 0] in;

 wire [INPUT_LEN + 1: 0] out_tmp;

output reg [OUTPUT_LEN - 1 : 0] out;

assign out_tmp = {in << 2, 2'b0};

always @(in) out = out_tmp[OUTPUT_LEN - 1 : 0];



endmodule
