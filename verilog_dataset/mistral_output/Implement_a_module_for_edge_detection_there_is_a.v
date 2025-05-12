module edge_detector (
    input  wire clk,
    input  wire rst,
    input  wire a,
    output reg  rise,
    output reg  down
    );

    reg a_d;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            a_d <= 0;
            rise <= 0;
            down <= 0;
        end else begin
            rise <= (~a_d) & a;
            down <= a_d & (~a);
            a_d <= a;
        end
    end
endmodule