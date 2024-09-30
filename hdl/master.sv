// Page 166, "A Pipelined Multi-core MIPS Machine Hardware Implementation and Correctness Proof"
// All registers that come out of cir-s themselves are delayed in-module
// All other registers, such as con.2/3/4, C.4, ea.4 - are delayed in master module.
// All wires, with their own successors, are declared together. That's why there's i_decoder in the 
// fetch region of the master module.

module master (
    input external_clk,
    input rst,
    output [31:0] debug_hex_display
);

// Clock definitions
wire clk, mem_clk;
assign mem_clk = external_clk;
clock_div divider(mem_clk, clk);

// Fetch
wire [31:0] i_fetch, i_decoder, i_ex, i_mem;

fetch_stage fetch(
    .i_mem(i_mem),
    .i_fetch(i_fetch)
);

// Decode
wire [31:0] pc, d_pc;

wire [4:0] ra1_decoder, ra2_decoder;
wire [31:0] a_decoder, a_gpr;
wire [31:0] b_decoder, b_gpr;
wire [31:0] link_addr_decoder, link_addr_execute, link_addr_memory;
wire [38:0] decoder_packed_decoder, decoder_packed_execute, decoder_packed_memory;

decode_stage decode(
    .a_gpr(a_gpr),
    .b_gpr(b_gpr),
    .i_fetch(i_fetch),
    .pc(pc),
    .d_pc(d_pc),
    .rs(ra1_decoder),
    .rt(ra2_decoder),
    .i_decoder(i_decoder),
    .a_decoder(a_decoder), 
    .b_decoder(b_decoder),
    .link_addr_del(link_addr_decoder),
    .decoder_packed_del(decoder_packed_decoder)
);

// Execute
wire [31:0] alu_res_execute, alu_res_memory;
wire [31:0] shift_res_execute, shift_res_memory;
wire [31:0] dm_in;
wire [31:0] ea_execute, ea_memory;
wire ovfalu;

delay #(38) con3(clk, rst, decoder_packed_decoder, decoder_packed_execute);
delay c3lnk (clk, rst, link_addr_decoder, link_addr_execute);

execute_stage execute(
    .decoder_packed_decoder(decoder_packed_decoder),
    .a_decoder(a_decoder),
    .b_decoder(b_decoder),
    .i_decoder(i_decoder),
    .pc(pc),
    .alu_res(alu_res_execute),
    .shift_res(shift_res_execute),
    .dm_in(dm_in),
    .ea(ea_execute),
    .ovfalu(ovfalu)
);

// Memory
delay #(38) con4(clk, rst, decoder_packed_execute, decoder_packed_memory);
delay ea4 (clk, rst, ea_execute, ea_memory);
delay c4lnk (clk, rst, link_addr_execute, link_addr_memory);
delay c4alures (clk, rst, alu_res_execute, alu_res_memory);
delay c4shfres (clk, rst, shift_res_execute, shift_res_memory);

wire [31:0] mem_out_live, mem_out_memory;
wire mem_wren;
decoder_deconcat exec_dec(.packed_in(decoder_packed_execute), .mem_wren(mem_wren));

`ifndef SIMULATION
memory_stage memory(
    .select(1), //todo add stall engine and fix this.
    .d_pc(d_pc),
    .addr_in(ea_execute),
    .data_in(dm_in),
    .mem_wren(mem_wren),
    .out(mem_out_live),
    .out_delayed(mem_out_memory)
);
`else
memory_stage_mock memory(
    .clk(clk),
    .rst(rst),
    .out(mem_out_live),
    .out_delayed(mem_out_memory)
);
`endif

assign i_mem = mem_out_live; //todo

// Writeback
wire [4:0] cad_writeback;
wire gp_we_writeback;
wire [1:0] gpr_mux_sel;
wire [31:0] gpr_data_in;
decoder_deconcat mem_dec(
    .packed_in(decoder_packed_memory), 
    .gp_mux_sel(gpr_mux_sel),
    .cad(cad_writeback),
    .gp_we(gp_we_writeback)
);

writeback_stage writeback(
    .memory_out(mem_out_memory),
    .alu_res(alu_res_memory),
    .shift_res(shift_res_memory),
    .link_addr_memory(link_addr_memory),
    .gp_mux_sel(gpr_mux_sel),
    .gpr_data_in(gpr_data_in)
);

gpr genreg(
    .we(gp_we_writeback),
    .ra1(ra1_decoder),
    .ra2(ra2_decoder),
    .wa(cad_writeback),
    .rd1(a_gpr),
    .rd2(b_gpr),
    .wd(gpr_data_in),
    .register_out(debug_hex_display)
);

endmodule