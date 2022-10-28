module CacheMemory(
    addr,
    data_in,
    data_out,
    hit,
    is_evicted,
    evicted_tag,
    we,
    from_mem,
    enable,
    ready
);




//initial $monitor("time: %t, data: %h, dirty: %d",$time(), data_mem_array[4], dirty_bit_mem_array[4]);


input we, enable, from_mem;
input [31:0] addr;
input [7 : 0] data_in[0 : 3];

output reg [7 : 0] data_out[0 : 3];
output reg hit, ready, is_evicted;
output reg [19 - 1 : 0] evicted_tag;

reg  valid_bit_mem_array [(1 << 11) - 1 : 0];
reg  dirty_bit_mem_array [(1 << 11) - 1 : 0];
reg [19 - 1 : 0] tag_mem_array [(1 << 11) - 1 : 0];
reg [32 - 1 : 0] data_mem_array [(1 << 11) - 1 : 0];
reg v_tmp, d_tmp;
reg [19 - 1 : 0] t_tmp;
reg [32 - 1 : 0] data_tmp;

wire [19 - 1 : 0] tag_addr;
wire [11 - 1: 0] block_addr;

assign block_addr = addr[31 - 19 : 31 - 19 - 11 + 1];
assign tag_addr = addr[31 : 31 - 19 + 1];

initial begin
    integer i;
    for ( i = 0; i < (1<<11); i = i + 1) begin
        valid_bit_mem_array[i] = 0;
        dirty_bit_mem_array[i] = 0;
    end
end

// TODO: Assign

always @(posedge enable) begin
    ready = 0;
    is_evicted = 0;

    v_tmp = valid_bit_mem_array[block_addr];
    d_tmp = dirty_bit_mem_array[block_addr];
    t_tmp = tag_mem_array[block_addr];
    data_tmp = data_mem_array[block_addr];

    if(!we) begin
        if(v_tmp && (t_tmp == tag_addr)) begin
            data_out[0] = data_tmp[7 : 0];
            data_out[1] = data_tmp[15 : 8];
            data_out[2] = data_tmp[23 : 16];
            data_out[3] = data_tmp[31 : 24];
            hit = 1;
        end
        else begin
            hit = 0;
        end
    end
    else begin
        if(v_tmp && d_tmp && (t_tmp != tag_addr)) begin
            data_out[0] = data_tmp[7 : 0];
            data_out[1] = data_tmp[15 : 8];
            data_out[2] = data_tmp[23 : 16];
            data_out[3] = data_tmp[31 : 24];
            evicted_tag = t_tmp;
            is_evicted = 1;
        end
        data_mem_array[block_addr] = {data_in[3], data_in[2], data_in[1], data_in[0]};
        valid_bit_mem_array[block_addr] = 1'b1;
        dirty_bit_mem_array[block_addr] = !from_mem;
        tag_mem_array[block_addr] = tag_addr;
    end
    ready = 1;
end

endmodule
