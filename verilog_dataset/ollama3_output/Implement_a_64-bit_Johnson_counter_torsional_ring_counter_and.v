module johnson_counter_64 (
    input  wire        clk,    // Clock
    input  wire        rst,    // Active-high synchronous reset
    output reg [63:0]  q       // 64-bit Johnson counter output
);

    reg [7:0]    state; // 4-bit state
    reg [47:40]  count; // 8-bit counter

    always @(posedge clk or posedge rst) begin
        if (rst)
            state <= 8'b0000;
        else
            state <= {state[6:], state[5:0]};
        
        if (count == 8'hfff) 
            count <= 8'b0000;
        else 
            count <= {count[7:], count[0:1]};
            
        q <= {state, count};
    end

endmodule