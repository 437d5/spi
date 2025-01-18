module data_former_tb;

    localparam int P_DATA_WIDTH = 8;

    logic   next_count, start_send;
    logic   clk_100;
    logic   s_rst, a_rst;
    logic   ready;
    wire    valid;
    wire    [P_DATA_WIDTH-1:0] data;

    data_former #(
        .P_DATA_WIDTH(P_DATA_WIDTH)
    ) dut (
        .next_count     (next_count),
        .start_send     (start_send),
        .clk_100        (clk_100),
        .s_rst          (s_rst),
        .a_rst          (a_rst),
        .ready          (ready),
        .valid          (valid),
        .data           (data)
    );

    always #5 clk_100 = ~clk_100;

    initial begin
        next_count     = 0;
        start_send     = 0;
        clk_100        = 0;
        s_rst          = 0;
        a_rst          = 0;
        ready          = 0;

        #10 a_rst = 1;
        #10 a_rst = 0;


        #10 next_count = 1;
        #20 next_count = 0;

        #10 start_send = 1;
            ready      = 1;
        #10 start_send = 0;
            ready      = 0;


        #10 next_count = 1;
        #30 next_count = 0;
        #10 start_send = 1;
        ready          = 1;
        #10 start_send = 0;
        ready          = 0;

        #10 start_send = 1;
        #20 start_send = 0;

        #50 $finish;
    end

endmodule
