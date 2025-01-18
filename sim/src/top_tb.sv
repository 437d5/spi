module top_tb;

    localparam int P_DATA_WIDTH = 8;
    localparam int P_CS_POLAR   = 1;
    localparam int P_CLK_DIV    = 1;

    logic clk_100;
    logic a_rst, s_rst;
    logic button_0, button_1;

    wire SCK_HP;
    // uncomment if want to check all clocks
    // wire SCK_HN, SCK_LN, SCK_LP; 
    wire CS, MOSI;

    SPI_core # (
        .P_DATA_WIDTH(P_DATA_WIDTH),
        .P_CLK_DIV(P_CLK_DIV),
        .P_CS_POLAR(P_CS_POLAR)
    ) dut (
        .button_0(button_0),
        .button_1(button_1),
        .clk_100(clk_100),
        .a_rst(a_rst),
        .s_rst(s_rst),

        .SCK_HP(SCK_HP),
        // uncomment if want to check all clocks
        // .SCK_LP(SCK_LP),
        // .SCK_HN(SCK_HN),
        // .SCK_LN(SCK_LN),
        .CS(CS),
        .MOSI(MOSI)
    );

    always #5 clk_100 = ~clk_100;

    initial begin
        clk_100 = 0;
        a_rst = 0;
        s_rst = 0;
        button_0 = 0;
        button_1 = 0;

        #5 a_rst = 1;
        #10 a_rst = 0;
        button_0 = 1;
        #10 button_0 = 0;
        button_1 = 1;
        #10 button_1 = 0;
        wait (CS == 1);
        wait (CS == 0);
        #50 $finish;
    end

endmodule