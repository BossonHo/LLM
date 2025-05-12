module pipelined_multiplier_8bit(
    input clk,
    input rst,
    input [7:0] A,
    input [7:0] B,
    output reg [15:0] P
);

reg [7:0] A_reg1, B_reg1;
reg [15:0] partial_products [7:0];
reg [15:0] sum1, sum2, sum3, sum4;
reg [15:0] final_sum;

always @(posedge clk or posedge rst) begin
    if (rst)
        A_reg1 <= 8'd0,
                B_reg1 <= 8'd0,
                partial_products[0] <= 16'd0,
                partial_products[1] <= 16'd0,
                partial_products[2] <= 16'd0,
                partial_products[3] <= 16'd0,
                partial_products[4] <= 16'd0,
                partial_products[5] <= 16'd0,
                partial_products[6] <= 16'd0,
                partial_products[7] <= 16'd0,
                sum1 <= 16'd0,
                sum2 <= 16'd0,
                sum3 <= 16'd0,
                sum4 <= 16'd0,
                final_sum <= 16'd0,
                P <= 16'd0;
    else
        A_reg1 <= A[7:0],
                 B_reg1 <= B[7:0],
                 partial_products[0] <= (B_reg1[7]) ? ({8'd0, A_reg1} << 7) : 16'd0,
                 partial_products[1] <= (B_reg1[6]) ? ({8'd0, A_reg1} << 6) : 16'd0,
                 partial_products[2] <= (B_reg1[5]) ? ({8'd0, A_reg1} << 5) : 16'd0,
                 partial_products[3] <= (B_reg1[4]) ? ({8'd0, A_reg1} << 4) : 16'd0,
                 partial_products[4] <= (B_reg1[3]) ? ({8'd0, A_reg1} << 3) : 16'd0,
                 partial_products[5] <= (B_reg1[2]) ? ({8'd0, A_reg1} << 2) : 16'd0,
                 partial_products[6] <= (B_reg1[1]) ? ({8'd0, A_reg1} << 1) : 16'd0,
                 partial_products[7] <= (B_reg1[0]) ? ({8'd0, A_reg1}) : 16'd0,

            sum1 <= partial_products[0] + partial_products[1],
            sum2 <= partial_products[2] + partial_products[3],
            sum3 <= partial_products[4] + partial_products[5],
            sum4 <= partial_products[6] + partial_products[7],

            final_sum <= (sum1 + sum2) + (sum3 + sum4),
            P <= final_sum;
end

endmodule