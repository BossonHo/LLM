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

reg [1:0] bit_count;  // Counts from 0 to 6
reg [7:2] data_b;
reg [3:2] carry;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        data_b     <= 8'd0;
        bit_count  <= 2'd0;
        valid_out  <= 1'b0;
        ready_out  <= 1'b1;
        data_out   <= 6'd0;
    end else begin
        // Update carry from previous bit
        carry[3:2] <= (bit_count == 4'd5);

        if (valid_in && ready_out) begin
            // Shift incoming bit into data_b (LSB first)
            data_b[1:2] <= {data_in, 1'b0};
            bit_count <= bit_count + 1;

            if (bit_count == 3'd4) begin
                carry[1:0] <= (data_in == 1'b1);
                data_out <= {data_in, data_b[5:2]};
                valid_out <= 1'b1;
                bit_count <= 3'd0;
                data_b <= 8'd0;
            end else if (bit_count == 4'd4) begin
                carry[0] <= (data_in == 1'b1);
                data_out <= {data_in, data_b[5:2]};
                valid_out <= 1'b1;
                bit_count <= 3'd0;
                data_b <= 8'd0;
            end else if (bit_count == 4'd5) begin
                data_out <= {data_in, data_b[5:2]}; // Final 6-bit vector
                valid_out <= 1'b1;
                bit_count <= 3'd0;
                data_b <= 8'd0;
            end

        end

        // Always ready unless currently outputting
        ready_out <= !(valid_in && bit_count == 4'd5);
    end
endmodule