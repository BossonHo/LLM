module johnson_counter_64 (
    input  wire        clk,    // Clock
    input  wire        rst,    // Active-high synchronous reset
    output reg [63:0]  q       // 64-bit Johnson counter output
);

always @(posedge clk or posedge rst) begin
    if (rst)
        q <= 64'b0;  // Reset to all zeros
    else
        q <= {~q[63], q[62:0]};  // Shift right and feed inverted MSB to LSB
end

always @(posedge clk) begin
    if (q == 64'b1_1111_1100_1000_0000 || q == 64'b0_0001_0011_1111_1110_1100_1000_1111)
        $display("Cyclic State Reached");
end

endmodule