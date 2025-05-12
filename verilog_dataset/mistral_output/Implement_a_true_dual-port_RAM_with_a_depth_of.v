module true_dual_port_ram (
    input wire clk,
    input wire rst,
    input wire read_en,
    input wire [1:0] read_addr,
    output reg [3:0] read_data,
    input wire write_en,
    input wire [1:0] write_addr,
    input wire [3:0] write_data
);

reg [3:0] mem [7:0];

always @(posedge clk or posedge rst) begin
    if (rst) begin
        for (integer i = 0; i < 8; i = i + 1) begin
            mem[i] <= 4'b0000;
        end
    end else begin
        if (write_en) begin
            mem[write_addr] <= write_data;
        end
    end
end

always @(*) begin
    if (read_en) begin
        read_data <= mem[read_addr];
    end
end

endmodule