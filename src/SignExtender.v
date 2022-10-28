`define EXTEND_LEN (OUT_LEN - IN_LEN)

module SignExtender(in, out, extend);
parameter IN_LEN = 16;
parameter OUT_LEN = 32;



input  [IN_LEN - 1 : 0] in;
input extend;
output [OUT_LEN - 1 : 0] out;


assign out = { { `EXTEND_LEN { extend ? in[IN_LEN - 1] : 1'b0} }, in[IN_LEN - 1: 0] };







endmodule
