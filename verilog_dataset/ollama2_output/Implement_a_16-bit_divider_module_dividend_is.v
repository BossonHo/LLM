module divider_16by8 (
    input clk,
    input rst,
    input start,
    input [15:0] dividend,
    input [7:0] divisor,
    output reg [15:0] quotient,
    output reg [7:0] remainder,
    output reg done
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            quotient <= 16'd0;
            remainder <= 8'd0;
        end else begin
            if (start && !done) begin
                if (divisor != 0) begin
                    quotient <= dividend[15:0];
                    remainder <= dividend[7:0] - divisor[7:0];
                    done <= 0;
                end else begin
                    quotient <= 16'd0;
                    remainder <= 8'd0;
                    done <= 1;
                end
            end else if (done) begin
                // no op
            end else begin
                // assert fail
            end
        end
    end
endmodule