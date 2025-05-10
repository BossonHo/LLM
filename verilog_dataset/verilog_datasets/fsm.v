module fsm_10011_detector (
    input  wire clk,     // Clock
    input  wire rst,     // Active-high synchronous reset
    input  wire IN,      // Serial input
    output reg  MATCH    // High for 1 clk when "10011" is detected
);

    // Define FSM states
    typedef enum logic [2:0] {
        S0,  // Initial state
        S1,  // Got '1'
        S2,  // Got '10'
        S3,  // Got '100'
        S4,  // Got '1001'
        S5   // Got '10011' (final)
    } state_t;

    state_t state, next_state;

    // State transition
    always @(posedge clk or posedge rst) begin
        if (rst)
            state <= S0;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            S0: next_state = IN ? S1 : S0;
            S1: next_state = IN ? S1 : S2;
            S2: next_state = IN ? S3 : S0;
            S3: next_state = IN ? S4 : S0;
            S4: next_state = IN ? S5 : S2;
            S5: next_state = IN ? S1 : S2;
            default: next_state = S0;
        endcase
    end

    // Output logic
    always @(posedge clk or posedge rst) begin
        if (rst)
            MATCH <= 0;
        else
            MATCH <= (state == S5);
    end

endmodule
