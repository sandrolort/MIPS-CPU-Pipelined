//Module responsible of splitting up arguments. (rs/rt/rd/etc)
//This allows simplification of the IDecoder and the ALU
module splitter(
	input [31:0] i_input,
	output[5:0] opc, fun,
	output[4:0] rs, rt, rd, sa,
	output[15:0] imm,
	output[25:0] iindex
);

assign opc = i_input[31:26];
assign rs = i_input[25:21];
assign rt = i_input[20:16];
assign rd = i_input[15:11];
assign sa = i_input[10:6];
assign fun = i_input[5:0];

assign imm = i_input[15:0];
assign iindex = i_input[25:0];

endmodule