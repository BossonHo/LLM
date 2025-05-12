module parallel_to_serial (
    input wire clk,              // Clock signal
    input wire rst,              // Reset signal
    input wire [3:0] data_in,   // 4-bit parallel input data
    input wire valid_in,        // Valid signal for input data
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
        end else if (valid_in) begin
            if (count == 3'b0) begin
                // On the first cycle, load the input data into the buffer
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
    end

endmodule
