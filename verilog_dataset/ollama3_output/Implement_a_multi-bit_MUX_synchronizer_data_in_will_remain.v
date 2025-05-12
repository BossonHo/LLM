module mux_synchronizer #(
    parameter WIDTH = 8, // Set the width of the data bus (default 8 bits)
    parameter SYNC_WIDTH = 2, // Synchronize data_en signal
    parameter SYNC_CYCLES = 3 // Minimum synchronization cycle
)(
    input wire clk,           // Clock signal
    input wire rst,           // Reset signal
    input wire [WIDTH-1:0] data_in,  // Data input to be synchronized
    input wire [SYNC_WIDTH-1:0] data_en,      // Enable signal for data synchronization
    output reg [WIDTH-1:0] data_out  // Synchronized data output
);

reg [WIDTH-1:0] sync_data_1;  // First stage of synchronization
reg [WIDTH-1:0] sync_data_2;  // Second stage of synchronization
reg [SYNC_WIDTH-1:0] data_en_sync;       // Synchronize data_en signal

always @(posedge clk or posedge rst) begin
    if (rst) begin
        sync_data_1 <= 0;
        sync_data_2 <= 0;
        data_en_sync <= 0;
        data_out <= 0;
    end else begin
        // Synchronizing the enable signal (data_en) across clock cycles
        data_en_sync <= {data_en_sync[SYNC_WIDTH-1:0], data_en[SYNC_WIDTH-1:SYNC_WIDTH+1]};

        // If data_en is stable high (at least SYNC_CYCLES cycles), sync data_in
        if (data_en_sync == 2'b11) begin
            sync_data_1 <= data_in;  // Store data_in in first stage
            sync_data_2 <= sync_data_1;  // Transfer to second stage
        end

        // Output the synchronized data from the second stage
        data_out <= sync_data_2;
    end
endmodule