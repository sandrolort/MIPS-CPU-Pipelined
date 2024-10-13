module memory_stage_mock(
    input wire select, //1 - d_pc, 0 - addr_in
    input wire [29:0] d_pc,
    input wire [29:0] addr_in,
    input wire [31:0] data_in,
    input wire mem_wren,
    output wire [31:0] out
);
reg [31:0] instruction_memory [0:30];

initial begin
    for (integer i = 0; i < 30; i = i + 1) begin
        instruction_memory[i] = 32'h00000000;
    end

    // instruction_memory[0] = 32'h24010001; // addiu $1, $0, 1
    // instruction_memory[1] = 32'h24020002; // addiu $2, $0, 2
    // instruction_memory[2] = 32'h24030003; // addiu $3, $0, 3
    // instruction_memory[3] = 32'h24040004; // addiu $4, $0, 4
    // instruction_memory[4] = 32'h24050005; // addiu $5, $0, 5
    // instruction_memory[5] = 32'h2406000A; // addiu $6, $0, 10
    // instruction_memory[6] = 32'h24070064; // addiu $7, $0, 100
    // instruction_memory[7] = 32'h240803E8; // addiu $8, $0, 1000
    // instruction_memory[8] = 32'h2409FFFF; // addiu $9, $0, 65535
    // instruction_memory[9] = 32'h240A8000; // addiu $10, $0, 32768

    // // Basic arithmetic and logical operations
    instruction_memory[0]  = 32'h24020005; // addiu $2, $0, 5    - Set $2 to 5
    instruction_memory[1]  = 32'h24030007; // addiu $3, $0, 7    - Set $3 to 7
    instruction_memory[2]  = 32'h24040002; // addiu $4, $0, 2    - Set $4 to 2
    instruction_memory[3]  = 32'h24050003; // addiu $5, $0, 3    - Set $5 to 3
    instruction_memory[4]  = 32'h00430820; // add $1, $2, $3     - $1 = $2 + $3 (5 + 7 = 12)
    instruction_memory[5]  = 32'h00A42822; // sub $5, $5, $4     - $5 = $5 - $4 (3 - 2 = 1)
    instruction_memory[6]  = 32'h00623824; // and $7, $3, $2     - $7 = $3 & $2 (7 & 5 = 5)
    instruction_memory[7] = 32'h8C0A0010;  // lw $10, 16($0) - Load word from memory address 16 into $10
    instruction_memory[8]  = 32'h00624025; // or $8, $3, $2      - $8 = $3 | $2 (7 | 5 = 7)
    instruction_memory[9]  = 32'h00624826; // xor $9, $3, $2     - $9 = $3 ^ $2 (7 ^ 5 = 2)
    instruction_memory[10] = 32'h00423827; // nor $7, $2, $2     - $7 = ~($2 | $2) (not 5 = -6 in two's complement)
    instruction_memory[11]  = 32'h24020004; // addiu $2, $0, 5    - Set $2 to 5
    instruction_memory[12]  = 32'h24030005; // addiu $3, $0, 7    - Set $3 to 7
    instruction_memory[13]  = 32'h24040006; // addiu $4, $0, 2    - Set $4 to 2

    // // Shift operations
    // instruction_memory[10] = 32'h00022080; // sll $4, $2, 2      - $4 = $2 << 2 (5 << 2 = 20)
    // instruction_memory[11] = 32'h00032882; // srl $5, $3, 2      - $5 = $3 >> 2 (7 >> 2 = 1)
    // instruction_memory[12] = 32'h00033083; // sra $6, $3, 2      - $6 = $3 >>> 2 (7 >>> 2 = 1)

    // Test instructions for unsigned addition with forwarding
    // instruction_memory[0] = 32'h24020001; // addiu $2, $0, 1    ; $2 = 1
    // instruction_memory[1] = 32'h24030002; // addiu $3, $0, 2    ; $3 = 2
    // instruction_memory[2] = 32'h00432021; // addu $4, $2, $3    ; $4 = $2 + $3 = 3 (forward from previous two instructions)
    // instruction_memory[3] = 32'h00642821; // addu $5, $3, $4    ; $5 = $3 + $4 = 5 (forward $4 from previous instruction)
    // instruction_memory[4] = 32'h00853021; // addu $6, $4, $5    ; $6 = $4 + $5 = 8 (forward $5 from previous instruction)
    // instruction_memory[5] = 32'h24070005; // addiu $7, $0, 5    ; $7 = 5
    // instruction_memory[6] = 32'h00E63821; // addu $7, $7, $6    ; $7 = $7 + $6 = 13 (forward $6 from two instructions ago, and $7 from previous instruction)
    // instruction_memory[7] = 32'h24080001; // addiu $8, $0, 1    ; $8 = 1
    // instruction_memory[8] = 32'h01074021; // addu $8, $8, $7    ; $8 = $8 + $7 = 14 (forward $7 from two instructions ago, and $8 from previous instruction)
    // instruction_memory[9] = 32'h01088821; // addu $17, $8, $8   ; $17 = $8 + $8 = 28 (forward $8 from previous instruction)
end

assign out = instruction_memory[select ? d_pc : addr_in];

endmodule