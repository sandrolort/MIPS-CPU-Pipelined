`define SIMULATION

// Interfaces
`include "../hdl/interfaces/decoder_concat.sv"
`include "../hdl/interfaces/decoder_deconcat.sv"

// Utility (include these first as they might be used by other modules)
`include "../hdl/utility/clock_div.sv"
`include "../hdl/utility/delay.sv"
`include "../hdl/utility/splitter.sv"

// Stages
`include "../hdl/stages/decode/bce.sv"
`include "../hdl/stages/decode/next_pc_calc.sv"
`include "../hdl/stages/decode/decode_stage.sv"
`include "../hdl/stages/decode/i_decoder.sv"

`include "../hdl/stages/execute/alu_decoder_bridge.sv"
`include "../hdl/stages/execute/alu.sv"
`include "../hdl/stages/execute/au.sv"
`include "../hdl/stages/execute/execute_stage.sv"
`include "../hdl/stages/execute/shifter.sv"

`include "../hdl/stages/fetch/fetch_stage.sv"

`include "../hdl/stages/memory/memory_stage_mock.sv"

`include "../hdl/stages/writeback/gpr.sv"
`include "../hdl/stages/writeback/writeback_stage.sv"

// Include master.sv last
`include "../hdl/master.sv"

`default_nettype none

module tb_master;
  reg clk;
  reg rst_n;
  
  // Instantiate the master module
  master mst(
    .external_clk(clk),
    .rst(rst_n)
  );
  
  localparam CLK_PERIOD = 10;
  
  always #(CLK_PERIOD/2) clk = ~clk;
  
  initial begin
    $dumpfile("tb_master.vcd");
    $dumpvars(0, tb_master);
  end
  
  initial begin
    #1 rst_n <= 1'bx; clk <= 1'bx;
    #(CLK_PERIOD*3) rst_n <= 1;
    #(CLK_PERIOD*3) rst_n <= 0; clk <= 0;
    repeat(50) @(posedge clk);
    rst_n <= 1;
    @(posedge clk);
    repeat(2) @(posedge clk);
    $finish(2);
  end
endmodule

`default_nettype wire