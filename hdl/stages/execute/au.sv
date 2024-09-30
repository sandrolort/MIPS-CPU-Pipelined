module au(
    input [31:0] a,
	input [31:0] b,
	input sub,
	input u,
    output [31:0] s,
	output neg,
	output ovf
);
	wire [31:0] d;
	wire lcin;
	wire cout;
	
	assign d = b ^ {32{sub}};
	
	assign {cout, s} = a + d + sub;
	
	assign lcin = s[31] ^ a[31] ^ d[31];
	
	assign neg = (~u & (a[31] ^ d[31] ^ cout)) | (u & ~cout & sub);
	
	assign ovf = u & (cout ^ lcin);
endmodule
