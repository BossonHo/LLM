module johnson_counter_64 (
    input  wire        clk,    // Clock
    input  wire        rst,    // Active-high synchronous reset
    output reg [63:0]  q       // 64-bit Johnson counter output
);

    always @(posedge clk or posedge rst) begin
        if (rst)
            q <= 64'b0;  // Reset to all zeros
        else
            q <= {~q[63], q[63:1]};  // Shift right and feed inverted MSB to LSB
    end

endmodule
