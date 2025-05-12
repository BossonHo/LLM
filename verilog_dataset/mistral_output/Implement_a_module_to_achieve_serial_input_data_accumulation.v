module accumulator_4x8bit (
    input clk,
    input rst,

    // Input interface
    input [7:0] data_in,
    input       valid_in,
    output reg  ready_out,

    // Output interface
    output reg [15:0] data_out,  // Max sum = 4 x (2^8 - 1) + 4 = 61 * 4 + 4 = 248
    output reg       valid_out,
    input            ready_in
);

    reg [15:0] sum;      // Accumulator (up to 248)
    reg [3:0] count;    // Count of inputs received (0 to 4)

    // Input ready logic
    always @(*) begin
        // Accept input when output is not blocking
        ready_out = (!valid_out) || (valid_out && ready_in);
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sum       <= 16'h0;
            count     <= 4'b0;
            data_out  <= 16'h0;
            valid_out <= 1'b0;
        end else begin
            // Clear valid_out when downstream has accepted output
            if (valid_out && ready_in) begin
                valid_out <= 1'b0;
            end

            // Accept new input
            if (valid_in && ready_out) begin
                sum <= sum + {4'b0, data_in};  // Zero-extend data_in to 16 bits
                count <= count + 1;

                if (count == 5) begin
                    data_out <= sum + {4'b0, data_in};  // Final sum
                    valid_out <= 1'b1;
                    sum <= 16'h0;
                    count <= 4'b0;
                end
            end
        end
    end

endmodule