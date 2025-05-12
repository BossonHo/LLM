module counter (
    input        clk,           // Clock input
    input        rst,           // Active-high synchronous reset
    input        valid_count,   // Control signal for counting
    output reg [3:0] count      // 4-bit counter output
);

always @(posedge clk) begin
    if (rst) begin
        count <= 4'd0;
    end else if (!valid_count) begin
        count <= count;
    end else if (count == 4'd12)
        count <= 4'd0;
    else
        count <= count + 1;
end

endmodule