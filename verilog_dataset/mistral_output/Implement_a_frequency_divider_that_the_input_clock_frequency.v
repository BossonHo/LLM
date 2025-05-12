module freq_divider (
    input  wire clk_in,      // 100MHz input clock
    input  wire rst,         // Active-high synchronous reset
    output reg  clk_50MHz,   // 繩2 output (50MHz)
    output reg  clk_10MHz,   // 繩10 output (10MHz)
    output reg  clk_1MHz     // 繩100 output (1MHz)
);

// Divide-by-2 counter
always @(posedge clk_in) begin
    if (rst)
        clk_50MHz <= 0;
    else
        clk_50MHz <= ~clk_50MHz;
end

// Divide-by-10 counter (for 10MHz)
reg [3:0] cnt_10MHz;
always @(posedge clk_50MHz) begin
    if (rst) begin
        cnt_10MHz <= 4'b0;
        clk_10MHz <= 0;
    end else if (cnt_10MHz == 5) begin
        cnt_10MHz <= 4'b0;
        clk_10MHz <= ~clk_10MHz;
    end else begin
        cnt_10MHz <= cnt_10MHz + 1;
    end
end

// Divide-by-100 counter (for 1MHz)
reg [6:0] cnt_1MHz;
always @(posedge clk_10MHz) begin
    if (rst) begin
        cnt_1MHz <= 7'b0;
        clk_1MHz <= 0;
    end else if (cnt_1MHz == 98) begin
        cnt_1MHz <= 7'b0;
        clk_1MHz <= ~clk_1MHz;
    end else begin
        cnt_1MHz <= cnt_1MHz + 1;
    end
end

endmodule