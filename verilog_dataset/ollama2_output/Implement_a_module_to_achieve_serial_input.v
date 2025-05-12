module accumulator_4x8bit (
    input clk,
    input rst,

    // Input interface
    input [7:0] data_in,
    input       valid_in,
    output reg  ready_out,

    // Output interface
    output reg [9:0] data_out,  // Max sum = 4 x 255 = 1020
    output reg       valid_out,
    input            ready_in
);

    reg [9:0] sum;      // Accumulator (up to 1020)
    reg [1:0] count;    // Count of inputs received (0 to 3)

    always @(*) begin
        // Accept input when output is not blocking
        ready_out = (!valid_out) || (valid_out && ready_in);
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sum       <= 10'd0;
            count     <= 2'd0;
            data_out  <= 10'd0;
            valid_out <= 1'b0;
        end else begin
            // Clear valid_out when downstream has accepted output
            if (valid_out && ready_in) begin
                valid_out <= 1'b0;
            end

            // Accept new input
            if (valid_in && ready_out) begin
                sum <= sum + {2'b00, data_in};  // Zero-extend data_in to 10 bits
                count <= count + 1;

                if (count == 2'd3) begin
                    data_out <= sum + {2'b00, data_in};  // Final sum
                    valid_out <= 1'b1;
                    sum <= 10'd0;
                    count <= 2'd0;
                end
            end
        end
    end

endmodule