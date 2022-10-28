module Exe(
    input reg_dst,
    input alu_src,
    input stall,
    input extender,
    input branch,
    input [4:0] shamt,
    input [5:0] func,
    input [4:0] f_format,
    input [5:0] alu_op,
    input [31:0] inst,
    input [31:0] rt_data,
    input [31:0] rs_data,
    input [4:0] rd,
    input [4:0] rt,
    input [4:0] fd,
    input [4:0] ft,
    input [31: 0] adder_pc_out,
    output and_out,
    output [4 : 0] write_reg,
    output [4 : 0] f_write_reg,
    output [31 : 0] alu_result,
	output [4:0] alu_control,
    output [31 : 0] adder_jump_addr_imm
);
parameter REG_LEN = 32;

wire [31:0] alu_in;
wire ishift, zero;
wire[31:0] sign_out;
wire [31:0] jump_addr_imm;
assign jump_addr_imm = sign_out << 2;

and(and_out, zero, branch);

ALU alu(
	.a(rs_data),
	.b(alu_in),
	.alu_control(alu_control),
	.result(alu_result),
	.zero(zero),
	.ishift(ishift),
	.shamt(shamt),
	.overflow()
);

ALUControl aluControl(
	.alu_op(alu_op),
	.func(func),
	.f_format(f_format),
	.alu_control(alu_control),
	.ishift(ishift)
);

Adder adder_jump_and_addr_imm(
	.in1(jump_addr_imm),
	.in2(adder_pc_out),
	.c_in(1'b0),
	.c_out(),
	.sum(adder_jump_addr_imm)
);

MUX #(.INPUT_LEN(5))
mux_reg(
	.in1(rd),
	.in0(rt),
	.out(write_reg),
	.select(reg_dst)
);

MUX #(.INPUT_LEN(5))
f_mux_reg(
	.in1(fd),
	.in0(ft),
	.out(f_write_reg),
	.select(reg_dst)
);

MUX #( .INPUT_LEN(REG_LEN) )
 mux_alu(
	.in1(sign_out),
	.in0(rt_data),
	.out(alu_in),
	.select(alu_src)
);





SignExtender
 signext(
	.in(inst[15:0]),
	.out(sign_out),
	.extend(extender)
);




endmodule
