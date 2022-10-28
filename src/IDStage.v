module ID(
    input clk,
    input rst_b,
    input halted,
    input reg_write,
    input extender,
    input stall,
    input [4:0] rd_in,
    input [31:0] inst,
    input [31:0] write_data,
    output jr_select,
    output [4:0] shamt,
    output [4:0] rd,
    output [4:0] rt,
    output [4:0] ft,
    output [4:0] fs,
    output [4:0] fd,
    output [4:0] f_format,
    output [5:0] opcode,
    output [5:0] func,
    output [25:0] mem_addr_im,
    output [31:0] sign_out,
    output [31:0] rs_data,
    output [31:0] rt_data,
    output [15:0] im_data
);

assign jr_select = !(|opcode) && (func == 6'b001000);
wire [4:0] rs;

InstructionDecoder id(
	.instruction(inst),
	.opcode(opcode),
	.rd(rd),
	.rs(rs),
	.rt(rt),
    .ft(ft),
    .fs(fs),
    .fd(fd),
    .f_format(f_format),
	.im(im_data),
	.shamt(shamt),
	.mem_addr(mem_addr_im),
	.func(func)
);

regfile rgf(
    .rs_data(rs_data),
    .rt_data(rt_data),
    .rs_num(rs),
    .rt_num(rt),
    .rd_num(rd_in),
    .rd_data(write_data),
    .rd_we(reg_write),
    .clk(clk),
    .rst_b(rst_b),
    .is_float(0),
	.halted(halted)
);


// ALU zero_detector(
// 	.a(rs_data),
// 	.b(alu_in),
// 	.ALU_control(alu_control),
// 	.result(alu_result),
// 	.zero(zero),
// 	.ishift(ishift),
// 	.shamt(shamt),
// 	.overflow(),
// 	.alu_stall(alu_stall)
// );


endmodule
