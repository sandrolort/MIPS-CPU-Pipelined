module decoder_deconcat (
    input wire [38:0] packed_in,
    output wire [3:0] af,
    output wire i,
    output wire alu_mux_sel,
    output wire [2:0] shift_type,
    output wire [4:0] cad,
    output wire gp_we,
    output wire [1:0] gp_mux_sel,
    output wire [3:0] bf,
    output wire [1:0] pc_mux_select,
    output wire mem_wren,
    output wire [4:0] rd,
    output wire [4:0] rs,
    output wire [4:0] rt
);
    assign {af, i, alu_mux_sel, shift_type, cad, gp_we,
            gp_mux_sel, bf, pc_mux_select, mem_wren,
            rd, rs, rt} = packed_in;
endmodule