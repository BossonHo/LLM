module traffic_light_controller (
    input clk,
    input rst,
    input pedestrian_button,
    output reg red,
    output reg yellow,
    output reg green
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= GREEN;
        counter <= 0;
        shorten_green <= 0;
        green_time <= 60;
    end else begin
        state <= next_state;

        // Detect pedestrian button press during green
        if (state == GREEN && pedestrian_button && counter < 51) begin
            shorten_green <= 1;
            green_time <= 10;
        end else if (state == GREEN && !pedestrian_button) begin
            shorten_green <= 0;
            green_time <= 60;
        end

        // Counter logic
        if (state != next_state) begin
            counter <= 0; // Reset the counter on state change
        end else begin
            counter <= counter + 1;
        end
    end
end

always @(*) begin
    next_state = state;

    case (state)
        GREEN: begin
            if ((shorten_green && counter >= 10) || (!shorten_green && counter >= 60))
                next_state = YELLOW;
        end
        YELLOW: begin
            if (counter >= 5)
                next_state = RED;
        end
        RED: begin
            if (counter >= 10)
                next_state = GREEN;
        end
        default: next_state = INVALID; // Handle the invalid state
    endcase
end

always @(*) begin
    case (state)
        GREEN: begin
            green  = 1;
            yellow = 0;
            red    = 0;
        end
        YELLOW: begin
            green  = 0;
            yellow = 1;
            red    = 0;
        end
        RED: begin
            green  = 0;
            yellow = 0;
            red    = 1;
        end
        default: begin // Add default case for undefined state
            green  = 0;
            yellow = 0;
            red    = 0;
        end
    endcase
end

endmodule