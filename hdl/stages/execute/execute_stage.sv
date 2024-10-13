module execute_stage(
    input [38:0] decoder_packed_decoder,
    input [31:0] a_decoder, b_decoder,
    input [31:0] i_decoder,
    input [31:0] pc,
    output [31:0] alu_res, shift_res,
    output [31:0] dm_in,
    output [31:0] ea,
    output ovfalu
);

wire [5:0] opc, fun;
wire [4:0] rs, rt, rd, sa;
wire [15:0] imm;
wire [25:0] iindex;
splitter splt(i_decoder, opc, fun, rs, rt, rd, sa, imm, iindex);

wire [31:0] imm_extended = {{16{imm[15]}}, imm};
wire [31:0] alu_b;
wire [3:0] af;
wire i, alu_mux_sel;
wire [2:0] shift_type;

decoder_deconcat deconcat_inst (
    .packed_in(decoder_packed_decoder),
    .af(af),
    .i(i),
    .alu_mux_sel(alu_mux_sel),
    .shift_type(shift_type)
);

assign alu_b = alu_mux_sel ? imm_extended : b_decoder;
assign dm_in = b_decoder;

alu_decoder_bridge aludec(
    .opcode(opc),
    .a(a_decoder),
    .b(alu_b),
    .af(af),
    .i(i),
    .result(alu_res),
    .ovfalu(ovfalu)
);

shifter shft (
    .funct(shift_type),
    .a(b_decoder),
    .shamt(sa),
    .res(shift_res)
);

assign ea = a_decoder + imm_extended; //todo make it signed addition

endmodule