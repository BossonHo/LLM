module frequency_divider (
    input wire clk_in,      // input clock with frequency 100MHz
    input wire rst,         // active-high synchronous reset
    output reg  clk_50MHz,   // output clock with frequency 50MHz
    output reg  clk_10MHz,   // output clock with frequency 10MHz
    output reg  clk_1MHz     // output clock with frequency 1MHz
);

    // Divide-by-2 counter
    always @(posedge clk_in) begin
        if (rst)
            clk_50MHz <= 0;
        else
            clk_50MHz <= ~clk_50MHz;
    end

    // Divide-by-10 counter (for 10MHz)
    reg [2:0] cnt_10MHz;
    always @(posedge clk_in) begin
        if (rst) begin
            cnt_10MHz  <= 0;
            clk_10MHz  <= 0;
        end else if (cnt_10MHz == 4) begin
            cnt_10MHz  <= 0;
            clk_10MHz  <= ~clk_10MHz;
        end else begin
            cnt_10MHz <= cnt_10MHz + 1;
        end
    end

    // Divide-by-100 counter (for 1MHz)
    reg [6:0] cnt_1MHz;
    always @(posedge clk_in) begin
        if (rst) begin
            cnt_1MHz  <= 0;
            clk_1MHz  <= 0;
        end else if (cnt_1MHz == 49) begin
            cnt_1MHz  <= 0;
            clk_1MHz  <= ~clk_1MHz;
        end else begin
            cnt_1MHz <= cnt_1MHz + 1;
        end
    end

endmodule