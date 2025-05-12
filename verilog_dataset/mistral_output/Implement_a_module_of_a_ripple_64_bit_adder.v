module ripple_64bit_adder (
    input [31:0] a,
    input [31:0] b,
    input wire cin,
    output reg [31:0] sum,
    output reg cout
);

// 4-stage pipeline structure
always @(posedge clock) begin
    if (pipeline_stage == 0) begin // Stage 1
        carry_in[0] <= cin;
        for (int i = 31; i >= 0; i--) begin
            full_adder fa(.a(a[i]), .b(b[i]), .cin(carry_in[i + 1]), .sum(s[i]), .cout(carry_in[i]));
        end
    end
    else if (pipeline_stage == 1) begin // Stage 2
        for (int i = 31; i >= 0; i--) begin
            full_adder fa(.a(s[i]), .b(carry_in[i]), .cin(0), .sum(temp_sum[i]), .cout(temporary_carry[i]));
        end
        carry_in[0] <= temporary_carry[32];
    end
    else if (pipeline_stage == 2) begin // Stage 3
        for (int i = 31; i >= 0; i--) begin
            full_adder fa(.a(temp_sum[i]), .b(carry_in[i]), .cin(0), .sum(sum[i]), .cout(temporary_carry[i]));
        end
    end
    else if (pipeline_stage == 3) begin // Stage 4
        for (int i = 31; i >= 0; i--) begin
            full_adder fa(.a(sum[i]), .b(temporary_carry[i]), .cin(0), .sum(temp_sum[i]), .cout(carry_out));
        end
        cout <= carry_out;
    end
end

// clock and reset controls pipeline stage
reg clock_enable, reset;
reg pipeline_stage = 4'b0001; // initially at Stage 1 (0)
assign clock = clock_enable & ~reset;
assign pipeline_clk = !reset | (pipeline_stage == 0) | (clock_enable & (pipeline_stage != 0));
assign pipeline_enable = (!reset) | (pipeline_stage != 3);

// instantiation of full adder module
wire [1:0] carry_in;
reg [31:0] s, temp_sum, temporary_carry;

// Define the full adder module
module full_adder (
    input  a,
    input  b,
    input  cin,
    output reg sum,
    output reg cout
);
    assign {cout, sum} = a + b + cin;
endmodule