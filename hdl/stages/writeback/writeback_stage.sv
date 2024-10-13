module writeback_stage(
    input [31:0] memory_out,
    input [31:0] alu_res,
    input [31:0] shift_res,
    input [31:0] link_addr_memory,
    input [1:0] gp_mux_sel,
    output [31:0] gpr_data_in
);

assign gpr_data_in = 
    (gp_mux_sel == 2'b00) ? alu_res :
    (gp_mux_sel == 2'b01) ? memory_out :
    (gp_mux_sel == 2'b10) ? shift_res :
    (gp_mux_sel == 2'b11) ? link_addr_memory :
    32'b0;

endmodule