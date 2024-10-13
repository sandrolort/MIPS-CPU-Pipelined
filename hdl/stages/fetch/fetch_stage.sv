module fetch_stage (
    input  [31:0] i_mem,    //imout
    output [31:0] i_fetch   //I
);

delay instr_fetch_delay(master.clk, 0, master.rst, i_mem, i_fetch);

endmodule