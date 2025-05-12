module accumulator_4x8bit (
    input clk,
    input rst,

    // Input interface
    input [7:0] data_in[3],
    input       valid_in[3],
    output reg  ready_out[3],
    output reg [9:0] data_out,  // Max sum = 4 x 255 = 1020
    output reg       valid_out,
    input            ready_in
);

reg [9:0] sum;      // Accumulator (up to 1020)
reg [1:0] count;    // Count of inputs received (0 to 3)

always @(*) begin
    ready_out[0] = (!valid_in[0]) || (valid_in[0] && ready_in);
    ready_out[1] = (!valid_in[1]) || (valid_in[1] && ready_out[0]);
    ready_out[2] = (!valid_in[2]) || (valid_in[2] && ready_out[1]);
    ready_out[3] = (!valid_in[3]) || (valid_in[3] && ready_out[2]);
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        sum       <= 10'd0;
        count     <= 2'd0;
        data_out  <= 10'd0;
        valid_out <= 1'b0;
    end else begin
        // Clear valid_out when downstream has accepted output
        if (valid_out && ready_in[3]) begin
            valid_out <= 1'b0;
        end

        // Accept new input
        for (int i = 3; i >= 0; i--) begin
            if (valid_in[i] && ready_out[i]) begin
                sum <= sum + {2'b00, data_in[i]};  // Zero-extend data_in to 10 bits
                count <= count + 1;

                if (count == 3) begin
                    data_out <= sum + {2'b00, data_in[0]} + {2'b00, data_in[1]} + {2'b00, data_in[2]};
                    valid_out <= 1'b1;
                    sum <= 10'd0;
                    count <= 2'd0;
                end
            end
        end
    end
end

endmodule