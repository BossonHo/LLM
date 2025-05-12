module unsigned_multiplier_8bit (
    input clk,
    input rst,
    input [7:0] A,
    input [7:0] B,
    output reg [15:0] P
);

    // Stage 1: Register Inputs
    reg [7:0] A_reg1, B_reg1;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            A_reg1 <= 8'd0;
            B_reg1 <= 8'd0;
        end else begin
            A_reg1 <= A;
            B_reg1 <= B;
        end
    end

    // Stage 2: Generate Partial Products
    reg [15:0] partial_products [7:0];
    integer i;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < 8; i = i + 1)
                partial_products[i] <= 16'd0;
        end else begin
            for (i = 0; i < 8; i = i + 1)
                partial_products[i] <= (B_reg1[i]) ? ({8'd0, A_reg1} << i) : 16'd0;
        end
    end

    // Stage 3: Sum Partials using Tree Adder (Two Levels)
    reg [15:0] sum1, sum2, sum3, sum4;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sum1 <= 16'd0;
            sum2 <= 16'd0;
            sum3 <= 16'd0;
            sum4 <= 16'd0;
        end else begin
            sum1 <= partial_products[0] + partial_products[1];
            sum2 <= partial_products[2] + partial_products[3];
            sum3 <= partial_products[4] + partial_products[5];
            sum4 <= partial_products[6] + partial_products[7];
        end
    end

    // Stage 4: Final Addition
    reg [15:0] final_sum;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            final_sum <= 16'd0;
            P <= 16'd0;
        end else begin
            final_sum <= (sum1 + sum2) + (sum3 + sum4);
            P <= final_sum;
        end
    end

endmodule