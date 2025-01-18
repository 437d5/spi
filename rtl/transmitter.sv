/*
    Module transmitter is used as SPI Master.
    It recieves data from data former with ready/valid handshake.
    Output is data from data_former (MOSI)
              chip select           (CS)
              4 clocks with different phase and
              default state         (SKC_*)
    Output is syncronized with SCK_HP
*/
module transmitter #(
    P_DATA_WIDTH = 8, // width of data former
    P_CLK_DIV    = 2, // clk divider parameter
    P_CS_POLAR   = 0 // 1 - high, 0 - low 
) (
    input   logic                           valid,   // valid from data former
    input   logic    [P_DATA_WIDTH - 1:0]   data,    // data from data former
    input   logic                           clk_100, // global clk
    input   logic                           s_rst,   // sync reset
    input   logic                           a_rst,   // async reset

    output  logic                           ready,   // ready to recieve new data
    output  logic                           MOSI,    // Master output slave input
    output  logic                           CS,      // Chip select
    output  logic                           SCK_HP,  // 1, posedge
    output  logic                           SCK_LP,  // 0, posedge
    output  logic                           SCK_HN,  // 1, negedge
    output  logic                           SCK_LN   // 0, negedge
);

    logic busy; // 1 if sending/recieving
    logic [$clog2(P_DATA_WIDTH):0] data_cnt; // count number of bits sent
    logic [P_DATA_WIDTH-1:0] shift_reg;

    assign ready = ~busy;
    assign CS = (P_CS_POLAR == 1) ? busy : ~busy;

    // clk divider counters
    logic [$clog2(P_DATA_WIDTH)-1:0] clk_pos_cnt;
    logic [$clog2(P_DATA_WIDTH)-1:0] clk_neg_cnt;
    // clk divider and output clocks former for pos phase
    always_ff @(posedge clk_100 or posedge a_rst) begin
        if (a_rst) begin
            clk_pos_cnt <= '0;
            SCK_HP <= 1;
            SCK_LP <= 0;
        end else if (s_rst) begin
            clk_pos_cnt <= '0;
            SCK_HP <= 1;
            SCK_LP <= 0;
        end else begin
            if (clk_pos_cnt == P_CLK_DIV - 1) begin
                clk_pos_cnt <= '0;
                SCK_HP <= ~SCK_HP;
                SCK_LP <= ~SCK_LP;
            end else begin
                clk_pos_cnt <= clk_pos_cnt + 1'b1;
            end
        end
    end

    // clk divider and output clocks former for neg phase
    always_ff @(negedge clk_100 or posedge a_rst) begin
        if (a_rst) begin
            clk_neg_cnt <= '0;
            SCK_HN <= 1;
            SCK_LN <= 0;
        end else if (s_rst) begin
            clk_neg_cnt <= '0;
            SCK_HN <= 1;
            SCK_LN <= 0;
        end else begin
            if (clk_neg_cnt == P_CLK_DIV - 1) begin
                clk_neg_cnt <= '0;
                SCK_HN <= ~SCK_HN;
                SCK_LN <= ~SCK_LN;
            end else begin
                clk_neg_cnt <= clk_neg_cnt + 1'b1;
            end
        end
    end

    // Send data to output
    always_ff @(posedge clk_100 or posedge a_rst) begin
        if (a_rst) begin
            shift_reg <= 0;
            data_cnt  <= 1;
            busy      <= 0;
            MOSI      <= 0;
        end else if (s_rst) begin
            shift_reg <= 0;
            data_cnt  <= 1;
            busy      <= 0;
            MOSI      <= 0;
        end else begin
            // receive data
            if (valid && ready) begin
                shift_reg <= data;
                data_cnt <= P_DATA_WIDTH;
                busy <= 1;
            // begin to send data
            end else if (busy) begin
                // syncronize with output clk
                if (SCK_HP) begin
                    MOSI <= shift_reg[P_DATA_WIDTH-1];
                    shift_reg <= shift_reg << 1;
                    data_cnt <= data_cnt - 1;

                    // shif_reg is empty
                    if (data_cnt == 0) begin
                        busy <= 0;
                        MOSI <= 0;
                    end
                end
            end
        end
    end

endmodule