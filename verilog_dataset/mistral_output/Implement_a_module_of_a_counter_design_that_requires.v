module controlled_counter (
    input        clk,
    input        rst,
    input        valid_count,
    output reg [3:0] count
);

always @(posedge clk) begin
    if (rst) begin
        count <= 4'd0;
    end else if (valid_count) begin
        if (count == 4'd12)
            count <= 4'd0;
        else
            count <= count + 1;
    end
end