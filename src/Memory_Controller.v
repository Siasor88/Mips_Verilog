module MemoryController(memory_enable, clk, ready);

input memory_enable, clk;
output ready;
reg ready;
reg [3:0] count;

initial begin
	count = 4'b0000;
	ready = 1'b1;
end

always @(posedge memory_enable) begin
	if (ready == 1) ready <= 0;
end

always @(posedge clk) begin
	if (ready == 0) count <= count + 1;
	if (count == 0) begin			// memory access time is 1 clk in phase 1. count == n - 1.
		count <= 0;
		ready <= 1;
	end
end

endmodule

