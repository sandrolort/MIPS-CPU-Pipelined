module alu(
    input [31:0] a,
    input [31:0] b,
    input [3:0] af,
    input i,
    output [31:0] alures,
    output ovfalu
);

wire [31:0] au_result;
wire au_neg, au_ovf;

au arithmetic_unit (
    .a(a),
    .b(b),
    .sub(af[1]),
    .u(af[0]),
    .s(au_result),
    .neg(au_neg),
    .ovf(au_ovf)
);

wire [31:0] mux_result;
assign mux_result = 
    (af == 4'b0000 || af == 4'b0001 || af == 4'b0010 || af == 4'b0011) ? au_result :
    (af == 4'b0100) ? a & b :
    (af == 4'b0101) ? a | b :
    (af == 4'b0110) ? a ^ b :
    (af == 4'b0111) ? i ? {b[15:0], 16'b0} : ~(a | b) :
    (af == 4'b1010 || af == 4'b1011) ? {31'b0, au_neg} :
    {32{1'b0}};

assign alures = mux_result;
assign ovfalu = au_ovf & ~af[3] & ~af[2];

endmodule
