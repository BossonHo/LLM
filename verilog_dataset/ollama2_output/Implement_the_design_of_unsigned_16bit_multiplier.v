module multiplier_16bit (
    input clk,
    input rst,
    input start,
    input [15:0] A,
    input [15:0] B,
    output reg [31:0] P,
    output reg done
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            P <= 32'd0;
            done <= 1'b0;
        end else begin
            if (start && !done) begin
                // Initialization on start
                P <= A * B;
                done <= 1'b1;
            end else if (!done) begin
                P <= P + A * B;
                done <= 1'b0;
            end
        end
    end
endmodule