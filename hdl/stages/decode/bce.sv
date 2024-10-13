// Branch Condition Evaluation unit
module bce (
	input  [31:0] a, b,
	input  [3:0] bf,
	output bcres
);

wire [31:0] d;
wire eq, lt, le;

assign d= (bf[3]&~bf[2]?b:{32{1'b0}});
assign eq = (a==d);
assign lt= a[31];
assign le= lt | (a=={32{1'b0}});
assign bcres = (~bf[3] & ~bf[2] & bf[1] & (bf[0] ^ lt)) |
               ( bf[3] & ~bf[2] & (bf[1] ^ eq)) |
               ( bf[3] &  bf[2] & (bf[1] ^ le));
endmodule