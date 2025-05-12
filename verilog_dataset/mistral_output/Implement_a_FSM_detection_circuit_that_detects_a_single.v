module fsm_10011_detector (
    input  wire clk,     // Clock
    input  wire rst,     // Active-high synchronous reset
    input  wire IN,      // Serial input
    output reg  MATCH    // High for 1 clk when "10011" is detected
);

    typedef enum logic [2:0] {S0, S1, S2, S3, S4, S5} state_t;
    state_t state, next_state;

    always @(posedge clk or posedge rst) begin
        if (rst)
            state <= S0;
        else
            state <= next_state;
    end

    always @(*) begin
        case (state)
            S0: next_state = IN ? S1 : S0;
            S1: next_state = IN ? S2 : S0;
            S2: next_state = IN ? S3 : S0;
            S3: next_state = IN ? S4 : S0;
            S4: next_state = IN ? S5 : S2;
            S5: next_state = IN ? S1 : S2;
            default: next_state = S0;
        endcase
    end

    always @(posedge clk or posedge rst) begin
        if (rst)
            MATCH <= 0;
        else
            MATCH <= (state == S5);
    end

endmodule