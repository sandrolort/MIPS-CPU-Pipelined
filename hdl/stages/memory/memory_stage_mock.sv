module memory_stage_mock(
    input wire clk,
    input wire rst,
    output reg [31:0] out,
    output reg [31:0] out_delayed
);

reg [31:0] instruction_memory [0:9];
reg [3:0] pc;

initial begin
    instruction_memory[0] = 32'h24010000;
    instruction_memory[1] = 32'h24020000;
    instruction_memory[2] = 32'h24030000;
    instruction_memory[3] = 32'h24040000;
    instruction_memory[4] = 32'h24050000;
    instruction_memory[5] = 32'h24060000;
    instruction_memory[6] = 32'h24070000;
    instruction_memory[7] = 32'h24080000;
    instruction_memory[8] = 32'h24090000;
    instruction_memory[9] = 32'h240A0000;
    pc = 4'b0000;
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        pc <= 4'b0000;
        out <= 32'b0;
        out_delayed <= 32'b0;
    end else begin
        out <= instruction_memory[pc];
        out_delayed <= out;
        if (pc < 4'b1001) begin
            pc <= pc + 1;
        end
    end
end

endmodule