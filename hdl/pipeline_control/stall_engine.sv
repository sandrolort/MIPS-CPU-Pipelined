module stall_engine (
    input clk,
    input rst,
    input load_write_predicate,
    output reg [4:0] full_bits
);
wire [4:0] stall_bits;

assign stall_bits[0] = load_write_predicate;
assign stall_bits[4:1] = 4'b0;

always @(posedge master.clk or posedge master.rst) begin
    if (rst) begin
        full_bits <= 5'b00000;
    end else begin
        full_bits[4] <= full_bits[3] & ~stall_bits[4];
        full_bits[3] <= full_bits[2] & ~stall_bits[3];
        full_bits[2] <= full_bits[1] & ~stall_bits[2];
        full_bits[1] <= full_bits[0] & ~stall_bits[1];
        full_bits[0] <= ~stall_bits[0];
    end
end

endmodule