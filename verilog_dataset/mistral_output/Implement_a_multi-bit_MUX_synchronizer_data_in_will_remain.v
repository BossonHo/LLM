module mux_synchronizer #(
    parameter WIDTH = 8  // Set the width of the data bus (default 8 bits)
)(
    input wire clk,           // Clock signal
    input wire rst,           // Reset signal
    input wire [WIDTH-1:0] data_in,  // Data input to be synchronized
    input wire data_en,      // Enable signal for data synchronization
    output reg [WIDTH-1:0] data_out  // Synchronized data output
);

reg [WIDTH-1:0] sync_data;   // Data storage register
reg data_en_counter = 0;     // Counter to check if data_en is high for at least 3 cycles

always @(posedge clk or posedge rst) begin
    if (rst) begin
        sync_data <= 0;
        data_en_counter <= 0;
        data_out <= 0;
    end else begin
        if (data_en) begin
            data_en_counter <= data_en_counter + 1;
            if (data_en_counter >= 3) begin
                sync_data <= data_in;
                data_en_counter <= 0;
            end
        end else begin
            data_en_counter <= 0;
        end
        data_out <= sync_data;
    end
end