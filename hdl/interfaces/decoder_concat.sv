module decoder_concat (
    input [3:0] af,
    input i,
    input alu_mux_sel,
    input [2:0] shift_type,
    input [4:0] cad,
    input gp_we,
    input [1:0] gp_mux_sel,
    input [3:0] bf,
    input [1:0] pc_mux_select,
    input mem_wren,
    input [4:0] rs, rt, rd,
    output [38:0] packed_out
);

assign packed_out = {af, i, alu_mux_sel, shift_type, cad, gp_we,
                        gp_mux_sel, bf, pc_mux_select, mem_wren,
                        rs, rt, rd};

endmodule