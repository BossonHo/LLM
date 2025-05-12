module width_converter_8to16 (
    input clk,
    input rst,
    input [7:0] data_in,
    input valid_in,
    output reg [15:0] data_out,
    output reg valid_out
);

    reg temp;
    reg first_byte;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            temp <= 8'd0;
            data_out <= 16'd0;
            first_byte <= 1'b0;
            valid_out <= 1'b0;
        end else begin
            valid_out <= 1'b0;

            if (valid_in) begin
                if (!first_byte) begin
                    // Store the first byte
                    temp <= data_in;
                    first_byte <= 1'b1;
                end else begin
                    // Combine and output 16-bit data
                    data_out <= {temp, data_in};
                    valid_out <= 1'b1;
                    first_byte <= 1'b0;
                end
            end
        end
    end
endmodule