module MA(
    input clk,
    // input mem_to_reg,
    input mem_write,
    input mem_read,
    input is_byte,
    input [7:0] mem_data_out [0:3],
    input [31:0] rt_data,
    input[31:0] alu_result,
    output control_ready,
    output mem_write_en,
    output mem_stall,
    output [31:0] read_data,
    output [7:0] mem_data_in[0:3],

    output [31:0] mem_addr
    // output [31:0] write_data_to_jal
);
wire cache_write_en;
wire [31:0] cache_addr;

wire [7:0] cache_data_in [0:3];
wire [7:0] cache_data_out [0:3];
wire cache_controller_enable;

assign read_data = {{cache_data_out[3]}, {cache_data_out[2]}, {cache_data_out[1]}, {cache_data_out[0]}};
assign cache_addr = alu_result;

assign cache_data_in[0] = rt_data[7:0];
assign cache_data_in[1] = rt_data[15:8];
assign cache_data_in[2] = rt_data[23:16];
assign cache_data_in[3] = rt_data[31:24];
assign cache_write_en = mem_write & (!mem_read);


// MUX #( .INPUT_LEN(32) )
//  mux_mem(
// 	.in1(read_data),
// 	.in0(alu_result),
// 	.out(write_data_to_jal),
// 	.select(mem_to_reg)
// );

MA_CU ma_cu(
    .mem_write(mem_write),
    .mem_read(mem_read),
    .clk(clk),
    .mem_ready(control_ready),
    .mem_stall(mem_stall),
    .cache_controller_enable(cache_controller_enable)
);

CacheController cache_controller(
    .clk(clk),
    .addr(cache_addr),
    .data_in(cache_data_in),
    .data_out(cache_data_out),
    .mem_data_in(mem_data_in),
    .mem_data_out(mem_data_out),
    .mem_addr(mem_addr),
    .we(cache_write_en),
    .we_mem(mem_write_en),
    .ready(control_ready),
	.enable(cache_controller_enable),
	.is_byte(is_byte)
);



endmodule
