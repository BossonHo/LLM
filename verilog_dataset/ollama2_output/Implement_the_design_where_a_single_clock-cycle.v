module pulse_synchronizer (
    input wire clk_a,            // Fast clock A
    input wire clk_b,            // Slow clock B
    input wire rst,              // Reset signal
    input wire data_in,          // Single clock-width pulse in the A domain
    output reg data_out          // Single clock-width pulse in the B domain
);

always @(posedge clk_a or posedge rst) begin
    if (rst) begin
        sync_1 <= 1'b0;
        sync_2 <= 1'b0;
    end else begin
        sync_1 <= data_in;  // First stage synchronizer
        sync_2 <= sync_1;    // Second stage synchronizer
    end
end

always @(posedge clk_b or posedge rst) begin
    if (rst) begin
        data_out <= 1'b0;
    end else begin
        // Detect rising edge in the B domain and generate a pulse
        if (sync_2 && !sync_1) begin
            data_out <= 1'b1;  // Generate pulse
        end else begin
            data_out <= 1'b0;  // Clear pulse after one clock cycle
        end
    end
end
endmodule