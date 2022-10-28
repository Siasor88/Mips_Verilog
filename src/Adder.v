module Adder(in1, in2, c_in, c_out, sum);

parameter DATA_LEN = 32;

input [DATA_LEN - 1 : 0] in1, in2;
input c_in;

output [DATA_LEN - 1 : 0] sum;

output c_out;

wire [DATA_LEN : 0] sum_shadow, cin_tmp, in1_tmp, in2_tmp;


assign cin_tmp = {{(DATA_LEN){1'b0}}, c_in};

assign in1_tmp = {in1[31], in1};
assign in2_tmp = {in2[31], in2};

assign sum_shadow = in1_tmp + in2_tmp + cin_tmp;
assign sum = sum_shadow[DATA_LEN - 1 : 0];
assign c_out = sum_shadow[DATA_LEN];




endmodule
