module signal_generator (
    input clk,
    input rst,
    input [1:0] wave_choice,
    output reg [7:0] signal_out
);

reg [7:0] counter;
reg direction;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 8'd0;
        signal_out <= 8'd0;
        direction <= 1'b0;
    end else begin
        case (wave_choice)
            2'b0: begin
                counter <= counter + 1;
                signal_out <= (counter < 128) ? 8'd255 : 8'd0;
            end
            2'b1: begin
                counter <= counter + 1;
                signal_out <= counter;
            end
            2'b10: begin
                if (!direction) begin
                    counter <= counter + 1;
                    if (counter == 8'd255) direction <= 1;
                end else begin
                    counter <= counter - 1;
                    if (counter == 8'd0) direction <= 0;
                end
                signal_out <= counter;
            end
        endcase
    end
end

endmodule