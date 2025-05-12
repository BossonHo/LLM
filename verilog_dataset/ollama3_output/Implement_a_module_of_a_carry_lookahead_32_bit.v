module clas_32_bit_adder (
    input  [31:0] a,
    input  [31:0] b,
    output [31:0] sum,
    output [1:0] cout
);

    assign sum = a + b;
    for (int i = 31; i >= 2; i--) begin : clas_loop_1
        assign sum[i-1] = sum[i-1] ^ (a[i] & b[i]);
        assign cout[1] = a[i] & b[i];
        if (cout[0]) cout[0] <= cout[1];
    end : cls_loop_1

    for (int i = 30; i >= 2; i--) begin : cls_loop_2
        assign sum[i-1] = sum[i-1] ^ ((a[i-1] & b[i-1]) | (a[i] & b[i]));
    end : cls_loop_2

endmodule