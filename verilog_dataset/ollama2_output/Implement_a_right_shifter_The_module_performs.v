module right_shifter (
    input clk,
    input d,
    output reg [7:0] q
);

    always @(posedge clk) begin
        q <= (q >> 1);  // Right shift
        q[7] <= d;      // Insert new bit at MSB
    end

endmodule