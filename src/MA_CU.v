module MA_CU(
    input mem_write,
    input mem_read,
    input clk,
    input mem_ready,
    output reg mem_stall,
    output reg cache_controller_enable
);
    reg state = 0;

    initial begin
        state = 0;
    end

    always @(negedge clk)
    begin
        if (state == 0)
        begin
            if (mem_read || mem_write)
            begin
                cache_controller_enable <= 1;
                state <= 1;
                mem_stall <= 1;
            end
        end  
        else
        begin
            if (mem_ready)
            begin
                mem_stall <= 0;
                state <= 0;
                cache_controller_enable <= 0;
            end
        end      
    end


    // initial begin
    //     cache_controller_enable = 0;
    //     state = 0;
    // end

    // initial begin
    //     $monitor("%d", state);
    // end

    // always @(posedge clk)
    // begin
    //     if(state == 0)
    //         state <= 1;
    //     else if(state == 1)
    //         state <= 2;
    //     else if(state == 2)
    //         state <= 3;
    //     else if(state == 3)
    //     begin
    //         cache_controller_enable <= 1;
    //         state <= 4;
    //     end
    //     else if(state == 4)
    //     begin
    //         if (mem_ready)
    //             state <= 5;
    //     end
    //     else if(state == 5)
    //     begin
    //         cache_controller_enable <= 0;
    //         state <= 0;
    //     end
    // end
endmodule