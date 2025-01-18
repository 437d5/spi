module transmitter_tb;

    localparam int P_DATA_WIDTH = 8;
    localparam int P_CLK_DIV    = 1;
    localparam int P_CS_POLAR   = 0;

    logic valid;
    logic [P_DATA_WIDTH - 1:0] data;
    logic clk_100;
    logic s_rst;
    logic a_rst;

    logic ready;
    logic MOSI;
    logic CS;
    logic SCK_HP;
    logic SCK_LP;
    logic SCK_HN;
    logic SCK_LN;

    initial clk_100 = 0;
    always #5 clk_100 = ~clk_100; 
    transmitter #(
        .P_DATA_WIDTH(P_DATA_WIDTH),
        .P_CLK_DIV(P_CLK_DIV),
        .P_CS_POLAR(P_CS_POLAR)
    ) dut (
        .valid(valid),
        .data(data),
        .clk_100(clk_100),
        .s_rst(s_rst),
        .a_rst(a_rst),
        .ready(ready),
        .MOSI(MOSI),
        .CS(CS),
        .SCK_HP(SCK_HP),
        .SCK_LP(SCK_LP),
        .SCK_HN(SCK_HN),
        .SCK_LN(SCK_LN),
    );

    initial begin
        valid = 0;
        data = 0;
        s_rst = 0;
        a_rst = 0;
        a_rst = 1;
        #20;
        a_rst = 0;
        s_rst = 1;
        #20;
        s_rst = 0;

        // Test case 1: Send single data byte
        data = 8'hF0; // Example data
        valid = 1;
        #20 valid = 0;

// Test case 3: Check chip select polarity
        $display("CS = %b, Expected = %b", CS, P_CS_POLAR ? 1'b1 : 1'b0);

        // Test case 4: Observe clock signals
        #200;

        // Finish simulation
        $finish;
    end

    // Monitor signals
    initial begin
        $monitor("Time=%0t, valid=%b, data=%h, ready=%b, MOSI=%b, CS=%b, SCK_HP=%b, SCK_LP=%b, SCK_HN=%b, SCK_LN=%b", 
                 $time, valid, data, ready, MOSI, CS, SCK_HP, SCK_LP, SCK_HN, SCK_LN);
    end

    
endmodule