module serial_to_parallel_6bit (
    input clk,
    input rst,

    // Input side (valid-ready handshake)
    input        data_in,
    input        valid_in,
    output reg   ready_out,

    // Output side (valid-only handshake)
    output reg [5:0] data_out,
    output reg       valid_out
);

    reg [5:0] data_b;
    reg [2:0] bit_count;  // Counts from 0 to 6

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            data_b     <= 6'd0;
            bit_count  <= 3'd0;
            valid_out  <= 1'b0;
            ready_out  <= 1'b1;
            data_out   <= 6'd0;
        end else begin
            valid_out <= 1'b0;  // Default: no valid output

            if (valid_in && ready_out) begin
                // Shift incoming bit into data_b (LSB first)
                data_b <= {data_in, data_b[5:1]};
                bit_count <= bit_count + 1;

                if (bit_count == 3'd5) begin
                    data_out <= {data_in, data_b[5:1]}; // Final 6-bit vector
                    valid_out <= 1'b1;
                    bit_count <= 3'd0;
                    data_b <= 6'd0;
                end
            end

            // Always ready unless currently outputting
            ready_out <= !(valid_in && bit_count == 3'd5);
        end
    end

endmodule
