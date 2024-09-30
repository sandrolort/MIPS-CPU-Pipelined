//`define ENABLE_DDR2LP
//`define ENABLE_SRAM

module baseline_c5gx(
    ///////// CLOCK /////////
    input              CLOCK_125_p, ///LVDS
    input              CLOCK_50_B5B, ///3.3-V LVTTL

    ///////// CPU /////////
    input              CPU_RESET_n, ///3.3V LVTTL

`ifdef ENABLE_DDR2LP
    ///////// DDR2LP ///////// 1.2-V HSUL ///////
    output      [9:0]  DDR2LP_CA,
    output      [1:0]  DDR2LP_CKE,
    output             DDR2LP_CK_n, ///DIFFERENTIAL 1.2-V HSUL
    output             DDR2LP_CK_p, ///DIFFERENTIAL 1.2-V HSUL
    output      [1:0]  DDR2LP_CS_n,
    output      [3:0]  DDR2LP_DM,
    inout       [31:0] DDR2LP_DQ,
    inout       [3:0]  DDR2LP_DQS_n, ///DIFFERENTIAL 1.2-V HSUL
    inout       [3:0]  DDR2LP_DQS_p, ///DIFFERENTIAL 1.2-V HSUL
    input              DDR2LP_OCT_RZQ, ///1.2 V
`endif /*ENABLE_DDR2LP*/

	 ///////// HEX2 ///////// 1.2 V ///////
    output      [6:0]  HEX2,

    ///////// HEX3 ///////// 1.2 V ///////
    output      [6:0]  HEX3,	
	 
    ///////// HEX0 /////////
    output      [6:0]  HEX0,

    ///////// HEX1 /////////
    output      [6:0]  HEX1,
	 
    ///////// KEY ///////// 1.2 V ///////
    input       [3:0]  KEY,

    ///////// LEDG ///////// 2.5 V ///////
    output      [7:0]  LEDG,

    ///////// LEDR ///////// 2.5 V ///////
    output      [9:0]  LEDR,
	
`ifdef ENABLE_SRAM
    ///////// SRAM ///////// 3.3-V LVTTL ///////
    output      [17:0] SRAM_A,
    output             SRAM_CE_n,
    inout       [15:0] SRAM_D,
    output             SRAM_LB_n,
    output             SRAM_OE_n,
    output             SRAM_UB_n,
    output             SRAM_WE_n,
`endif /*ENABLE SRAM*/

    ///////// SW ///////// 1.2 V ///////
    input       [9:0]  SW
);

wire [31:0] hex_value;

master mstr(
    .external_clk(CLOCK_125_p),
    .rst(SW[0]),
    .debug_hex_display(hex_value)
);

endmodule
