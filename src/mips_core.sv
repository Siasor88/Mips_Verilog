module mips_core(
    inst_addr,
    inst,
    mem_addr,
    mem_data_out,
    mem_data_in,
    mem_write_en,
    halted,
    clk,
    rst_b
);

output  [31:0] inst_addr;
input   [31:0] inst;
output  [31:0] mem_addr;
reg     [31:0] cache_addr;
input   [7:0]  mem_data_out[0:3];
reg     [7:0]  cache_data_out[0:3];
output  [7:0]  mem_data_in[0:3];
reg     [7:0]  cache_data_in[0:3];
output         mem_write_en;
reg            cache_write_en;
output 	       halted;
input          clk;
input          rst_b;


parameter REG_LEN = 32;

	wire jump, branch, and_out, jr_select, jr_select_2_3;
	wire [REG_LEN - 1 : 0] adder_pc_out, adder_jump_addr_imm, mem_ad, inst_addr;
	wire [REG_LEN - 1 : 0] inst_1_2, inst_2_3, adder_pc_out_1_2, adder_pc_out_2_3, adder_pc_out_3_4, adder_pc_out_4_5;

	wire jr_select;
	wire [4:0] alu_control;
    wire [4:0] shamt, shamt_2_3;
    wire [4:0] rd,  rd_2_3;
    wire [4:0] rt, rt_2_3, rt_3_4, rt_4_5;
    wire [4:0] ft_2_3, fd_2_3;
	wire [4:0] ft, fs, fd;
	wire [4:0] fs_2_3, fs_3_4, fs_4_5;
	wire [4:0] f_format, f_format_2_3;
    wire [5:0] opcode, opcode_2_3;
    wire [5:0] func, func_2_3;
    wire [25:0] mem_addr_im, mem_addr_im_2_3;
    wire [31:0] sign_out, sign_out_2_3;
    /* verilator lint_off UNOPTFLAT */
    wire [31:0] rs_data, rs_data_2_3;
    wire [31:0] fs_data, fs_data_2_3, fs_data_3_4, fs_data_4_5;
    /* verilator lint_off UNOPTFLAT */
    wire [31:0] rt_data, rt_data_2_3, rt_data_3_4, rt_data_4_5;
    wire [31:0] ft_data, ft_data_2_3, ft_data_3_4;
    wire [15:0] im_data, im_data_2_3;

	wire halted_2, halted_2_3, halted_3_4;
	wire and_out, and_out_3_4;
	wire mem_stall, stall;
	wire [4:0] write_reg, write_reg_3_4, write_reg_4_5;
	wire [4:0] f_write_reg, f_write_reg_3_4, f_write_reg_4_5;
	wire [31 : 0] alu_result, alu_result_3_4, alu_result_4_5;
	wire [31 : 0] f_result, f_result_3_4, f_result_4_5;
	wire [31 : 0] adder_jump_addr_imm, adder_jump_addr_imm_3_4;

	wire [31:0] write_data, f_write_data;
	wire [4:0] rd_in, fd_in;
	wire halt_stall;

	wire reg_dst, reg_dst_2_3,
	  jump,
	  branch, branch_2_3,
	  reg_write_2_3, reg_write_3_4, reg_write_4_5,
	  f_reg_write_2_3, f_reg_write_3_4, f_reg_write_4_5,
	  mem_read, mem_read_2_3, mem_read_3_4,
	  mem_to_reg, mem_to_reg_2_3, mem_to_reg_3_4, mem_to_reg_4_5,
	  mem_write, mem_write_2_3, mem_write_3_4,
	  alu_src, alu_src_2_3,
	  reg_write,
	  f_reg_write,
	  extender, extender_2_3,
	  cache_controller_enable, cache_controller_enable_2_3, cache_controller_enable_3_4,
	  stall_pc,
	  alu_stall,
	  halted,
	  is_byte, is_byte_2_3, is_byte_3_4,
	  jal, jal_2_3, jal_3_4, jal_4_5,
	  f_to_w, f_to_w_2_3, f_to_w_3_4, f_to_w_4_5,
	  w_to_f, w_to_f_2_3, w_to_f_3_4, w_to_f_4_5;
    wire [5:0] alu_op, alu_op_2_3;


//#################################################################################################################################################################

Coprocessor coprocessor(
	.halted(halted),
	.fs(fs),
	.ft(ft),
	.fs_data_2_3(fs_data_2_3),
	.ft_data_2_3(ft_data_2_3),
	.fd_in(fd_in),
	.f_write_data(f_write_data),
	.alu_control(alu_control),
	.reg_write(f_reg_write_4_5),
	.clk(clk),
	.rst_b(rst_b),
	.stall(stall),
	.fs_data(fs_data),
	.ft_data(ft_data),
	.f_result(f_result)
);

HazardUnit hazard_unit(
	.halted(halted_2),
	.mem_stall(mem_stall),
	.mem_ready(control_ready),
	.cache_controller_enable(cache_controller_enable),
    .halt_stall(halt_stall),
    .stall(stall)
);

IF instruction_fetch_stage(
    /* input */ .jump(jump),
    /* input */ .branch(branch),
    /* input */ .and_out(and_out_3_4),
    /* input */ .jr_select(jr_select_2_3),
    /* input */ .stall(halt_stall | stall),
    /* input */ .clk(clk),
	/* input [25:0] */  .mem_addr_im(mem_addr_im),
    /* input [31:0] */  .rs_data(rs_data_2_3),
    /* input [31:0] */  .adder_jump_addr_imm(adder_jump_addr_imm_3_4),
    /* output [31:0] */ .inst_addr(inst_addr),
    /* output [31:0] */ .adder_pc_out(adder_pc_out)
);

Pipe #(.INPUT_LEN(REG_LEN))  instruction_1_2_pipe(.clk(clk), .stall(halt_stall | stall), .inputs(inst), .outputs(inst_1_2));
Pipe #(.INPUT_LEN(REG_LEN))  adder_pc_out_1_2_pipe(.clk(clk), .stall(halt_stall | stall), .inputs(adder_pc_out), .outputs(adder_pc_out_1_2));

//#################################################################################################################################################################


Signal_control Signal_control(
	.opcode(opcode),
	.inst(inst_1_2),
	.clk(clk),
	.reg_dst(reg_dst),
	.alu_src(alu_src),
	.mem_read(mem_read),
	.is_byte(is_byte),
	.mem_to_reg(mem_to_reg),
	.extend(extender),
	.alu_op(alu_op),
	.branch(branch),
	.reg_write(reg_write),
	.f_reg_write(f_reg_write),
	.jump(jump),
	.jal(jal),
	.w_to_f(w_to_f),
	.f_to_w(f_to_w),
	.is_f(),
	.halted(halted_2),
	.mem_write(mem_write)
);



ID instruction_decoder_stage(
    /* input */ .clk(clk),
    /* input */ .rst_b(rst_b),
    /* input */ .halted(halted),
    /* input */ .reg_write(reg_write_4_5),
    /* input */ .extender(extender),
	/* input */ .stall(stall),
    /* input [4:0] */ .rd_in(rd_in),
    /* input [31:0] */  .inst(inst_1_2),
    /* input [31:0] */  .write_data(write_data),
    /* output */ .jr_select(jr_select),
    /* output [4:0] */ .shamt(shamt),
    /* output [4:0] */ .rd(rd),
    /* output [4:0] */ .rt(rt),
    /* output [4:0] */ .fd(fd),
    /* output [4:0] */ .ft(ft),
	/* output [4:0] */ .fs(fs),
	/* output [4:0] */ .f_format(f_format),
    /* output [5:0] */ .opcode(opcode),
    /* output [5:0] */ .func(func),
    /* output [15:0] */ .im_data(im_data),
    /* output [25:0] */ .mem_addr_im(mem_addr_im),
    /* output [31:0] */ .sign_out(sign_out),
    /* output [31:0] */ .rs_data(rs_data),
    /* output [31:0] */ .rt_data(rt_data)
);
	Pipe #(.INPUT_LEN(REG_LEN)) rs_data_2_3_pipe(.clk(clk), .stall(stall), .inputs(rs_data), .outputs(rs_data_2_3));
	Pipe #(.INPUT_LEN(REG_LEN)) fs_data_2_3_pipe(.clk(clk), .stall(stall), .inputs(fs_data), .outputs(fs_data_2_3));
	Pipe #(.INPUT_LEN(REG_LEN)) rt_data_2_3_pipe(.clk(clk), .stall(stall), .inputs(rt_data), .outputs(rt_data_2_3));
	Pipe #(.INPUT_LEN(REG_LEN)) sign_out_2_3_pipe(.clk(clk), .stall(stall), .inputs(sign_out), .outputs(sign_out_2_3));
	Pipe #(.INPUT_LEN(REG_LEN)) ft_data_2_3_pipe(.clk(clk), .stall(stall), .inputs(ft_data), .outputs(ft_data_2_3));

	Pipe #(.INPUT_LEN(26)) mem_addr_im_2_3_pipe(.clk(clk), .stall(stall), .inputs(mem_addr_im), .outputs(mem_addr_im_2_3));
	Pipe #(.INPUT_LEN(6)) func_2_3_pipe(.clk(clk), .stall(stall), .inputs(func), .outputs(func_2_3));
	Pipe #(.INPUT_LEN(5)) f_format_2_3_pipe(.clk(clk), .stall(stall), .inputs(f_format), .outputs(f_format_2_3));
	Pipe #(.INPUT_LEN(6)) opcode_2_3_pipe(.clk(clk), .stall(stall), .inputs(opcode), .outputs(opcode_2_3));
	Pipe #(.INPUT_LEN(5)) ft_2_3_pipe(.clk(clk), .stall(stall), .inputs(ft), .outputs(ft_2_3) );
	Pipe #(.INPUT_LEN(5)) fd_2_3_pipe(.clk(clk), .stall(stall), .inputs(fd), .outputs(fd_2_3) );
	Pipe #(.INPUT_LEN(5)) fs_2_3_pipe(.clk(clk), .stall(stall), .inputs(fs), .outputs(fs_2_3) );
	Pipe #(.INPUT_LEN(5)) rt_2_3_pipe(.clk(clk), .stall(stall), .inputs(rt), .outputs(rt_2_3) );
	Pipe #(.INPUT_LEN(5)) rd_2_3_pipe(.clk(clk), .stall(stall), .inputs(rd), .outputs(rd_2_3) );
	Pipe #(.INPUT_LEN(5)) shamt_2_3_pipe(.clk(clk), .stall(stall), .inputs(shamt), .outputs(shamt_2_3));
	Pipe #(.INPUT_LEN(16)) im_data_2_3_pipe(.clk(clk), .stall(stall), .inputs(im_data), .outputs(im_data_2_3));
	Pipe #(.INPUT_LEN(REG_LEN))  instruction_2_3_pipe(.clk(clk), .stall(stall), .inputs(inst_1_2), .outputs(inst_2_3));
	Pipe #(.INPUT_LEN(REG_LEN))  adder_pc_out_2_3_pipe(.clk(clk), .stall(stall), .inputs(adder_pc_out_1_2), .outputs(adder_pc_out_2_3));

	Pipe #(.INPUT_LEN(6)) alu_op_2_3_pipe(.clk(clk), .stall(stall), .inputs(alu_op), .outputs(alu_op_2_3));
	Pipe #(.INPUT_LEN(1)) mem_to_reg_2_3_pipe(.clk(clk), .stall(stall), .inputs(mem_to_reg), .outputs(mem_to_reg_2_3));
	Pipe #(.INPUT_LEN(1)) jal_2_3_pipe(.clk(clk), .stall(stall), .inputs(jal), .outputs(jal_2_3));
	Pipe #(.INPUT_LEN(1)) mem_write_2_3_pipe(.clk(clk), .stall(stall), .inputs(mem_write), .outputs(mem_write_2_3));
	Pipe #(.INPUT_LEN(1)) mem_read_2_3_pipe(.clk(clk), .stall(stall), .inputs(mem_read), .outputs(mem_read_2_3));
	Pipe #(.INPUT_LEN(1)) is_byte_2_3_pipe(.clk(clk), .stall(stall), .inputs(is_byte), .outputs(is_byte_2_3));
	Pipe #(.INPUT_LEN(1)) reg_dst_2_3_pipe(.clk(clk), .stall(stall), .inputs(reg_dst), .outputs(reg_dst_2_3));
	Pipe #(.INPUT_LEN(1)) alu_src_2_3_pipe(.clk(clk), .stall(stall), .inputs(alu_src), .outputs(alu_src_2_3));
	Pipe #(.INPUT_LEN(1)) extender_2_3_pipe(.clk(clk), .stall(stall), .inputs(extender), .outputs(extender_2_3));
	Pipe #(.INPUT_LEN(1)) branch_2_3_pipe(.clk(clk), .stall(stall), .inputs(branch), .outputs(branch_2_3));
	Pipe #(.INPUT_LEN(1)) reg_write_2_3_pipe(.clk(clk), .stall(stall), .inputs(reg_write), .outputs(reg_write_2_3));
	Pipe #(.INPUT_LEN(1)) f_reg_write_2_3_pipe(.clk(clk), .stall(stall), .inputs(f_reg_write), .outputs(f_reg_write_2_3));
	Pipe #(.INPUT_LEN(1)) halted_2_3_pipe(.clk(clk), .stall(stall), .inputs(halted_2), .outputs(halted_2_3));
	Pipe #(.INPUT_LEN(1)) w_to_f_2_3_pipe(.clk(clk), .stall(stall), .inputs(w_to_f), .outputs(w_to_f_2_3));
	Pipe #(.INPUT_LEN(1)) f_to_w_2_3_pipe(.clk(clk), .stall(stall), .inputs(f_to_w), .outputs(f_to_w_2_3));
	Pipe #(.INPUT_LEN(1)) jr_select_2_3_pipe(.clk(clk), .stall(stall), .inputs(jr_select), .outputs(jr_select_2_3));

//#################################################################################################################################################################


	Exe execution_stage(
    /* input */ .reg_dst(reg_dst_2_3),
    /* input */ .alu_src(alu_src_2_3),
    /* input */ .stall(0), // ??? TODO
    /* input */ .extender(extender_2_3),
    /* input */ .branch(branch_2_3),
	/* input [4:0] */ .rd(rd_2_3),
    /* input [4:0] */ .ft(ft_2_3),
	/* input [4:0] */ .fd(fd_2_3),
    /* input [4:0] */ .rt(rt_2_3),
    /* input [4:0] */ .shamt(shamt_2_3),
    /* input [5:0] */ .func(func_2_3),
    /* input [4:0] */ .f_format(f_format_2_3),
    /* input [5:0] */ .alu_op(alu_op_2_3),
    /* input [31:0] */  .inst(inst_2_3),
    /* input [31:0] */  .rt_data(rt_data_2_3),
    /* input [31:0] */  .rs_data(rs_data_2_3),

    /* input [31:0] */  .adder_pc_out(adder_pc_out_2_3),
    /* output */ .and_out(and_out),
    /* output [4:0] */ .write_reg(write_reg),
    /* output [4:0] */ .f_write_reg(f_write_reg),
    /* output [4:0] */ .alu_control(alu_control),
    /* output [31:0] */ .alu_result(alu_result),
    /* output [31:0] */ .adder_jump_addr_imm(adder_jump_addr_imm)
);


	Pipe #(.INPUT_LEN(REG_LEN)) alu_result_3_4_pipe(.clk(clk), .stall(stall), .inputs(alu_result), .outputs(alu_result_3_4));
	Pipe #(.INPUT_LEN(REG_LEN)) f_result_3_4_pipe(.clk(clk), .stall(stall), .inputs(f_result), .outputs(f_result_3_4));
	Pipe #(.INPUT_LEN(REG_LEN)) rt_data_3_4_pipe(.clk(clk), .stall(stall), .inputs(rt_data_2_3), .outputs(rt_data_3_4));
	Pipe #(.INPUT_LEN(REG_LEN)) fs_data_3_4_pipe(.clk(clk), .stall(stall), .inputs(fs_data_2_3), .outputs(fs_data_3_4));
	Pipe #(.INPUT_LEN(5)) fs_3_4_pipe(.clk(clk), .stall(stall), .inputs(fs_2_3), .outputs(fs_3_4) );
	Pipe #(.INPUT_LEN(5)) rt_3_4_pipe(.clk(clk), .stall(stall), .inputs(rt_2_3), .outputs(rt_3_4) );
	Pipe #(.INPUT_LEN(REG_LEN)) adder_jump_addr_imm_3_4_pipe(.clk(clk), .stall(stall), .inputs(adder_jump_addr_imm), .outputs(adder_jump_addr_imm_3_4));
	Pipe #(.INPUT_LEN(1)) and_out_3_4_pipe(.clk(clk), .stall(stall), .inputs(and_out), .outputs(and_out_3_4));
	Pipe #(.INPUT_LEN(5)) write_reg_3_4_pipe(.clk(clk), .stall(stall), .inputs(write_reg), .outputs(write_reg_3_4));
	Pipe #(.INPUT_LEN(5)) f_write_reg_3_4_pipe(.clk(clk), .stall(stall), .inputs(f_write_reg), .outputs(f_write_reg_3_4));
	Pipe #(.INPUT_LEN(REG_LEN))  adder_pc_out_3_4_pipe(.clk(clk), .stall(stall), .inputs(adder_pc_out_2_3), .outputs(adder_pc_out_3_4));

	Pipe #(.INPUT_LEN(1)) mem_to_reg_3_4_pipe(.clk(clk), .stall(stall), .inputs(mem_to_reg_2_3), .outputs(mem_to_reg_3_4));
	Pipe #(.INPUT_LEN(1)) jal_3_4_pipe(.clk(clk), .stall(stall), .inputs(jal_2_3), .outputs(jal_3_4));
	Pipe #(.INPUT_LEN(1)) mem_write_3_4_pipe(.clk(clk), .stall(stall), .inputs(mem_write_2_3), .outputs(mem_write_3_4));
	Pipe #(.INPUT_LEN(1)) mem_read_3_4_pipe(.clk(clk), .stall(stall), .inputs(mem_read_2_3), .outputs(mem_read_3_4));
	Pipe #(.INPUT_LEN(1)) is_byte_3_4_pipe(.clk(clk), .stall(stall), .inputs(is_byte_2_3), .outputs(is_byte_3_4));
	Pipe #(.INPUT_LEN(1)) halted_3_4_pipe(.clk(clk), .stall(stall), .inputs(halted_2_3), .outputs(halted_3_4));
	Pipe #(.INPUT_LEN(1)) w_to_f_3_4_pipe(.clk(clk), .stall(stall), .inputs(w_to_f_2_3), .outputs(w_to_f_3_4));
	Pipe #(.INPUT_LEN(1)) f_to_w_3_4_pipe(.clk(clk), .stall(stall), .inputs(f_to_w_2_3), .outputs(f_to_w_3_4));
	Pipe #(.INPUT_LEN(1)) reg_write_3_4_pipe(.clk(clk), .stall(stall), .inputs(reg_write_2_3), .outputs(reg_write_3_4));
	Pipe #(.INPUT_LEN(1)) f_reg_write_3_4_pipe(.clk(clk), .stall(stall), .inputs(f_reg_write_2_3), .outputs(f_reg_write_3_4));

//#################################################################################################################################################################

	MA memory_access_stage(
    /* input */ .clk(clk),
    /* input */ .mem_write(mem_write_3_4),
    /* input */ .mem_read(mem_read_3_4),
    /* input */ .is_byte(is_byte_3_4),
    /* input [7:0] [0:3] */  .mem_data_out(mem_data_out), // ????
    /* input [31:0] */ .rt_data(rt_data_3_4),
	/* input [31:0] */ .alu_result(alu_result_3_4),
    /* output */ .control_ready(control_ready),
	/* output */ .mem_write_en(mem_write_en),
	/* output */ .mem_stall(mem_stall),
	/* output [7:0] [0:3]*/  .mem_data_in(mem_data_in),
    /* output [31:0] */ .read_data(mem_read_data),
    /* output [31:0] */ .mem_addr(mem_addr)
);
	wire control_ready;
	wire [31:0] mem_read_data, mem_read_data_4_5;


	Pipe #(.INPUT_LEN(REG_LEN)) alu_result_4_5_pipe(.clk(clk), .stall(stall), .inputs(alu_result_3_4), .outputs(alu_result_4_5));
	Pipe #(.INPUT_LEN(REG_LEN)) f_result_4_5_pipe(.clk(clk), .stall(stall), .inputs(f_result_3_4), .outputs(f_result_4_5));
	Pipe #(.INPUT_LEN(REG_LEN)) mem_read_data_4_5_pipe(.clk(clk), .stall(stall), .inputs(mem_read_data), .outputs(mem_read_data_4_5));
	Pipe #(.INPUT_LEN(REG_LEN))  adder_pc_out_4_5_pipe(.clk(clk), .stall(stall), .inputs(adder_pc_out_3_4), .outputs(adder_pc_out_4_5));
	Pipe #(.INPUT_LEN(5)) write_reg_4_5_pipe(.clk(clk), .stall(stall), .inputs(write_reg_3_4), .outputs(write_reg_4_5));
	Pipe #(.INPUT_LEN(5)) f_write_reg_4_5_pipe(.clk(clk), .stall(stall), .inputs(f_write_reg_3_4), .outputs(f_write_reg_4_5));
	Pipe #(.INPUT_LEN(REG_LEN)) rt_data_4_5_pipe(.clk(clk), .stall(stall), .inputs(rt_data_3_4), .outputs(rt_data_4_5));
	Pipe #(.INPUT_LEN(REG_LEN)) fs_data_4_5_pipe(.clk(clk), .stall(stall), .inputs(fs_data_3_4), .outputs(fs_data_4_5));
	Pipe #(.INPUT_LEN(5)) fs_4_5_pipe(.clk(clk), .stall(stall), .inputs(fs_3_4), .outputs(fs_4_5) );
	Pipe #(.INPUT_LEN(5)) rt_4_5_pipe(.clk(clk), .stall(stall), .inputs(rt_3_4), .outputs(rt_4_5) );

	Pipe #(.INPUT_LEN(1)) w_to_f_4_5_pipe(.clk(clk), .stall(stall), .inputs(w_to_f_3_4), .outputs(w_to_f_4_5));
	Pipe #(.INPUT_LEN(1)) f_to_w_4_5_pipe(.clk(clk), .stall(stall), .inputs(f_to_w_3_4), .outputs(f_to_w_4_5));
	Pipe #(.INPUT_LEN(1)) mem_to_reg_4_5_pipe(.clk(clk), .stall(stall), .inputs(mem_to_reg_3_4), .outputs(mem_to_reg_4_5));
	Pipe #(.INPUT_LEN(1)) jal_4_5_pipe(.clk(clk), .stall(stall), .inputs(jal_3_4), .outputs(jal_4_5));
	Pipe #(.INPUT_LEN(1)) halted_4_5_pipe(.clk(clk), .stall(stall), .inputs(halted_3_4), .outputs(halted));
	Pipe #(.INPUT_LEN(1)) reg_write_4_5_pipe(.clk(clk), .stall(stall), .inputs(reg_write_3_4), .outputs(reg_write_4_5));
	Pipe #(.INPUT_LEN(1)) f_reg_write_4_5_pipe(.clk(clk), .stall(stall), .inputs(f_reg_write_3_4), .outputs(f_reg_write_4_5));


//#################################################################################################################################################################

	WB write_back_state(
	/* input */ .jal(jal_4_5),
	/* input */ .fs(fs_4_5),
	/* input */ .rt(rt_4_5),
	/* input */ .f_to_w(f_to_w_4_5),
	/* input */ .w_to_f(w_to_f_4_5),
	/* input */ .mem_to_reg(mem_to_reg_4_5),
	/* input [4:0] */ .write_reg(write_reg_4_5),
	/* input [4:0] */ .f_write_reg(f_write_reg_4_5),
	/* input [REG_LEN - 1: 0] */ .fs_data(fs_data_4_5),
	/* input [REG_LEN - 1: 0] */ .rt_data(rt_data_4_5),
	/* input [REG_LEN - 1: 0] */ .mem_read_data(mem_read_data_4_5),
	/* input [REG_LEN - 1: 0] */ .alu_result(alu_result_4_5),
	/* input [REG_LEN - 1: 0] */ .f_result(f_result_4_5),
	/* input [REG_LEN - 1: 0] */ .adder_pc_out(adder_pc_out_4_5),
	/* output [4:0] */ .rd_in(rd_in),
	/* output [4:0] */ .fd_in(fd_in),
	/* output [REG_LEN - 1: 0] */ .write_data(write_data),
	/* output [REG_LEN - 1: 0] */ .f_write_data(f_write_data)
);

endmodule

