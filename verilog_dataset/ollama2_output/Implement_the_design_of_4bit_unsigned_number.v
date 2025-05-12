module pipeline_multiplier_4bit (
    input  wire [3:0] A,        // 4-bit input A
    input  wire [3:0] B,        // 4-bit input B
    input  wire clk,             // Clock signal
    input  wire rst,             // Reset signal
    output reg [7:0] P          // 8-bit output product
);

    // Intermediate signals for pipelining
    reg [7:0] partial_0, partial_1, partial_2, partial_3;
    reg [7:0] sum_0, sum_1, sum_2;

    // Stage 1: Generate partial products for each bit of B and A
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            partial_0 <= 0;
        end else begin
            partial_0 <= {4'b0, A} & {8{B[0]}};  // Partial product for bit 0 of B
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            partial_1 <= 0;
        end else begin
            partial_1 <= {3'b0, A, 1'b0} & {8{B[1]}};  // Partial product for bit 1 of B (shifted by 1)
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            partial_2 <= 0;
        end else begin
            partial_2 <= {2'b0, A, 2'b0} & {8{B[2]}};  // Partial product for bit 2 of B (shifted by 2)
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            partial_3 <= 0;
        end else begin
            partial_3 <= {1'b0, A, 3'b0} & {8{B[3]}};  // Partial product for bit 3 of B (shifted by 3)
        end
    end

    // Stage 2: Add partial products to get sum_0
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sum_0 <= 0;
        end else begin
            sum_0 <= partial_0 + partial_1;  // Add first two partial products
        end
    end

    // Stage 3: Add the next partial product to sum_0 to get sum_1
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sum_1 <= 0;
        end else begin
            sum_1 <= sum_0 + partial_2;  // Add partial product 2
        end
    end

    // Stage 4: Add the final partial product to sum_1 to get sum_2
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sum_2 <= 0;
        end else begin
            sum_2 <= sum_1 + partial_3;  // Add partial product 3
        end
    end

    // Output product: Assign the final sum to the output product P
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            P <= 0;
        end else begin
            P <= sum_2;  // Assign final sum as output product
        end
    end

endmodule