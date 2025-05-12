module signal_generator (
    input clk,
    input rst,
    input [1:0] wave_choice,        // 0: Square, 1: Sawtooth, 2: Triangle
    output reg [7:0] signal_out
);

reg [7:0] counter;
reg direction;  // Used for triangle wave: 0 = up, 1 = down

always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 8'd0;
        signal_out <= 8'd0;
        direction <= 1'b0;
    end else begin
        case (wave_choice)
            2'b00: begin
                // Square wave: toggle every 128 steps
                counter <= counter + 1;
                signal_out <= (counter < 128) ? 8'd255 : 8'd0;
            end

            2'b01: begin
                // Sawtooth wave: ramp up continuously
                counter <= counter + 1;
                signal_out <= counter;
            end

            2'b10: begin
                // Triangle wave: ramp up and down
                if (!direction) begin
                    counter <= counter + 1;
                    if (counter == 8'd255) direction <= 1;
                end else begin
                    counter <= counter - 1;
                    if (counter == 8'd0) direction <= 0;
                end
                signal_out <= counter;
            end

            default: signal_out <= 8'd0;
        endcase
    end
endmodule