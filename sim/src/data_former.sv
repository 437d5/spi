// Module data_former is used to generate
// data for testing SPI transmitter.
// When next_count is high module add 1 to cnt.
// When start_send and ready are high it sends cnt as data
// and rises signal valid to 1.
module data_former # (
    parameter P_DATA_WIDTH = 8
) (
    input  logic                      next_count;
    input  logic                      start_send;
    input  logic                      clk_100;
    input  logic                      s_rst;
    input  logic                      a_rst;
    input  logic                      ready;
            
    output logic                      valid;
    output logic [P_DATA_WIDTH - 1:0] data;
);

    logic [P_DATA_WIDTH - 1:0] cnt;

    always_ff @( posedge clk_100 or posedge a_rst ) begin
        if (a_rst) begin
            valid <=  0;
            cnt   <= '0;
        end else if (s_rst) begin
            valid <=  0;
            cnt   <= '0;
        end else begin
            
            if (next_count) begin
                cnt <= cnt + 1'b1;
            end

            // TODO: test if valid sets to 0 after sending data
            if (start_send) begin
                if (ready) begin
                    valid <= '1;
                    data <= cnt;
                end
            end

            valid <= 0;
        end
    end

endmodule