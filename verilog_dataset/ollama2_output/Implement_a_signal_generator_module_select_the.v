module signal_generator (
    input clk,
    input rst,
    input [1:0] wave_choice,        // 0: Square, 1: Sawtooth, 2: Triangle
    output reg [7:0] signal_out
);

  always @(posedge clk or posedge rst) begin
    case (wave_choice)
        2'b00: square_wave(signal_out, wave_choice); // Square wave
        2'b01: sawtooth_wave(signal_out, wave_choice); // Sawtooth wave
        2'b10: triangle_wave(signal_out, wave_choice); // Triangular wave
        default: signal_out <= 8'd0;
    endcase
  end

endmodule

always @* begin
  case (wave_choice)
    2'b00: square_wave = (counter < 128) ? 8'd255 : 8'd0; // Square wave
    2'b01: sawtooth_wave = counter; // Sawtooth wave
    2'b10: triangle_wave = counter; // Triangular wave
    default: signal_out <= 8'd0;
  endcase
end