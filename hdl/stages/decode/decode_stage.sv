module decode_stage(
    input [31:0] a_gpr, b_gpr,
    input [31:0] i_fetch,
    output [31:0] pc, d_pc,
    output [4:0] rs, rt,
    output [31:0] i_decoder,
    output [31:0] a_decoder, b_decoder,
    output [31:0] link_addr_del,
    output [38:0] decoder_packed_del
);

wire [38:0] decode_data;
wire [31:0] next_pc;

i_decoder idc(
    .rs(rs),
    .rt(rt),
    .instruction(i_fetch),
    .out_data_packed(decode_data)
);

delay pc_delay      (master.clk, master.rst, next_pc, pc);
delay d_pc_delay    (master.clk, master.rst, pc, d_pc);
delay link_delay    (master.clk, master.rst, pc+32'd8, link_addr_del);
delay i2_ex_delay   (master.clk, master.rst, i_fetch, i_decoder);
delay a_delay       (master.clk, master.rst, a_gpr, a_decoder);
delay b_delay       (master.clk, master.rst, b_gpr, b_decoder);
delay #(39) decoder_delay (master.clk, master.rst, decode_data, decoder_packed_del);

next_pc_calc next_pc_calc_inst(
    .pc(pc),
    .a_gpr(a_gpr),
    .b_gpr(b_gpr),
    .i_fetch(i_fetch),
    .decode_data_packed(decode_data),
    .next_pc(next_pc)
);


endmodule