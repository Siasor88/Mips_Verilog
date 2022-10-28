module WB(
	input f_to_w,
	input w_to_f,
	input jal,
	input mem_to_reg,
	input [4:0] write_reg,
	input [4:0] f_write_reg,
	input [4:0] fs,
	input [4:0] rt,
	input [REG_LEN - 1: 0] adder_pc_out,
	input [REG_LEN - 1: 0] mem_read_data,
	input [REG_LEN - 1: 0] alu_result,
	input [REG_LEN - 1: 0] f_result,
	input [REG_LEN - 1: 0] fs_data,
	input [REG_LEN - 1: 0] rt_data,
	output [4:0] rd_in,
	output [4:0] fd_in,
	output [REG_LEN - 1: 0] f_write_data,
	output [REG_LEN - 1: 0] write_data
);


parameter REG_LEN = 32;

wire [REG_LEN - 1: 0] mem_or_alu, pre_write_data;
wire [4:0] pre_rd_in, pre_fd_in;

MUX #( .INPUT_LEN(REG_LEN) )
 mux_pc_jal(
	.in1(adder_pc_out),
	.in0(mem_or_alu),
	.out(pre_write_data),
	.select(jal)
);

MUX #( .INPUT_LEN(REG_LEN) )
 mux_f_to_w(
	.in1(fs_data),
	.in0(pre_write_data),
	.out(write_data),
	.select(f_to_w)
);

MUX #( .INPUT_LEN(REG_LEN) )
 mux_w_to_f(
	.in1(rt_data),
	.in0(f_result),
	.out(f_write_data),
	.select(w_to_f)
);


MUX #( .INPUT_LEN(32) )
 mux_mem(
	.in1(mem_read_data),
	.in0(alu_result),
	.out(mem_or_alu),
	.select(mem_to_reg)
);


MUX #(.INPUT_LEN(5))
mux_jal0(
	.in1(5'b11111),
	.in0(write_reg),
	.out(pre_rd_in),
	.select(jal)
);

MUX #(.INPUT_LEN(5))
mux_jal1(
	.in1(rt),
	.in0(pre_rd_in),
	.out(rd_in),
	.select(f_to_w)
);

MUX #(.INPUT_LEN(5))
ah(
	.in1(fs),
	.in0(f_write_reg),
	.out(fd_in),
	.select(w_to_f)
);


endmodule
