module button_handler (
    input  logic button_0,
    input  logic button_1,
    input  logic clk_100,
    input  logic s_rst,
    input  logic a_rst,
    
    output logic next_count,
    output logic start_send
);

    logic prev_btn_0, prev_btn_1;

    always_ff @(posedge clk_100 or posedge a_rst) begin
        if (a_rst) begin
            next_count <= 0;
            start_send <= 0;
            prev_btn_0 <= 0;
            prev_btn_1 <= 0;
        end else if (s_rst) begin
            next_count <= 0;
            start_send <= 0;
            prev_btn_0 <= 0;
            prev_btn_1 <= 0;
        end else begin
            next_count <= prev_btn_0 && ~button_0;
            start_send <= prev_btn_1 && ~button_1;
            prev_btn_0 <= button_0;
            prev_btn_1 <= button_1;
        end
    end
    
endmodule