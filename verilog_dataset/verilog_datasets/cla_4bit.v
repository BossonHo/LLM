module cla_4bit (
    input  [3:0] a,      // 4-bit input a
    input  [3:0] b,      // 4-bit input b
    input        cin,     // Carry-in
    output [3:0] sum,    // 4-bit sum result
    output       cout,    // Carry-out
    output       G,       // Group generate
    output       P        // Group propagate
);

    wire [3:0] P_internal, G_internal; // Propagate and Generate signals
    wire [4:0] c;  // Carry signals, including c[0] (carry-in)
    
    // Intermediate signals to break combinational cycles
    reg [4:0] c_reg;

    // Propagate and Generate logic
    assign P_internal = a ^ b;  // Propagate: P = A XOR B
    assign G_internal = a & b;  // Generate: G = A AND B

    // Carry calculation using non-blocking assignments
    always @(*) begin
        c_reg[0] = cin;  // First carry is the carry-in
        c_reg[1] = G_internal[0] | (P_internal[0] & c_reg[0]);
        c_reg[2] = G_internal[1] | (P_internal[1] & c_reg[1]);
        c_reg[3] = G_internal[2] | (P_internal[2] & c_reg[2]);
        c_reg[4] = G_internal[3] | (P_internal[3] & c_reg[3]); // Final carry-out
    end

    // Assign carry signals from the register
    assign c = c_reg;

    // Assign the carry-out signal
    assign cout = c_reg[4];  // Final carry-out

    // Sum calculation
    assign sum = a ^ b ^ c_reg[3:0];  // Sum is the XOR of inputs and carry

    // Generate and propagate outputs
    assign G = &G_internal;  // Group generate: AND of all generates
    assign P = |P_internal;  // Group propagate: OR of all propagates

endmodule
