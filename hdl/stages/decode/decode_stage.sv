module decode_stage(
    input [31:0] a_gpr, b_gpr,
    input [31:0] i_fetch,
    input [31:0] pc,
    input [1:0] forward_a,
    input [1:0] forward_b,
    input [31:0] alu_res_execute,
    input [31:0] alu_res_memory,
    output [31:0] next_pc,
    output [4:0] rs, rt,
    output [31:0] a_forwarded, b_forwarded,
    output [38:0] decoder_packed
);

assign a_forwarded = (forward_a == 2'b10) ? alu_res_execute :
                            (forward_a == 2'b01) ? alu_res_memory :
                            a_gpr;

assign b_forwarded = (forward_b == 2'b10) ? alu_res_execute :
                            (forward_b == 2'b01) ? alu_res_memory :
                            b_gpr;

i_decoder idc(
    .rs(rs),
    .rt(rt),
    .instruction(i_fetch),
    .out_data_packed(decoder_packed)
);

next_pc_calc next_pc_calc_inst(
    .pc(pc),
    .a_gpr(a_forwarded),
    .b_gpr(b_forwarded),
    .i_fetch(i_fetch),
    .decode_data_packed(decoder_packed),
    .next_pc(next_pc)
);


endmodule