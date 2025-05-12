module cla_32bit_adder (
    input [31:0] a,
    input [31:0] b,
    input cin,
    output reg [31:0] sum,
    output reg [31:0] carry
);

  wire g0 = a[0] ^ b[0];
  wire g1 = (a[0] & b[0]) | (cin & (~a[0] & ~b[0]));
  assign carry[0] = g1;
  assign sum[0] = a[0] ^ b[0] ^ cin;

  wire [7:0] g2;
  assign g2 = {(a[1:0] & b[1:0]) | (cin & (~a[1:0] & ~b[1:0]))};
  wire g3 = a[2] ^ b[2] ^ cin & g1;
  assign carry[1:0] = g3;
  assign sum[1:0] = {sum[1:0], (a[1:0] + b[1:0]) ^ cin};

  wire [15:0] g4;
  assign g4 = {(a[3:2] & b[3:2]) | (cin & (~a[3:2] & ~b[3:2]))};
  wire g5 = a[4] ^ b[4] ^ cin & g3;
  wire g6 = (g2[0] ^ b[4]) & g5;
  assign carry[4:1] = {g5, g6};
  assign sum[4:1] = {sum[4:1], (a[3:2] + b[3:2]) ^ cin};

  wire [31:0] g7;
  assign g7 = {(a[15:8] & b[15:8]) | (cin & (~a[15:8] & ~b[15:8]))};
  wire g8 = a[16] ^ b[16] ^ cin & carry[3];
  wire g9 = (g4[0] ^ b[16]) & g8;
  assign carry[16:8] = {g8, g9};
  assign sum[16:8] = {sum[16:8], (a[15:8] + b[15:8]) ^ cin};

  wire g10 = a[32] ^ b[32] ^ cin & carry[17];
  assign carry[32] = g10;
  assign sum[32] = (a[32] + b[32]) ^ cin;
endmodule