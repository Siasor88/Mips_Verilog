module IF(
    input jump,
    input branch,
    input and_out,
    input jr_select,
    input stall,
    input clk,
	input [25: 0] mem_addr_im,
    input [REG_LEN - 1: 0] rs_data,
    input [REG_LEN - 1: 0] adder_jump_addr_imm,
    output [REG_LEN - 1: 0] inst_addr,
    output [REG_LEN - 1: 0] adder_pc_out
);

parameter REG_LEN = 32;


/* verilator lint_off UNOPTFLAT */
wire [REG_LEN - 1: 0]
	mux_jump_addr_imm,
	pc_in,
    jmp_addr,
    mux_jr_in0;
wire [27:0] mem_addr_im_times_4;

assign mem_addr_im_times_4 = {mem_addr_im, 2'b0};
assign jmp_addr = { inst_addr[31:28] , mem_addr_im_times_4};




PC pcr(.in(pc_in), .out(inst_addr), .clk(clk), .stall(stall));


Adder adder_pc(
	.in1(inst_addr),
	.in2(32'd4),
	.c_in(1'b0),
	.c_out(),
	.sum(adder_pc_out)
);


MUX #( .INPUT_LEN(REG_LEN) )
 mux_shafal(
	.in0(adder_pc_out),
	.in1(adder_jump_addr_imm),
	.out(mux_jump_addr_imm),
	.select(and_out)
);


MUX #( .INPUT_LEN(REG_LEN) )
 mux_pc(
	.in1(jmp_addr),
	.in0(mux_jump_addr_imm),
	.out(mux_jr_in0),
	.select(jump)
);

MUX #( .INPUT_LEN(REG_LEN) )
	mux_jr(
		.in0(mux_jr_in0),
		.in1(rs_data),
		.out(pc_in),
		.select(jr_select)
	);



endmodule
