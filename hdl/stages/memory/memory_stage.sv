module memory_stage(
    input wire select, //1 - d_pc, 0 - addr_in
    input wire [29:0] d_pc,
    input wire [29:0] addr_in,
    input wire [31:0] data_in,
    input wire mem_wren,
    output wire [31:0] out,
    output wire [31:0] out_delayed
);

wire [11:0] sram_address;
wire sram_wren;

assign sram_address = addr_in[11:0];

sram memory_sram (
    .address(sram_address),
    .inclock(master.mem_clk),
    .data(data_in),
    .wren(mem_wren),
    .q(out)
);

delay mem_out_del (master.clk, master.rst, out, out_delayed);

endmodule