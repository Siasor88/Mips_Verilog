module Pipe(
    clk,
    stall,
    inputs,
    outputs
);

parameter INPUT_LEN = 32;
input stall, clk;
input [INPUT_LEN - 1 : 0] inputs;
output reg [INPUT_LEN - 1 : 0] outputs;

// assign outputs = inputs;

always @(posedge clk) begin
    if (!stall) begin
        outputs <= inputs;
    end
end



endmodule
