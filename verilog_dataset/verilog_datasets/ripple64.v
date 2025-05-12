module pipelined_ripple_adder_64bit (
    input clk,
    input rst,
    input [63:0] A,
    input [63:0] B,
    output reg [63:0] Sum,
    output reg done
);

    // Stage 1 registers
    reg [15:0] A_s1, B_s1;
    reg [15:0] sum_s1;
    reg carry_s1;

    // Stage 2 registers
    reg [15:0] A_s2, B_s2;
    reg [15:0] sum_s2;
    reg carry_s2;
    
    // Stage 3 registers
    reg [15:0] A_s3, B_s3;
    reg [15:0] sum_s3;
    reg carry_s3;

    // Stage 4 registers
    reg [15:0] A_s4, B_s4;
    reg [15:0] sum_s4;
    reg carry_s4;
    
    // Final carry and sum pipeline
    reg [15:0] s1_final, s2_final, s3_final, s4_final;
    reg [3:0] valid;

    // Carry lookahead
    function [16:0] ripple_add_16;
        input [15:0] x, y;
        input c_in;
        reg [16:0] result;
        begin
            result = x + y + {15'b0, c_in}; // Extend c_in to 16 bits
            ripple_add_16 = result;
        end
    endfunction

    always @(posedge clk or posedge rst) begin
        reg [16:0] result_s1, result_s2, result_s3, result_s4; // Declare result variables here
        if (rst) begin
            // Resetting all variables with non-blocking assignments
            {sum_s1, carry_s1, sum_s2, carry_s2, sum_s3, carry_s3, sum_s4, carry_s4} <= 0;
            {s1_final, s2_final, s3_final, s4_final} <= 0;
            valid <= 0;
            Sum <= 0;
            done <= 0;
        end else begin
            // Stage 1: bits [15:0]
            result_s1 <= ripple_add_16(A[15:0], B[15:0], 1'b0);
            sum_s1 <= result_s1[15:0];
            carry_s1 <= result_s1[16];

            A_s2 <= A[31:16]; B_s2 <= B[31:16];

            // Stage 2: bits [31:16]
            result_s2 <= ripple_add_16(A_s2, B_s2, carry_s1);
            sum_s2 <= result_s2[15:0];
            carry_s2 <= result_s2[16];

            A_s3 <= A[47:32]; B_s3 <= B[47:32];

            // Stage 3: bits [47:32]
            result_s3 <= ripple_add_16(A_s3, B_s3, carry_s2);
            sum_s3 <= result_s3[15:0];
            carry_s3 <= result_s3[16];

            A_s4 <= A[63:48]; B_s4 <= B[63:48];

            // Stage 4: bits [63:48]
            result_s4 <= ripple_add_16(A_s4, B_s4, carry_s3);
            sum_s4 <= result_s4[15:0];
            carry_s4 <= result_s4[16];

            // Output sum
            s1_final <= sum_s1;
            s2_final <= sum_s2;
            s3_final <= sum_s3;
            s4_final <= sum_s4;

            Sum <= {s4_final, s3_final, s2_final, s1_final};

            // Track when output is valid
            valid <= {valid[2:0], 1'b1};
            done <= valid[3];
        end
    end
endmodule
