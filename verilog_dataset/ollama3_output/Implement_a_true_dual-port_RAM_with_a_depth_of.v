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

    reg [7:0] mem[7:0];

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (int i = 0; i < 8; i++) begin
                mem[i] <= 4'b0000;
            end
        end else begin
            if (write_en) begin
                mem[write_addr] <= write_data;
            end
            if (read_en && read_addr != 3'd7) begin
                read_data <= mem[read_addr];
            end
        end
    end

endmodule