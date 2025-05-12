module full_adder_16bit (
    input  [15:0] a,
    input  [15:0] b,
    input  cin,
    output [15:0] sum,
    output cout
);
    assign {cout, sum[15], sum[14:2], sum[1]} = {{a[15], b[15]}, {a[14]+b[14], a[13]+b[13]+cin[13]},
                                              {a[12]+b[12], a[11]+b[11]+cin[11]}, 
                                              {a[10]+b[10], a[9]+b[9]+cin[9]}};
endmodule