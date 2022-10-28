module PC(in, out, clk, stall);

input [31:0] in;
input clk;
input stall;
output [31:0] out;
reg [31:0] out;

initial out = -4;

always @(posedge clk) begin
    if (!stall)
         out <= in;
end

endmodule
