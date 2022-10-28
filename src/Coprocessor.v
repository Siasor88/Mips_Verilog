module Coprocessor(
    input halted,
    input [4:0] fs,
    input [4:0] ft,
    input [4:0] fd_in,
    input [31:0] f_write_data,
    output [31:0] fs_data_2_3,
    output [31:0] ft_data_2_3,
    input [4:0] alu_control,
    input reg_write,
    input clk,
    input rst_b,
    input stall,
    output [31:0] fs_data,
    output [31:0] ft_data,
    output [31:0] f_result
);
    wire f_division_by_zero, f_qNaN, f_sNaN, f_inexact, f_underflow, f_zero, f_overflow;

regfile rgf(
    .rs_data(fs_data),
    .rt_data(ft_data),
    .rs_num(fs),
    .rt_num(ft),
    .rd_num(fd_in),
    .rd_data(f_write_data),
    .rd_we(reg_write),
    .clk(clk),
    .rst_b(rst_b),
    .is_float(1),
	.halted(halted)
);

FP_ALU fp_alu(
	.a(fs_data_2_3),
	.b(ft_data_2_3),
	.alu_control(alu_control),
	.result(f_result),
	.division_by_zero(f_division_by_zero),
	.qNaN(f_qNaN),
	.sNaN(f_sNaN),
	.inexact(f_inexact),
	.underflow(f_underflow),
	.zero(f_zero),
	.overflow(f_overflow)
);

endmodule