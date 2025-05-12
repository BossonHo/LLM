module parallel_to_serial (
    input wire clk,              // Clock signal
    input wire rst,              // Reset signal
    input wire [3:0] data_in,   // 4-bit parallel input data
    output reg serial_out,      // Serial output bit
    output reg valid_out        // Valid signal for output data
);

reg [3:0] data_buffer;      // To hold the input data
reg [2:0] count;            // 3-bit counter for shifting out the bits

always @(posedge clk or posedge rst) begin
    if (rst) begin
        data_buffer <= 4'b0;
        count <= 3'b0;
        serial_out <= 1'b0;
        valid_out <= 1'b0;
    end else if (data_in) begin
        if (count == 3'b0) begin
            data_buffer <= data_in;
            valid_out <= 1'b1;
        end else if (count < 2'b11) begin
            data_buffer[2:0] <= data_buffer[2:0];
            data_buffer[3] <= data_in[3];
            serial_out <= data_buffer[3];
            count <= count + 1;

            if (count == 2'b10) begin
                valid_out <= 1'b0;
            end
        end else begin
            valid_out <= 1'b0;
        end
    end else begin
        valid_out <= 1'b0;
    end
endmodule