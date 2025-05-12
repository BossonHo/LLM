module alu_32bit_mips (
    input [31:0] A,       // Operand 1
    input [31:0] B,       // Operand 2
    input [4:0] shamt,    // Shift amount (used for shift ops)
    input [3:0] alu_ctrl, // ALU control signal
    output reg [31:0] result,
    output zero           // Zero flag
);

    assign zero = (result == 32'b0);

    always @(*) begin
        case (alu_ctrl)
            4'b0000: result = A & B;                      // AND
            4'b0001: result = A | B;                      // OR
            4'b0010: result = A + B;                      // ADD
            4'b0110: result = A - B;                      // SUB
            4'b0111: result = ($signed(A) < $signed(B)) ? 32'd1 : 32'd0; // SLT
            4'b1000: result = (A < B) ? 32'd1 : 32'd0;    // SLTU
            4'b1100: result = ~(A | B);                   // NOR
            4'b0011: result = A ^ B;                      // XOR
            4'b1001: result = B << shamt;                 // SLL
            4'b1010: result = B >> shamt;                 // SRL
            4'b1011: result = $signed(B) >>> shamt;       // SRA
            default: result = 32'd0;
        endcase
    end

endmodule