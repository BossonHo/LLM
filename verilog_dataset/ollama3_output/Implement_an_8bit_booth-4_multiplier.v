module booth_4_multiplier (
    input [7:0] A,        // 8-bit multiplicand (signed)
    input [7:0] B,        // 8-bit multiplier (signed)
    output reg [15:0] P    // 16-bit product
);

reg [7:0] M;            // Register for A
reg [7:0] Q;            // Register for B
reg [7:0] Q_1;          // Q-1, previous least significant bit of Q
reg [15:0] A_neg;       // Negative A for subtraction
integer i;

always @* begin
    M = A;
    Q = B;
    Q_1 = 0;
    P[15:0] = 16'd0;      // Clear product register

    A_neg = {8'b0, ~M + 1}; // Two's complement for negative A

    for (i = 0; i < 8; i = i + 1) begin
        case ({Q[0], Q_1} & 9'b000000011)
            9'b00000001: P[15:0] = P[15:0] + {8'b0, M}; // Add M to product (extend M to 16 bits)
            9'b00000010: P[15:0] = P[15:0] - {8'b0, M}; // Subtract M from product (extend M to 16 bits)
            default:
                break;
        endcase

        Q_1 = Q & ({1'b1, ~Q}); // Arithmetic right shift
        Q = {Q[7], Q};
        P[15:0] = (P[15:0] << 1) | Q_1;
    end
end

endmodule