module booth_4_multiplier (
    input [7:0] A,        // 8-bit multiplicand (signed)
    input [7:0] B,        // 8-bit multiplier (signed)
    output reg [15:0] P    // 16-bit product
);

    reg [7:0] M;        // Register for A
    reg [7:0] Q;        // Register for B
    reg [7:0] Q_1;      // Q-1, previous least significant bit of Q
    reg [15:0] A_neg;   // Negative A for subtraction
    integer i;

    always @* begin
        // Initialize values
        M = A;
        Q = B;
        Q_1 = 0;
        P = 0;  // Clear product register

        // Calculate negative of M (Two's complement)
        A_neg = {8'b0, M} + 1;  // Extend M to 16 bits before negating

        // Booth-4 algorithm loop (8 cycles for 8 bits)
        for (i = 0; i < 8; i = i + 1) begin
            case ({Q[0], Q_1} & 9'b000000011)  // Mask to ensure the proper bit-width
                9'b00000001: P = P + {8'b0, M};    // Add M to product (extend M to 16 bits)
                9'b00000010: P = P - {8'b0, M};    // Subtract M from product (extend M to 16 bits)
                default: ;           // Do nothing for 00 or 11
            endcase

            // Perform the arithmetic shift right (ASR) operation
            {Q_1, Q} = {P[0], Q[7:1], 1'b0, 7'b0};  // Move Q bits to the right and ensure 16-bit width
            P = {P[15], P[15:1]};       // Extend the sign bit of P to the left
        end
    end

endmodule
