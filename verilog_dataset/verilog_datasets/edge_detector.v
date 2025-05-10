module edge_detector (
    input  wire clk,       // Clock input
    input  wire rst,       // Active-high reset
    input  wire a,         // 1-bit slowly changing input signal
    output reg  rise,      // High for 1 clk on rising edge of a
    output reg  down       // High for 1 clk on falling edge of a
);

    reg a_d; // delayed version of 'a'

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            a_d  <= 0;
            rise <= 0;
            down <= 0;
        end else begin
            // Edge detection
            rise <= (~a_d) & a;   // rising edge
            down <= a_d & (~a);  // falling edge

            a_d <= a;            // store previous value of a
        end
    end

endmodule
