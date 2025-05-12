module pipeline_multiplier_4bit (
    input  wire [3:0] A,        // 4-bit input A
    input  wire [3:0] B,        // 4-bit input B
    input  wire clk,             // Clock signal
    input  wire rst,             // Reset signal
    output reg [7:0] P          // 8-bit output product
);

    reg [7:0] partial_0, partial_1, partial_2, partial_3, partial_4;
    reg [7:0] sum_0, sum_1, sum_2, sum_3, sum_4;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            partial_0 <= 0;
        end else begin
            partial_0 <= {4'b0, A} & {8{B[0]}};
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            partial_1 <= 0;
        end else begin
            partial_1 <= {3'b0, A, 1'b0} & {8{B[1]}};
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            partial_2 <= 0;
        end else begin
            partial_2 <= {2'b0, A, 2'b0} & {8{B[2]}};
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            partial_3 <= 0;
        end else begin
            partial_3 <= {1'b0, A, 3'b0} & {8{B[3]}};
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            partial_4 <= 0;
        end else begin
            partial_4 <= {1'b0, A} & {8{B[3]}};  // Add the same product of B[3] again for 4-bit multiplication
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sum_0 <= 0;
        end else begin
            sum_0 <= partial_0 + partial_1;
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sum_1 <= 0;
        end else begin
            sum_1 <= sum_0 + partial_2;
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sum_2 <= 0;
        end else begin
            sum_2 <= sum_1 + partial_3;
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sum_3 <= 0;
        end else begin
            sum_3 <= sum_2 + partial_4;
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            P <= 0;
        end else begin
            P <= sum_3;
        end
    end

endmodule