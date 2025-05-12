module parallel_to_serial (
    input wire clk,
    input wire rst,
    input wire [3:0] data_in,
    input wire valid_in,
    output reg serial_out,
    output reg valid_out
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        data_buffer <= 4'b0;
        count <= 3'b0;
        serial_out <= 1'b0;
        valid_out <= 1'b0;
    end else if (valid_in) begin
        if (count == 3'b0) begin
            // Load the input data into the buffer
            data_buffer <= data_in;
            valid_out <= 1'b1;
        end else begin
            // Shift the data out serially
            serial_out <= data_buffer[3];  // Take the MSB for output
            data_buffer <= {data_buffer[2:0], 1'b0}; // Shift the data left
        end

        // Increment counter to keep track of the shifts
        count <= count + 1;

        // When all 4 bits have been sent, reset counter and valid_out
        if (count == 3'b011) begin
            count <= 3'b0;
            valid_out <= 1'b0;
        end
    end else begin
        // If valid_in is low, do not output valid data
        valid_out <= 1'b0;
    end
endmodule