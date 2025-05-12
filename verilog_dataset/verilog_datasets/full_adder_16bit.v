module full_adder (
    input  a,
    input  b,
    input  cin,
    output sum,
    output cout
);
    assign {cout, sum} = a + b + cin;
endmodule

module full_adder_16bit (
    input  [15:0] a,
    input  [15:0] b,
    input         cin,
    output [15:0] sum,
    output        cout
);
    wire [15:0] carry;

    // First full adder
    full_adder fa0 (
        .a(a[0]), .b(b[0]), .cin(cin),
        .sum(sum[0]), .cout(carry[0])
    );

    // Remaining 15 full adders
    genvar i;
    generate
        for (i = 1; i < 16; i = i + 1) begin : adder_chain
            full_adder fa (
                .a(a[i]), .b(b[i]), .cin(carry[i-1]),
                .sum(sum[i]), .cout(carry[i])
            );
        end
    endgenerate

    assign cout = carry[15];

endmodule
