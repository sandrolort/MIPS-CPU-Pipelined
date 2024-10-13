// Page 166, "A Pipelined Multi-core MIPS Machine Hardware Implementation and Correctness Proof"
// All wires, with their own successors, are declared together. That's why there's i_decoder in the 
// fetch region of the master module, for example.
module master (
    input external_clk,
    input rst,
    output [31:0] debug_hex_display,
    output [4:0] full_bit_led,
	 output clock_led
);

// Clock definitions
wire clk, mem_clk;
assign mem_clk = external_clk;
clock_div divider(mem_clk, clk);

assign clock_led = clk;

// Pipeline control signals
wire [4:0] full_bits;
wire [1:0] forward_a, forward_b;
wire [4:0] ra1_decoder, ra2_decoder;
wire [4:0] ra1, ra2;
wire gp_we_execute, gp_we_memory;
wire [4:0] cad_execute, cad_memory;
wire [31:0] alu_res, alu_res_execute, alu_res_memory;
wire [1:0] gp_mux_sel_mem;

wire mem_wren;
wire load_write_predicate = mem_wren || gp_mux_sel_mem == 2'b01;

// Instantiate full_bits_register
stall_engine staller (
    .clk(clk),
    .rst(rst),
    .load_write_predicate(load_write_predicate),
    .full_bits(full_bits)
);

// Instantiate forwarding unit
forwarding forwarder (
    .full_bits(full_bits),
    .rs_decode(ra1),
    .rt_decode(ra2),
    .cad_execute(cad_execute),
    .cad_memory(cad_memory),
    .gp_we_execute(gp_we_execute),
    .gp_we_memory(gp_we_memory),
    .forward_a(forward_a),
    .forward_b(forward_b)
);

// Fetch
wire [31:0] i_fetch, i_decoder, i_mem;

fetch_stage fetch(
    .clk(clk),
    .rst(rst),
    .i_mem(i_mem),
    .i_fetch(i_fetch)
);

// Decode
wire [31:0] next_pc, pc/* synthesis keep */, d_pc/* synthesis keep */;

wire [31:0] a_decoder, a_decoder_undel, a_gpr;
wire [31:0] b_decoder, b_decoder_undel, b_gpr;
wire [31:0] link_addr_decoder, link_addr_execute, link_addr_memory;
wire [38:0] decoder_packed, decoder_packed_decoder, decoder_packed_execute, decoder_packed_memory;

decode_stage decode(
    .a_gpr(a_gpr),
    .b_gpr(b_gpr),
    .pc(pc),
    .i_fetch(i_fetch),
    .forward_a(forward_a),
    .forward_b(forward_b),
    .alu_res_execute(alu_res_execute),
    .alu_res_memory(alu_res_memory),
    .next_pc(next_pc),
    .rs(ra1),
    .rt(ra2),
    .a_forwarded(a_decoder_undel), 
    .b_forwarded(b_decoder_undel),
    .decoder_packed(decoder_packed)
);

delay pc_delay      (clk, rst, ~full_bits[0], next_pc, pc);
delay link_delay    (clk, rst, ~full_bits[1], pc+32'd8, link_addr_decoder);
delay i2_ex_delay   (clk, rst, ~full_bits[1], i_fetch, i_decoder);
delay a_delay       (clk, rst, ~full_bits[1], a_decoder_undel, a_decoder);
delay b_delay       (clk, rst, ~full_bits[1], b_decoder_undel, b_decoder);
delay #(5) rs_del   (clk, rst, ~full_bits[1], ra1, ra1_decoder);
delay #(5) rt_del   (clk, rst, ~full_bits[1], ra2, ra2_decoder);
delay #(.default_value(4)) d_pc_delay (clk, rst, ~full_bits[1], pc, d_pc);
delay #(39) decoder_delay (clk, rst, ~full_bits[1], decoder_packed, decoder_packed_decoder);

// Execute
wire [31:0] shift_res_execute, shift_res_memory;
wire [31:0] dm_in;
wire [31:0] ea, ea_execute, ea_memory;
wire [31:0] mem_out_live, mem_out_memory;
wire ovfalu;

execute_stage execute(
    .decoder_packed_decoder(decoder_packed_decoder),
    .a_decoder(a_decoder),
    .b_decoder(b_decoder),
    .i_decoder(i_decoder),
    .pc(pc),
    .alu_res(alu_res),
    .shift_res(shift_res_execute),
    .dm_in(dm_in),
    .ea(ea),
    .ovfalu(ovfalu)
);

delay #(39) con3(clk, rst, ~full_bits[2], decoder_packed_decoder, decoder_packed_execute);
delay c3lnk (clk, rst, ~full_bits[2], link_addr_decoder, link_addr_execute);
delay alu_res_del (clk, rst, ~full_bits[2], alu_res, alu_res_execute);
delay ea_delay(clk, rst, ~full_bits[2], ea, ea_execute);

// Memory
decoder_deconcat exec_dec(
    .packed_in(decoder_packed_execute), 
    .mem_wren(mem_wren),
    .cad(cad_execute),
    .gp_mux_sel(gp_mux_sel_mem),
    .gp_we(gp_we_execute)
);

`ifdef HARDWARE
memory_stage memory(
    .mem_clk(mem_clk),
    .select(~load_write_predicate),
    .d_pc(full_bits[0] ? pc[31:2] : d_pc[31:2]),
    .addr_in(ea_execute[31:2]),
    .data_in(dm_in),
    .mem_wren(mem_wren),
    .out(mem_out_live)
);
`else
memory_stage_mock memory(
    .select(~load_write_predicate),
    .d_pc(full_bits[0] ? pc[31:2] : d_pc[31:2]),
    .addr_in(ea_execute[31:2]),
    .data_in(dm_in),
    .mem_wren(mem_wren),
    .out(mem_out_live)
);
`endif

delay mem_out_del (clk, rst, ~full_bits[3], mem_out_live, mem_out_memory);
delay #(39) con4(clk, rst, ~full_bits[3], decoder_packed_execute, decoder_packed_memory);
delay ea4 (clk, rst, ~full_bits[3], ea_execute, ea_memory);
delay c4lnk (clk, rst, ~full_bits[3], link_addr_execute, link_addr_memory);
delay c4alures (clk, rst, ~full_bits[3], alu_res_execute, alu_res_memory);
delay c4shfres (clk, rst, ~full_bits[3], shift_res_execute, shift_res_memory);

assign i_mem = mem_out_live; //todo

// Writeback
wire [1:0] gpr_mux_sel;
wire [31:0] gpr_data_in;

decoder_deconcat mem_dec(
    .packed_in(decoder_packed_memory), 
    .gp_mux_sel(gpr_mux_sel),
    .cad(cad_memory),
    .gp_we(gp_we_memory)
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
    .clk(clk),
    .rst(rst),
    .we(gp_we_memory),
    .ra1(ra1),
    .ra2(ra2),
    .wa(cad_memory),
    .rd1(a_gpr),
    .rd2(b_gpr),
    .wd(gpr_data_in),
    .register_out(debug_hex_display)
);

// Periphery
assign full_bit_led = full_bits;

endmodule