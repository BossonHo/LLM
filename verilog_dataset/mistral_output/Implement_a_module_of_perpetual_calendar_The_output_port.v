module perpetual_calendar (
    input clk,
    input rst,
    output reg [5:0] Secs,
    output reg [5:0] Mins,
    output reg [4:0] Hours
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        Secs <= 0;
        Mins <= 0;
        Hours <= 0;
    end else begin
        if (Secs == 59) begin
            Secs <= 0;
            if (Mins == 59) begin
                Mins <= 0;
                if (Hours == 23)
                    Hours <= 0;
                else
                    Hours <= Hours + 1;
            end else begin
                Mins <= Mins + 1;
            end
        end else begin
            Secs <= Secs + 1;
        end
    end
end