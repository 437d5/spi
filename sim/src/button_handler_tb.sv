module button_handler_tb;

    logic button_0, button_1;
    logic clk_100;
    logic s_rst, a_rst;
    wire  next_count;
    wire  start_send;

    always #5 clk_100 = ~clk_100;

    button_handler dut (
        .button_0(button_0),
        .button_1(button_1),
        .clk_100(clk_100),
        .s_rst(s_rst),
        .a_rst(a_rst),
        .next_count(next_count),
        .start_send(start_send)
    );

    initial begin
        button_0 = 0;
        button_1 = 0;
        clk_100  = 0;
        s_rst    = 0;
        a_rst    = 1;

        #10 a_rst = 0;
        button_0 = 1;

        #10 button_0 = 0;
            button_1 = 1;
        #10 button_1 = 0;


        $dumpfile("test.vcd");
        $dumpvars;
        #10 $finish;
    end

endmodule