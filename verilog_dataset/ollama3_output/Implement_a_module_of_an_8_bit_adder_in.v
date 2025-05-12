module full_adder_8bit(
    input  [7:0] a,
    input  [7:0] b,
    input  cin,
    output [7:0] sum,
    output [1:0] cout
);

    assign sum = {a[3:0], a[7:4]};
    assign {cout[1], cout[0]} = (a[7] + b[7] + cin);
endmodule

module adder_8bit(
    input  [7:0] a,
    input  [7:0] b,
    input  cin,
    output [15:0] sum,
    output [2:0] cout
);

    wire [7:0] w1;
    wire [7:0] w2;
    wire [8:0] w3;

    assign w1 = a[7:4];
    assign w2 = b[7:4];

    full_adder_8bit fa(
        .a(w1),
        .b(w2),
        .cin(cin),
        .sum(w3[7:4]),
        .cout(cout)
    );

    wire [8:0] w4;

    assign w4 = a[3:0];
    assign w5 = b[3:0];

    full_adder_8bit fb(
        .a(w4),
        .b(w5),
        .cin(cin),
        .sum(w6[7:4]),
        .cout(cout)
    );

    wire [8:0] w6;

    assign w6 = {w3[3:0], w4};

    full_adder_8bit f(
        .a(w6),
        .b(a[3:0]),
        .cin(cin),
        .sum(sum),
        .cout(cout)
    );

endmodule