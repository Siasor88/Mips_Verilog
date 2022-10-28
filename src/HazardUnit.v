module HazardUnit(
    input halted,
    input mem_stall,
    input cache_controller_enable,
    input mem_ready,
    output reg halt_stall,
    output reg stall
);



    /* verilator lint_off LATCH */
    always @(halted, cache_controller_enable, mem_ready)
    begin
        if (halted)
            halt_stall = 1;

        if(mem_stall)
        begin
            stall = 1;
        end
        else
        begin
            stall = 0;
        end
    end


endmodule