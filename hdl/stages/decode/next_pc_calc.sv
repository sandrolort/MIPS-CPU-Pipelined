module next_pc_calc(
    input wire [31:0] pc,
    input wire [31:0] a_gpr, b_gpr,
    input wire [31:0] i_fetch,
    input wire [38:0] decode_data_packed,
    output wire [31:0] next_pc
);

// Splitter logic
wire [5:0] opc, fun;
wire [4:0] rs, rt, rd, sa;
wire [15:0] imm;
wire [25:0] iindex;
splitter splt(i_fetch, opc, fun, rs, rt, rd, sa, imm, iindex);

// Unpack only the necessary wires from decode_data_packed
wire [3:0] bf;
wire [1:0] pc_mux_select;
decoder_deconcat deconcat_inst (
    .packed_in(decode_data_packed),
    .bf(bf),
    .pc_mux_select(pc_mux_select)
);

// Branch condition evaluation unit
wire bcres;
bce bce(a_gpr, b_gpr, bf, bcres);

// Next PC calculation logic
wire [31:0] incr = pc + 4;
wire [31:0] pc_imm_sum = $unsigned($signed(pc) + $signed(imm << 2));
wire [31:0] jjal = {incr[31:28], iindex, 2'b00};
wire [31:0] mux_bcres = bcres ? pc_imm_sum : incr;

assign next_pc =
    (pc_mux_select == 2'b11) ? incr :
    (pc_mux_select == 2'b01) ? mux_bcres :
    (pc_mux_select == 2'b10) ? jjal :
    a_gpr;

endmodule