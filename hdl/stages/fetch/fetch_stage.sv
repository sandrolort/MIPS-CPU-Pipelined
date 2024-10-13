module fetch_stage (
    input clk, rst,
    input  [31:0] i_mem,    //imout
    output [31:0] i_fetch   //I
);

delay instr_fetch_delay(clk, 0, rst, i_mem, i_fetch);

endmodule