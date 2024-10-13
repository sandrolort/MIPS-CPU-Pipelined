module delay #(parameter bits = 32, parameter default_value = 0)
(
	input clk, rst, stall,
	input [bits-1:0] in,
	output reg [bits-1:0] out = 0
);

always @(posedge clk) begin
    if(rst)
        out <= default_value;
    else if (stall)
        out <= out;
    else
        out <= in;
end

endmodule