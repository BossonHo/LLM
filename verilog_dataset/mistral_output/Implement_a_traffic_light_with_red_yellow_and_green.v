module traffic_light (
    input clk,
    input rst,
    input pedestrian_button,
    output reg red,
    output reg yellow,
    output reg green
);

localparam GREEN = 3'b000;
localparam YELLOW = 3'b001;
localparam RED = 3'b010;
localparam STOP = 3'b111; // Invalid state for safety

reg state, next_state;
reg count_down;
reg [2:0] green_time;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= GREEN;
        count_down <= 60;
        green_time <= 3'b000;
    end else begin
        case (state)
            GREEN: begin
                if (pedestrian_button && count_down > 10) begin
                    count_down <= 10;
                end
                if (count_down == 60 || pedestrian_button) begin
                    state <= YELLOW;
                end
            end
            YELLOW: begin
                if (count_down == 5) begin
                    state <= RED;
                end
            end
            RED: begin
                if (count_down == 10) begin
                    state <= GREEN;
                end
            end
            default: state <= STOP; // Handle invalid states
        endcase
        count_down <= count_down - 1;
        green_time <= green_time + 1;
    end
end

always @(*) begin
    next_state = state;
    case (state)
        GREEN: begin
            if ((green_time == 60 || pedestrian_button) && count_down < 51) begin
                next_state <= YELLOW;
            end
        end
        YELLOW: begin
            if (count_down >= 5) begin
                next_state <= RED;
            end
        end
        RED: begin
            if (count_down >= 10) begin
                next_state <= GREEN;
            end
        end
        default: next_state <= STOP; // Handle invalid states
    endcase
end

assign {red, yellow, green} = state;

endmodule