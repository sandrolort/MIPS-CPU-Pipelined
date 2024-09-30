module shifter (
    input  [1:0]  funct,
    input  [31:0] a,
    input  [4:0]  shamt,
    output wire [31:0] res
);

assign res =  	(funct == 2'b00) ? (a << shamt) :   // Logical left shift
                (funct == 2'b01) ? (a >> shamt) :   // Logical right shift
                (a >>> shamt);                      // Arithmetic right shift

endmodule
