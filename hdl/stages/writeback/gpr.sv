module gpr (
    input clk, rst, 
    input wire we,
    input wire [4:0] ra1, ra2, wa,
    output wire [31:0] rd1, rd2,
    input wire [31:0] wd,
    output wire [31:0] register_out
);

reg [31:0] registers [31:1] /* synthesis keep */;
integer i;

assign rd1 = (ra1 == 5'b0) ? 32'b0 : registers[ra1];
assign rd2 = (ra2 == 5'b0) ? 32'b0 : registers[ra2];
assign register_out = registers[5];

initial begin
    for (i = 1; i < 32; i = i + 1)
        registers[i] = 0;
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        for (i = 1; i < 32; i = i + 1) begin
            registers[i] <= 32'b0;
        end
    end else if (we && wa != 5'b0) begin
        registers[wa] <= wd;
    end
end

endmodule