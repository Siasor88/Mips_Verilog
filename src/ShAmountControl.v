module ShAmountControl(func, sh_amount_control);

input [5:0] func;
output sh_amount_control;
reg sh_amount_control;

always @(func) begin
	if (func == 6'b000000 || func == 6'b000010 || func == 6'b000011) sh_amount_control = 1;
	else sh_amount_control = 0;
end

endmodule