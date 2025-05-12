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

    reg [4:0] count;
    reg [15:0] dividend_reg;
    reg [7:0] divisor_reg;
    reg [7:0] rem;
    reg [15:0] quot;
    reg busy;

    reg [7:0] next_rem;
    reg [15:0] next_quot;
    reg [15:0] next_dividend;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            quotient <= 16'd0;
            remainder <= 8'd0;
            dividend_reg <= 16'd0;
            divisor_reg <= 8'd0;
            rem <= 8'd0;
            quot <= 16'd0;
            count <= 5'd0;
            busy <= 0;
            done <= 0;
        end else begin
            if (start && !busy) begin
                if (divisor != 0) begin
                    dividend_reg <= dividend[15:8];
                    divisor_reg <= divisor;
                    rem <= 8'd0;
                    quot <= 16'd0;
                    count <= 5'd16;
                    busy <= 1;
                    done <= 0;
                end else begin
                    quotient <= 16'd0;
                    remainder <= dividend[7:0];
                    done <= 1;
                end
            end else if (busy) begin
                next_rem = {rem[6:0], dividend_reg[15]};
                next_dividend = {dividend_reg[14:0], 1'b0};

                if (next_rem >= divisor_reg) begin
                    next_rem = next_rem - divisor_reg;
                    next_quot = {quot[14:0], 1'b1};
                end else begin
                    next_quot = {quot[14:0], 1'b0};
                end

                rem <= next_rem;
                quot <= next_quot;
                dividend_reg <= next_dividend;
                count <= count - 1;

                if (count == 5'd1) begin
                    quotient <= next_quot;
                    remainder <= next_rem;
                    busy <= 0;
                    done <= 1;
                end
            end else begin
                done <= 0;
            end
        end
    end
endmodule