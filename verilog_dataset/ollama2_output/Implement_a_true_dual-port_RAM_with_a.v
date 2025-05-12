module true_dual_port_ram (
    input wire clk,
    input wire rst,
    input wire read_en,
    input wire [2:0] read_addr,
    output reg [3:0] read_data,
    input wire write_en,
    input wire [2:0] write_addr,
    input wire [3:0] write_data
);

    // 8x4-bit memory array initialized to zero (4-bit wide, 8-deep)
    reg [3:0] mem [7:0];

    // Synchronous reset to initialize memory to 0
    always @(posedge clk or posedge rst) begin
        if (rst) begin
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
            read_data <= 4'b0000;         // If read_en is not enabled, output 0000
        end
    end

endmodule