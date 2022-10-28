
module MUX(in1, in0,out, select);

parameter INPUT_LEN = 32;

input [INPUT_LEN - 1 : 0] in1, in0;
input select;
output [INPUT_LEN - 1 : 0] out;

assign out = select ? in1 : in0;



endmodule
