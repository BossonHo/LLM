module MAC_PE (
    input               clk     ,  
    input               rst_n   ,  
    input       [31:0]  a       ,  
    input       [31:0]  b       ,  
    output  reg [63:0]  c        
);

reg [63:0] acc;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        acc <= 64'd0;
    end else begin
        acc <= acc + a * b;
    end
end

always @(*) begin
    c = acc;
end

endmodule