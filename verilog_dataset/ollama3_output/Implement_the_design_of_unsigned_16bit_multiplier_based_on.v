module shift_add_multiplier_16bit (
    input clk,
    input rst,
    input start,
    input [15:0] A,
    input [15:0] B,
    output reg [31:0] P,
    output reg done
);

reg [15:0] multiplicand;
reg [15:0] multiplier;
reg [31:0] product;
reg [4:0] count; // log2(16) = 4, use 5 bits for safety
reg busy;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        P <= 32'd0;
        product <= 32'd0;
        multiplicand <= 16'd0;
        multiplier <= 16'd0;
        count <= 5'd0;
        busy <= 1'b0;
        done <= 1'b0;
    end else begin
        if (start && !busy) begin
            multiplicand <= A;
            multiplier <= B;
            product <= 32'd0;
            count <= 5'd0;
            busy <= 1'b1;
            done <= 1'b0;
        end else if (busy) begin
            if (multiplier[0] == 1'b1)
                product <= product + {16'd0, multiplicand};

            multiplicand <= multiplicand << 1;
            multiplier <= multiplier >> 1;
            count <= count + 1;

            if (count == 15) begin
                busy <= 1'b0;
                done <= 1'b1;
                P <= product + ((multiplier[0]) ? {16'd0, multiplicand} : 32'd0);
            end
        end else begin
            done <= 1'b0;
        end
    end
endmodule