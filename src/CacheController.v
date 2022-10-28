module CacheController(
    clk,
    addr,
    data_in,
    data_out,
    mem_data_in,
    mem_data_out,
    mem_addr,
    we,
    we_mem,
    ready,
    is_byte,
    enable
);

parameter LAG = 4;

input clk, we, enable, is_byte;
input [31 : 0] addr;
input [7 : 0] data_in[0 : 3];
output reg [7 : 0] mem_data_in[0 : 3];

output reg [7 : 0] data_out[0 : 3];
input [7 : 0] mem_data_out[0 : 3];
output reg [31 : 0] mem_addr;
output reg ready, we_mem;

reg hit, is_evicted, cache_we, cache_enable, from_mem;
reg [19 - 1 : 0] evicted_tag;
reg [7 : 0] cache_data_out[0 : 3];
reg [7 : 0] cache_data_in[0 : 3];
reg [32 - 1 : 0] cache_addr;


reg [3:0] state;
initial state = 0;

wire cache_ready;


CacheMemory cache_memory(
    .addr(cache_addr),
    .data_in(cache_data_in),
    .data_out(cache_data_out),
    .hit(hit),
    .is_evicted(is_evicted),
    .evicted_tag(evicted_tag),
    .we(cache_we),
    .from_mem(from_mem),
    .enable(cache_enable),
    .ready(cache_ready)
);



reg[3:0] counter;


localparam INIT = 4'd0;
localparam WRITE_CACHE = 4'd1;
localparam MEM_WAIT_READ = 4'd2;
localparam MEM_WAIT_WRITE = 4'd3;
localparam READ_CACHE = 4'd4;




localparam BYTE_INIT = 4'd0;
localparam READ_BYTE_FROM_CACHE = 4'd6;

localparam READ_BLOCK_FROM_MEM = 4'd7;
localparam BYTE_MEM_WAIT_WRITE = 4'd8;

localparam WRITE_BYTE_ON_CACHE = 4'd9;
localparam WRITE_NEW_BLOCK_CACHE = 4'd10;
localparam SIK = 4'd11;


reg flag = 0;

//initial $monitor("flag: %d", flag);
//initial $monitor("time: %t, data_in: %h", $time(), data_in[0]);
//initial $monitor("time: %t, state: %d, ready: %d", $time(), state, ready);
initial cache_enable = 0;

always @(posedge clk) begin
    if(!is_byte) begin
        cache_addr <= addr;
        case(state)
            INIT: begin
                if(enable) begin
                    from_mem <= 0;
                    ready <= 1'b0;
                    cache_we <= we;
                    state <= we ? WRITE_CACHE : READ_CACHE;
                    if(we) cache_data_in <= data_in;
                    cache_enable <= 1;
                end
                else begin
                    state <= INIT;
                    cache_enable <= 0;
                     ready <= 0;
                end
            end

            READ_CACHE: begin
                cache_enable <= 0;
                if(hit) begin
                    data_out <= cache_data_out;
                    ready <= 1;
                    state <= INIT;
                end
                else begin
                    mem_addr <= addr;
                    we_mem <= 0;
                    counter <= 0;
                    state <= MEM_WAIT_READ;
                end
            end

            MEM_WAIT_READ: begin
                counter <= counter + 1;
                if(counter == LAG) begin
                    cache_we <= 1;
                    from_mem <= 1;

                    cache_data_in <= mem_data_out;
                    data_out <= mem_data_out;

                    state <= WRITE_CACHE;

                    cache_enable <= 1;

                end else state <= MEM_WAIT_READ;
            end

            WRITE_CACHE: begin
                cache_enable <= 0;
                if(is_evicted) begin
                    mem_addr <= {evicted_tag, addr[31 - 19 : 31 - 19 - 11 + 1], 2'b00};
                    mem_data_in <= cache_data_out;
                    we_mem <= 1;
                    counter <= 0;
                    state <= MEM_WAIT_WRITE;
                end
                else begin
                    ready <= 1;
                    state <= INIT;
                end
            end

            MEM_WAIT_WRITE: begin
                counter <= counter + 1;
                if(counter == LAG) begin
                    cache_enable <= 0;
                    ready <= 1;
                    state <= INIT;
                end else state <= MEM_WAIT_WRITE;
            end
            default: ready <= 0;
        endcase
    end
    else begin
        case(state)
            BYTE_INIT: begin
                if(enable) begin
                    cache_addr <= {addr[31:2], 2'b00};
                    cache_we <= 0;
                    state <= READ_BYTE_FROM_CACHE;
                    cache_enable <= 1;
                    ready <= 0;
                end
                else begin
                    state <= BYTE_INIT;
                    cache_enable <= 0;
                    ready <= 0;
                end
            end

            READ_BYTE_FROM_CACHE: begin
                cache_enable <= 0;
                if(hit) begin
                    if (!we) begin
                        data_out[0] <= cache_data_out[3 - addr[1:0]];
                        data_out[1] <= {8{cache_data_out[3 - addr[1:0]][7]}};
                        data_out[2] <= {8{cache_data_out[3 - addr[1:0]][7]}};
                        data_out[3] <= {8{cache_data_out[3 - addr[1:0]][7]}};

                        ready <= 1;
                        state <= BYTE_INIT;
                    end else begin
                        state <= WRITE_BYTE_ON_CACHE;
                    end
                end else begin
                    mem_addr <= {addr[31:2], 2'b00};
                    counter <= 0;
                    we_mem <= 0;
                    state <= READ_BLOCK_FROM_MEM;
                end
            end


            READ_BLOCK_FROM_MEM: begin
                counter <= counter + 1;
                if(counter == LAG) begin
                    cache_we <= 1;

                    cache_addr <= {addr[31:2], 2'b00};
                    cache_data_in <= mem_data_out;

                    if(we) begin
                        from_mem <= 0;
                        cache_data_in[3 - addr[1:0]] <= data_in[0];
                    end
                    else begin
                        from_mem <= 1;

                        data_out[0] <= mem_data_out[3 - addr[1:0]];
                        data_out[1] <= {8{mem_data_out[3 - addr[1:0]][7]}};
                        data_out[2] <= {8{mem_data_out[3 - addr[1:0]][7]}};
                        data_out[3] <= {8{mem_data_out[3 - addr[1:0]][7]}};
                    end

                    state <= WRITE_NEW_BLOCK_CACHE;

                    cache_enable <= 1;

                end else state <= READ_BLOCK_FROM_MEM;
            end

            WRITE_NEW_BLOCK_CACHE: begin
                cache_enable <= 0;
                if (is_evicted) begin
                    mem_addr <= {evicted_tag, addr[31 - 19 : 31 - 19 - 11 + 1], 2'b00};
                    mem_data_in <= cache_data_out;
                    we_mem <= 1;
                    counter <= 0;
                    state <= BYTE_MEM_WAIT_WRITE;
                end else begin
                    ready <= 1;
                    state <= BYTE_INIT;
                end
            end

            BYTE_MEM_WAIT_WRITE: begin
                counter <= counter + 1;
                cache_enable <= 0;
                if(counter == LAG) begin
                    ready <= 1;
                    state <= BYTE_INIT;
                end else state <= BYTE_MEM_WAIT_WRITE;
            end


            WRITE_BYTE_ON_CACHE: begin
                cache_addr <= {addr[31:2], 2'b00};

                cache_data_in[0] <= cache_data_out[0];
                cache_data_in[1] <= cache_data_out[1];
                cache_data_in[2] <= cache_data_out[2];
                cache_data_in[3] <= cache_data_out[3];

                /*
                meow
                meow
                meow
                meow
                meow
                */
                from_mem <= 0;
                cache_data_in[3 - addr[1:0]] <= data_in[0];
                cache_we <= 1;

                cache_enable <= 1;

                /****************************************************************
                */
                state <= SIK;
            end

            SIK: begin
                cache_enable <= 0;
                ready <= 1;
                state <= BYTE_INIT;

            end

            default: begin
                state <= BYTE_INIT;
                ready <= 0;
                cache_enable <= 0;
            end

        endcase

    end



end

endmodule
