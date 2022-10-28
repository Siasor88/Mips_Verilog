module MemStage (
    clk,
    cache_addr,
    cache_data_in,
    cache_data_out,
    mem_data_in,
    mem_data_out,
    mem_addr,
    cache_write_en,
    mem_write_en,
    control_ready, 
    is_byte,
    cache_controller_enable
);

input clk, cache_write_en, cache_controller_enable, is_byte;
input [31 : 0] cache_addr;
input [7 : 0] cache_data_in[0 : 3];
output [7 : 0] mem_data_in[0 : 3];

output [7 : 0] cache_data_out[0 : 3];
input [7 : 0] mem_data_out[0 : 3];
output [31 : 0] mem_addr;
output control_ready, mem_write_en;

CacheController cache_controller( // mio
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