module decoder_concat (
    input wire [3:0] af,
    input wire i,
    input wire alu_mux_sel,
    input wire [2:0] shift_type,
    input wire [4:0] cad,
    input wire gp_we,
    input wire [1:0] gp_mux_sel,
    input wire [3:0] bf,
    input wire [1:0] pc_mux_select,
    input wire mem_wren,
    input wire [4:0] rd,
    input wire [4:0] rs,
    input wire [4:0] rt,
    output wire [38:0] packed_out
);
    assign packed_out = {af, i, alu_mux_sel, shift_type, cad, gp_we,
                         gp_mux_sel, bf, pc_mux_select, mem_wren,
                         rd, rs, rt};
endmodule