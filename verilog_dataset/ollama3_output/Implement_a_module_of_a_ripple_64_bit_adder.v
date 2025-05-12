module ripple_adder(
    input  [31:0] a,
    input  [31:0] b,
    output [31:0] sum
);

wire [1:0] full_adder_3bit[0:3];
assign {full_adder_3bit[2], full_adder_3bit[1]} = {a[29:27], a[26:24]};
assign {full_adder_3bit[1], full_adder_3bit[0]} = {b[29:27], b[26:24]};

assign {sum[31:29], sum[28:26]} = 4'reg {{sum[31:30]}, (a[27] ^ b[27]) | ((a[27] & b[27]) << 1)};
assign full_adder_3bit[2].cout = 0;
assign {full_adder_3bit[3], sum[25:23]} = full_adder(full_adder_3bit[2].cin, full_adder_3bit[3].cin);
assign sum[24] = sum[24];

assign {sum[31:30], sum[28:26]} = 4'reg {{sum[31:30]}, (a[27] ^ b[27]) | ((a[27] & b[27]) << 1)};
assign full_adder_3bit[2].cout = 0;
assign {full_adder_3bit[3], sum[25:23]} = full_adder(full_adder_3bit[2].cin, full_adder_3bit[3].cin);
assign sum[24] = sum[24];

assign full_adder_3bit[1].cout = 0;
assign {full_adder_3bit[2], full_adder_3bit[0]} = full_adder(full_adder_3bit[1].cin, full_adder_3bit[0].cin);
assign sum[23] = sum[23];

assign full_adder_3bit[0].cout = 0;
assign {full_adder_3bit[1], full_adder_3bit[0]} = full_adder(full_adder_3bit[0].cin, full_adder_3bit[0].cin);
assign sum[22] = sum[22];

endmodule

module full_adder (
    input  cin,
    output cout,
    output [1:0] sum
);

wire [1:0] carry_out;
assign {carry_out[2], carry_out[1]} = {a[29:28], b[29:28]};
assign sum[0] = carry_out[1];
assign sum[1] = carry_out[2];

assign cout = a[30] ^ b[30] | (cin & (~a[30] & ~b[30]));

endmodule