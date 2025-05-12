module full_adder (
    input [15:0] a,
    input [15:0] b,
    input cin,
    output [16:0] sum,
    output cout
);
    assign {cout, sum} = a + b + cin;
endmodule