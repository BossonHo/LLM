module freq_divider (
    input  wire clk_in,      // 100MHz input clock
    input  wire rst,         // Active-high synchronous reset
    output reg  clk_50MHz,   // 繩2 output (50MHz)
    output reg  clk_10MHz,   // 繩10 output (10MHz)
    output reg  clk_1MHz     // 繩100 output (1MHz)
);

    always @(posedge clk_in) begin
        if (rst)
            clk_50MHz <= 0;
        else
            clk_50MHz <= ~clk_50MHz;
    end

    assign clk_10MHz = ~clk_50MHz;

    reg [5:0] cnt_1MHz;
    always @(posedge clk_in) begin
        if (rst)
            cnt_1MHz  <= 0;
        else if (cnt_1MHz == 48) begin
            cnt_1MHz  <= 0;
            clk_1MHz  <= ~clk_1MHz;
        end else begin
            cnt_1MHz <= cnt_1MHz + 1;
        end
    end

    assign clk_1MHz = ~cnt_1MHz;

endmodule