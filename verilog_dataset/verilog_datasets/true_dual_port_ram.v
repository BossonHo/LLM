module true_dual_port_ram (
    input wire clk,             // Clock signal
    input wire rst,             // Reset signal
    input wire read_en,         // Read enable signal
    input wire [2:0] read_addr, // 3-bit address for reading (depth 8)
    output reg [3:0] read_data, // 4-bit data read from memory
    input wire write_en,        // Write enable signal
    input wire [2:0] write_addr,// 3-bit address for writing (depth 8)
    input wire [3:0] write_data // 4-bit data to be written to memory
);

    // 8x4-bit memory array initialized to zero (4-bit wide, 8-deep)
    reg [3:0] mem [7:0];

    // Synchronous reset to initialize memory to 0
    integer i;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Initialize all memory locations to 0000
            for (i = 0; i < 8; i = i + 1) begin
                mem[i] <= 4'b0000;
            end
        end else begin
            // Perform write operation when write_en is high
            if (write_en) begin
                mem[write_addr] <= write_data;
            end
        end
    end

    // Asynchronous read operation
    always @(*) begin
        if (read_en) begin
            read_data = mem[read_addr];  // Output the data at the specified read address
        end else begin
            read_data = 4'b0000;         // If read_en is not enabled, output 0000
        end
    end

endmodule
