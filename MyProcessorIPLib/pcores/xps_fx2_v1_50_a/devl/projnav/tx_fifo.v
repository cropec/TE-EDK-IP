/*******************************************************************************
*     This file is owned and controlled by Xilinx and must be used             *
*     solely for design, simulation, implementation and creation of            *
*     design files limited to Xilinx devices or technologies. Use              *
*     with non-Xilinx devices or technologies is expressly prohibited          *
*     and immediately terminates your license.                                 *
*                                                                              *
*     XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS"            *
*     SOLELY FOR USE IN DEVELOPING PROGRAMS AND SOLUTIONS FOR                  *
*     XILINX DEVICES.  BY PROVIDING THIS DESIGN, CODE, OR INFORMATION          *
*     AS ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE, APPLICATION              *
*     OR STANDARD, XILINX IS MAKING NO REPRESENTATION THAT THIS                *
*     IMPLEMENTATION IS FREE FROM ANY CLAIMS OF INFRINGEMENT,                  *
*     AND YOU ARE RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE         *
*     FOR YOUR IMPLEMENTATION.  XILINX EXPRESSLY DISCLAIMS ANY                 *
*     WARRANTY WHATSOEVER WITH RESPECT TO THE ADEQUACY OF THE                  *
*     IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR           *
*     REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE FROM CLAIMS OF          *
*     INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS          *
*     FOR A PARTICULAR PURPOSE.                                                *
*                                                                              *
*     Xilinx products are not intended for use in life support                 *
*     appliances, devices, or systems. Use in such applications are            *
*     expressly prohibited.                                                    *
*                                                                              *
*     (c) Copyright 1995-2009 Xilinx, Inc.                                     *
*     All rights reserved.                                                     *
*******************************************************************************/
// The synthesis directives "translate_off/translate_on" specified below are
// supported by Xilinx, Mentor Graphics and Synplicity synthesis
// tools. Ensure they are correct for your synthesis tool(s).

// You must compile the wrapper file tx_fifo.v when simulating
// the core, tx_fifo. When compiling the wrapper file, be sure to
// reference the XilinxCoreLib Verilog simulation library. For detailed
// instructions, please refer to the "CORE Generator Help".

`timescale 1ns/1ps

module tx_fifo(
	din,
	rd_clk,
	rd_en,
	rst,
	wr_clk,
	wr_en,
	dout,
	empty,
	full,
	overflow,
	valid,
	underflow,
	wr_data_count);


input [31 : 0] din;
input rd_clk;
input rd_en;
input rst;
input wr_clk;
input wr_en;
output [7 : 0] dout;
output empty;
output full;
output overflow;
output valid;
output underflow;
output [12 : 0] wr_data_count;

// synthesis translate_off

      FIFO_GENERATOR_V4_2 #(
		.C_COMMON_CLOCK(0),
		.C_COUNT_TYPE(0),
		.C_DATA_COUNT_WIDTH(13),
		.C_DEFAULT_VALUE("BlankString"),
		.C_DIN_WIDTH(32),
		.C_DOUT_RST_VAL("0"),
		.C_DOUT_WIDTH(8),
		.C_ENABLE_RLOCS(0),
		.C_FAMILY("spartan3"),
		.C_FULL_FLAGS_RST_VAL(0),
		.C_HAS_ALMOST_EMPTY(0),
		.C_HAS_ALMOST_FULL(0),
		.C_HAS_BACKUP(0),
		.C_HAS_DATA_COUNT(0),
		.C_HAS_INT_CLK(0),
		.C_HAS_MEMINIT_FILE(0),
		.C_HAS_OVERFLOW(1),
		.C_HAS_RD_DATA_COUNT(0),
		.C_HAS_RD_RST(0),
		.C_HAS_RST(1),
		.C_HAS_SRST(0),
		.C_HAS_UNDERFLOW(1),
		.C_HAS_VALID(1),
		.C_HAS_WR_ACK(0),
		.C_HAS_WR_DATA_COUNT(1),
		.C_HAS_WR_RST(0),
		.C_IMPLEMENTATION_TYPE(2),
		.C_INIT_WR_PNTR_VAL(0),
		.C_MEMORY_TYPE(1),
		.C_MIF_FILE_NAME("BlankString"),
		.C_OPTIMIZATION_MODE(0),
		.C_OVERFLOW_LOW(0),
		.C_PRELOAD_LATENCY(1),
		.C_PRELOAD_REGS(0),
		.C_PRIM_FIFO_TYPE("8kx4"),
		.C_PROG_EMPTY_THRESH_ASSERT_VAL(2),
		.C_PROG_EMPTY_THRESH_NEGATE_VAL(3),
		.C_PROG_EMPTY_TYPE(0),
		.C_PROG_FULL_THRESH_ASSERT_VAL(8189),
		.C_PROG_FULL_THRESH_NEGATE_VAL(8188),
		.C_PROG_FULL_TYPE(0),
		.C_RD_DATA_COUNT_WIDTH(15),
		.C_RD_DEPTH(32768),
		.C_RD_FREQ(1),
		.C_RD_PNTR_WIDTH(15),
		.C_UNDERFLOW_LOW(0),
		.C_USE_DOUT_RST(1),
		.C_USE_ECC(0),
		.C_USE_EMBEDDED_REG(0),
		.C_USE_FIFO16_FLAGS(0),
		.C_USE_FWFT_DATA_COUNT(0),
		.C_VALID_LOW(0),
		.C_WR_ACK_LOW(0),
		.C_WR_DATA_COUNT_WIDTH(13),
		.C_WR_DEPTH(8192),
		.C_WR_FREQ(1),
		.C_WR_PNTR_WIDTH(13),
		.C_WR_RESPONSE_LATENCY(1))
	inst (
		.DIN(din),
		.RD_CLK(rd_clk),
		.RD_EN(rd_en),
		.RST(rst),
		.WR_CLK(wr_clk),
		.WR_EN(wr_en),
		.DOUT(dout),
		.EMPTY(empty),
		.FULL(full),
		.OVERFLOW(overflow),
		.VALID(valid),
		.UNDERFLOW(underflow),
		.WR_DATA_COUNT(wr_data_count),
		.CLK(),
		.INT_CLK(),
		.BACKUP(),
		.BACKUP_MARKER(),
		.PROG_EMPTY_THRESH(),
		.PROG_EMPTY_THRESH_ASSERT(),
		.PROG_EMPTY_THRESH_NEGATE(),
		.PROG_FULL_THRESH(),
		.PROG_FULL_THRESH_ASSERT(),
		.PROG_FULL_THRESH_NEGATE(),
		.RD_RST(),
		.SRST(),
		.WR_RST(),
		.ALMOST_EMPTY(),
		.ALMOST_FULL(),
		.DATA_COUNT(),
		.PROG_EMPTY(),
		.PROG_FULL(),
		.RD_DATA_COUNT(),
		.WR_ACK(),
		.SBITERR(),
		.DBITERR());


// synthesis translate_on

// XST black box declaration
// box_type "black_box"
// synthesis attribute box_type of tx_fifo is "black_box"

endmodule

