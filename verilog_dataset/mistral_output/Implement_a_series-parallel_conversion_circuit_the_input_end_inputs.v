module serial_to_parallel_12bit (
    input clk,
    input rst,

    // Input side (valid-ready handshake)
    input        data_in,
    input        valid_in,
    output reg   ready_out,

    // Output side (valid-only handshake)
    output reg [11:0] data_out,
    output reg       valid_out
);

    reg [11:0] data_b;
    reg [3:0] bit_count;  // Counts from 0 to 12

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            data_b     <= 12'd0;
            bit_count  <= 4'd0;
            valid_out  <= 1'b0;
            ready_out  <= 1'b1;
            data_out   <= 12'd0;
        end else begin
            valid_out <= 1'b0;  // Default: no valid output

            if (valid_in && ready_out) begin
                // Shift incoming bit into data_b (LSB first)
                data_b <= {data_in, data_b[11:1]};
                bit_count <= bit_count + 1;

                if (bit_count == 4'd12) begin
                    data_out <= {data_in, data_b[11:1]}; // Final 12-bit vector
                    valid_out <= 1'b1;
                    bit_count <= 4'd0;
                    data_b <= 12'd0;
                end
            end

            // Always ready unless currently outputting
            ready_out <= !(valid_in && bit_count == 4'd12);
        end
    end

endmodule