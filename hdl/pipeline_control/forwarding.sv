module forwarding (
    input [4:0] full_bits,
    input [4:0] rs_decode,
    input [4:0] rt_decode,
    input [4:0] cad_execute,
    input [4:0] cad_memory,
    input gp_we_execute,
    input gp_we_memory,
    output [1:0] forward_a,
    output [1:0] forward_b
);

wire forward_a_mem = gp_we_memory && (cad_memory != 0) && (cad_memory == rs_decode) && full_bits[3];
wire forward_b_mem = gp_we_memory && (cad_memory != 0) && (cad_memory == rt_decode) && full_bits[3];

wire forward_a_exe = gp_we_execute && (cad_execute != 0) && (cad_execute == rs_decode) && full_bits[2];
wire forward_b_exe = gp_we_execute && (cad_execute != 0) && (cad_execute == rt_decode) && full_bits[2];

assign forward_a = forward_a_exe ? 2'b10 : (forward_a_mem ? 2'b01 : 2'b00);
assign forward_b = forward_b_exe ? 2'b10 : (forward_b_mem ? 2'b01 : 2'b00);

endmodule