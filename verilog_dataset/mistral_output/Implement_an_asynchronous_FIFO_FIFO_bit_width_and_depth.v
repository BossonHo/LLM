module async_fifo #(
    parameter DEPTH = 16,
    parameter WIDTH = 8
)(
    input                   rst,

    // Write interface
    input                   clk_wr,
    input       [WIDTH-1:0] data_in,
    input                   wr_en,
    output                  full,

    // Read interface
    input                   clk_rd,
    output      [WIDTH-1:0] data_out,
    input                   rd_en,
    output                  empty
);

    localparam ADDR_WIDTH = $clog2(DEPTH);

    // FIFO memory
    reg [WIDTH-1:0] mem [0:DEPTH-1];

    // Write pointer (binary and gray)
    reg [ADDR_WIDTH:0] wr_ptr_bin = 0;
    reg [ADDR_WIDTH:0] wr_ptr_gray = 0;
    reg [ADDR_WIDTH:0] wr_ptr_gray_sync1 = 0;
    reg [ADDR_WIDTH:0] wr_ptr_gray_sync2 = 0;

    // Read pointer (binary and gray)
    reg [ADDR_WIDTH:0] rd_ptr_bin = 0;
    reg [ADDR_WIDTH:0] rd_ptr_gray = 0;
    reg [ADDR_WIDTH:0] rd_ptr_gray_sync1 = 0;
    reg [ADDR_WIDTH:0] rd_ptr_gray_sync2 = 0;

    wire [ADDR_WIDTH:0] wr_addr = wr_ptr_bin;
    wire [ADDR_WIDTH:0] rd_addr = rd_ptr_bin;

    // === WRITE DOMAIN ===
    always @(posedge clk_wr or posedge rst) begin
        if (rst) begin
            wr_ptr_bin  <= 0;
            wr_ptr_gray <= 0;
        end else if (wr_en && !full) begin
            mem[wr_ptr_bin[ADDR_WIDTH-1:0]] <= data_in;
            wr_ptr_bin  <= wr_ptr_bin + 1;
            wr_ptr_gray <= (wr_ptr_bin + 1) ^ ((wr_ptr_bin + 1) >> 1);  // Binary to Gray
        end
    end

    // Synchronize read pointer to write domain
    always @(posedge clk_wr or posedge rst) begin
        if (rst) begin
            rd_ptr_gray_sync1 <= 0;
            rd_ptr_gray_sync2 <= 0;
        end else begin
            rd_ptr_gray_sync1 <= rd_ptr_gray;
            rd_ptr_gray_sync2 <= rd_ptr_gray_sync1;
        end
    end

    // FULL condition
    assign full = (wr_ptr_gray == {~rd_ptr_gray_sync2[ADDR_WIDTH:ADDR_WIDTH-1], rd_ptr_gray_sync2[ADDR_WIDTH-2:0]});

    // === READ DOMAIN ===
    always @(posedge clk_rd or posedge rst) begin
        if (rst) begin
            rd_ptr_bin  <= 0;
            rd_ptr_gray <= 0;
        end else if (rd_en && !empty) begin
            rd_ptr_bin  <= rd_ptr_bin + 1;
            rd_ptr_gray <= (rd_ptr_bin + 1) ^ ((rd_ptr_bin + 1) >> 1);  // Binary to Gray
        end
    end

    assign data_out = mem[rd_ptr_bin[ADDR_WIDTH-1:0]];

    // Synchronize write pointer to read domain
    always @(posedge clk_rd or posedge rst) begin
        if (rst) begin
            wr_ptr_gray_sync1 <= 0;
            wr_ptr_gray_sync2 <= 0;
        end else begin
            wr_ptr_gray_sync1 <= wr_ptr_gray;
            wr_ptr_gray_sync2 <= wr_ptr_gray_sync1;
        end
    end

    // EMPTY condition
    assign empty = (rd_ptr_gray == wr_ptr_gray_sync2);

endmodule