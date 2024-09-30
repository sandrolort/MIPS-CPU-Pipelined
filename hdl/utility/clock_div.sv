/*
 *  Generates a slower clock from an input one.
 *  div_bit - How slow you want the new clock to be, 2^(div_bit) times slower.
 *  div_bit = 1 - 2 times, 
 *  div_bit = 2 - 4 times and so on.
 */
module clock_div #(div_bit = 1) (
    input fast_clk,
    output slow_clk
);

reg [div_bit+1:0] clk_div = 0;
always @(posedge fast_clk) clk_div <= clk_div + 1'b1;

assign slow_clk = clk_div[div_bit];
    
endmodule