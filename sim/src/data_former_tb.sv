module data_former_tb;

    localparam int P_DATA_WIDTH = 8;

    // Testbench signals
    logic   next_count, start_send;
    logic   clk_100;
    logic   s_rst, a_rst;
    logic   ready;
    wire    valid;
    wire    [P_DATA_WIDTH-1:0] data;

    // Instantiate the DUT (Device Under Test)
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

    // Clock generation
    always #5 clk_100 = ~clk_100;

    // Testbench procedure
    initial begin
        // Initialize signals
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
        $display("Data sent: %0d, Valid = %0b", data, valid);


        #10 next_count = 1;
        #30 next_count = 0;
        #10 start_send = 1;
        ready          = 1;
        #10 start_send = 0;
        ready          = 0;
        $display("New data sent: %0d, Valid = %0b", data, valid);

        #10 start_send = 1;
        #20 start_send = 0;
        $display("Data attempt sent without ready. Valid = %0b", valid);

        // Finish simulation
        #50 $finish;
    end

endmodule
