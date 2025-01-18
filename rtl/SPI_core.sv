module SPI_core #(
    P_DATA_WIDTH = 8,
    P_CLK_DIV    = 1,
    P_CS_POLAR   = 1
) (
    input  logic button_0,
    input  logic button_1,
    input  logic clk_100,
    input  logic a_rst,
    input  logic s_rst,

    output logic SCK_HP,
    output logic SCK_LP,
    output logic SCK_HN,
    output logic SCK_LN,
    output logic CS,
    output logic MOSI
);

    // button handler -> data former
    wire next_count, start_send;
    
    // data former -> transmitter
    wire ready, valid;
    wire [P_DATA_WIDTH-1:0] data;

    button_handler inst0 (
        .button_0(button_0),
        .button_1(button_1),
        .clk_100(clk_100),
        .a_rst(a_rst),
        .s_rst(s_rst),

        .next_count(next_count),
        .start_send(start_send)
    );

    data_former # (
        .P_DATA_WIDTH(P_DATA_WIDTH)
    ) inst1 (
        .next_count(next_count),
        .start_send(start_send),
        .clk_100(clk_100),
        .a_rst(a_rst),
        .s_rst(s_rst),
        .ready(ready),

        .valid(valid),
        .data(data)
    );

    transmitter # (
        .P_DATA_WIDTH(P_DATA_WIDTH),
        .P_CLK_DIV(P_CLK_DIV),
        .P_CS_POLAR(P_CS_POLAR)
    ) inst2 (
        .valid(valid),
        .data(data),
        .clk_100(clk_100),
        .a_rst(a_rst),
        .s_rst(s_rst),

        .ready(ready),
        .SCK_HP(SCK_HP),
        .SCK_LP(SCK_LP),
        .SCK_HN(SCK_HN),
        .SCK_LN(SCK_LN),
        .CS(CS),
        .MOSI(MOSI)
    );
    
endmodule