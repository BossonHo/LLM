module perpetual_calendar (
    input clk,          // Clock input (assumed 1 Hz for 1-second tick)
    input rst,          // Asynchronous reset
    output reg [5:0] Secs,  // 0 - 59
    output reg [5:0] Mins,  // 0 - 59
    output reg [4:0] Hours  // 0 - 23
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        Secs  <= 0;
        Mins  <= 0;
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
endmodule