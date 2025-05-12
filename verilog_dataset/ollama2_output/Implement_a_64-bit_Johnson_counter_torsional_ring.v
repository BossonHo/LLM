module johnson_counter_64 (
    input  wire        clk,
    input  wire        rst,
    output reg [63:0]  q
);

always @(posedge clk or posedge rst) begin
    if (rst)
        q <= 64'b0;
    else
        q <= {~q[63], q[63:1]};
end

endmodule