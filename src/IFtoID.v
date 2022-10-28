module IFtoID(last_stage, stall_mem, clk, instIn, PCIn, PCOut, instOut);

input clk;
input [31:0] instIn, PCIn;

output reg [31:0] instOut, PCOut;

always@(posedge clk) begin
  if (!stall_mem) begin
    if (!last_stage) begin
        instOut <= instIn;
        PCOut <= PCIn;
    end
  end  
end



endmodule