`timescale 1ps/1ps

module tb_master;
  reg clk = 0;
  reg rst_n = 1;
  
  // Instantiate the master module
  master mst(
    .external_clk(clk),
    .rst(rst_n)
  );
  
  localparam CLK_PERIOD = 10;

  integer CYCLE = 0;
  
  always #(CLK_PERIOD/2) begin
    clk = ~clk;
    CYCLE = CYCLE + 1;
  end
  
  initial begin
    $dumpfile("tb_master.vcd");
    $dumpvars(0, tb_master);
  end
  
  initial #(CLK_PERIOD*3) rst_n <= 0;

  always #CLK_PERIOD clk <= ~clk;
endmodule

`default_nettype wire