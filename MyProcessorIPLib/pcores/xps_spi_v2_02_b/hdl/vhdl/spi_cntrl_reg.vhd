-------------------------------------------------------------------------------
--  SPI Control Register Module - entity/architecture pair
-------------------------------------------------------------------------------
-- ************************************************************************
-- ** DISCLAIMER OF LIABILITY                                            **
-- **                                                                    **
-- ** This file contains proprietary and confidential information of     **
-- ** Xilinx, Inc. ("Xilinx"), that is distributed under a license       **
-- ** from Xilinx, and may be used, copied and/or disclosed only         **
-- ** pursuant to the terms of a valid license agreement with Xilinx.    **
-- **                                                                    **
-- ** XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION              **
-- ** ("MATERIALS") "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER         **
-- ** EXPRESSED, IMPLIED, OR STATUTORY, INCLUDING WITHOUT                **
-- ** LIMITATION, ANY WARRANTY WITH RESPECT TO NONINFRINGEMENT,          **
-- ** MERCHANTABILITY OR FITNESS FOR ANY PARTICULAR PURPOSE. Xilinx      **
-- ** does not warrant that functions included in the Materials will     **
-- ** meet the requirements of Licensee, or that the operation of the    **
-- ** Materials will be uninterrupted or error-free, or that defects     **
-- ** in the Materials will be corrected. Furthermore, Xilinx does       **
-- ** not warrant or make any representations regarding use, or the      **
-- ** results of the use, of the Materials in terms of correctness,      **
-- ** accuracy, reliability or otherwise.                                **
-- **                                                                    **
-- ** Xilinx products are not designed or intended to be fail-safe,      **
-- ** or for use in any application requiring fail-safe performance,     **
-- ** such as life-support or safety devices or systems, Class III       **
-- ** medical devices, nuclear facilities, applications related to       **
-- ** the deployment of airbags, or any other applications that could    **
-- ** lead to death, personal injury or severe property or               **
-- ** environmental damage (individually and collectively, "critical     **
-- ** applications"). Customer assumes the sole risk and liability       **
-- ** of any use of Xilinx products in critical applications,            **
-- ** subject only to applicable laws and regulations governing          **
-- ** limitations on product liability.                                  **
-- **                                                                    **
-- ** Copyright 2005, 2006, 2008, 2009, 2010 Xilinx, Inc.                **
-- ** All rights reserved.                                               **
-- **                                                                    **
-- ** This disclaimer and copyright notice must be retained as part      **
-- ** of this file at all times.                                         **
-- ************************************************************************
-- 
-------------------------------------------------------------------------------
-- Filename:        spi_cntrl_reg.vhd
-- Version:         v2.02.a
-- Description:     Serial Peripheral Interface (SPI) Module for interfacing
--                  with a 32-bit plbv46_slave_single.
--
-------------------------------------------------------------------------------
-- Structure:   This section should show the hierarchical structure of the
--              designs. Separate lines with blank lines if necessary to
--              improve readability.
--
--              xps_spi.vhd
--                 --plbv46_slave_single.vhd
--                    --plb_slave_attachment.vhd
--                       --plb_address_decoder.vhd
--                 --interrupt_control.vhd
--                 --soft_reset.vhd
--                 --srl_fifo.vhd
--                 --spi_receive_transmit_reg.vhd
--                 --spi_cntrl_reg.vhd
--                 --spi_status_slave_sel_reg.vhd
--                 --spi_module.vhd
--                 --spi_fifo_ifmodule.vhd
--                 --spi_occupancy_reg.vhd
-------------------------------------------------------------------------------
-- Author:      MZC
-- History:
--  MZC      11/08/06      -- First version
-- ^^^^^^
--  SK       2/04/08
-- ~~~~~~
--  - Optimized the design. reduced the no. of ACK's generated by a simple logic
--  - removed unwanted signals and code cleaning.
--  --added logic for making _T signals in IOB.
-- ^^^^^^
--  SK       03/11/08
-- ~~~~~~
-- -- Update the version of the core(v2_01_a) based upon v2_00_b version.
-- -- IPIF and proc_common libraries are upgraded.
-- -- Changed FDCE (async reset FF) to FDRE  (sync reset FF).
-- ^^^^^^
--  SK       05/16/09
-- ~~~~~~
-- -- Registered the SCK output in C_SCK_RATIO = 4 mode.
-- -- CR 512141 is closed.
-- ^^^^^^
--  SK       02/18/10
-- ~~~~~~
-- 1. Added interrupt logic when the SPI is configured in the slave mode.
--    Interrupt will be generated when the SPISEL line is asserted.
-- -- CR 543500 is closed.
-- ^^^^^^
-------------------------------------------------------------------------------
-- Naming Conventions:
--      active low signals:                     "*_n"
--      clock signals:                          "clk", "clk_div#", "clk_#x"
--      reset signals:                          "rst", "rst_n"
--      generics:                               "C_*"
--      user defined types:                     "*_TYPE"
--      state machine next state:               "*_ns"
--      state machine current state:            "*_cs"
--      combinatorial signals:                  "*_cmb"
--      pipelined or register delay signals:    "*_d#"
--      counter signals:                        "*cnt*"
--      clock enable signals:                   "*_ce"
--      internal version of output port         "*_i"
--      device pins:                            "*_pin"
--      ports:                                  - Names begin with Uppercase
--      processes:                              "*_PROCESS"
--      component instantiations:               "<ENTITY_>I_<#|FUNC>
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

library proc_common_v3_00_a;
use proc_common_v3_00_a.proc_common_pkg.RESET_ACTIVE;

library unisim;
use unisim.vcomponents.FDRE;
-------------------------------------------------------------------------------
--                     Definition of Generics
-------------------------------------------------------------------------------

--  C_DBUS_WIDTH                --      Width of the slave data bus
--  C_NUM_BITS_REG              --      Width of SPI registers

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--                  Definition of Ports
-------------------------------------------------------------------------------

-- SYSTEM

--  Bus2IP_Clk                  --      Bus to IP clock
--  Reset                       --      Reset Signal

-- SLAVE ATTACHMENT INTERFACE
--  Wr_ce_reduce_ack_gen        --      common write ack generation logic input
--  Bus2IP_Control_Reg_Data     --      Data written from the PLB bus
--  Bus2IP_Control_Reg_WrCE     --      Write CE for control register
--  Bus2IP_Control_Reg_RdCE     --      Read CE for control register
--  Reg2SA_Control_Reg_Data     --      Data to be send on the bus

-- SPI MODULE INTERFACE
--  Control_Register_Data       --      Data to be send on the bus
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Entity Declaration
-------------------------------------------------------------------------------
entity spi_cntrl_reg is
      generic
      (
      C_DBUS_WIDTH               : integer;       -- 32 bits
      -- Number of bits in register, 10 for control reg
      C_NUM_BITS_REG             : integer
      );
      port
      (
      Bus2IP_Clk                 : in  std_logic;
      Reset                      : in  std_logic;
      -- Slave attachment ports
      Wr_ce_reduce_ack_gen       : in std_logic;
      Bus2IP_Control_Reg_WrCE    : in  std_logic;
      Bus2IP_Control_Reg_RdCE    : in  std_logic;
      Bus2IP_Control_Reg_Data    : in  std_logic_vector(0 to C_DBUS_WIDTH-1);

      Reg2SA_Control_Reg_Data    : out std_logic_vector(0 to C_NUM_BITS_REG-1);
      -- SPI module ports
      Control_Register_Data      : out std_logic_vector(0 to C_NUM_BITS_REG-1);
      Control_bit_7_8            : out std_logic_vector(7 to 8)
      );
end spi_cntrl_reg;

-------------------------------------------------------------------------------
-- Architecture
-------------------------------------------------------------------------------
architecture imp of spi_cntrl_reg is
-------------------------------------
-- Signal Declarations
----------------------
signal control_register_data_int : std_logic_vector(0 to C_NUM_BITS_REG-1);
signal control_bits34_Reset      : std_logic;

begin
----------------------------
--  Combinatorial operations
----------------------------
Control_Register_Data   <= control_register_data_int;
-----------------------------------------------------

--  I_CONTROL_REG_0_PROCESS : Control Register Write Operation for bit 0
-----------------------------
I_CONTROL_REG_0_PROCESS:process(Bus2IP_Clk)
begin
    if (Bus2IP_Clk'event and Bus2IP_Clk='1') then
        if (Reset = RESET_ACTIVE) then
            control_register_data_int(0) <= '0';
        elsif (wr_ce_reduce_ack_gen  and Bus2IP_Control_Reg_WrCE) = '1' then
            control_register_data_int(0) <=
                           Bus2IP_Control_Reg_Data(C_DBUS_WIDTH-C_NUM_BITS_REG);
        end if;
    end if;
end process I_CONTROL_REG_0_PROCESS;
-------------------------------------------------------------------------------

--  CONTROL_REG_12_GENERATE : Control Register Write Operation for bit 1 and 2
-----------------------------
CONTROL_REG_12_GENERATE: for j in 1 to 2 generate
begin
-----
    I_CONTROL_REG_PROCESS:process(Bus2IP_Clk)
    begin
        if (Bus2IP_Clk'event and Bus2IP_Clk='1') then
            if (Reset = RESET_ACTIVE) then
                control_register_data_int(j) <= '1';
            elsif (wr_ce_reduce_ack_gen  and Bus2IP_Control_Reg_WrCE) = '1' then
                control_register_data_int(j) <=
                         Bus2IP_Control_Reg_Data(C_DBUS_WIDTH-C_NUM_BITS_REG+j);
            end if;
        end if;
    end process I_CONTROL_REG_PROCESS;
-----
end generate CONTROL_REG_12_GENERATE;
-------------------------------------------------------------------------------

--  CONTROL_REG_34_GENERATE : Control Register Write Operation for bit 3 and 4
-----------------------------
CONTROL_REG_34_GENERATE: for j in 3 to 4 generate
begin
-----
    I_CONTROL_REG_PROCESS:process(Bus2IP_Clk)
    begin
        if (Bus2IP_Clk'event and Bus2IP_Clk='1') then
            if (control_bits34_Reset = '1') then
                control_register_data_int(j) <= '0';
            elsif (wr_ce_reduce_ack_gen  and Bus2IP_Control_Reg_WrCE) = '1' then
                control_register_data_int(j) <=
                         Bus2IP_Control_Reg_Data(C_DBUS_WIDTH-C_NUM_BITS_REG+j);
            end if;
        end if;
    end process I_CONTROL_REG_PROCESS;
-----
end generate CONTROL_REG_34_GENERATE;
-------------------------------------------------------------------------------

--  CONTROL_REG_GENERATE : Control Register Write Operation for bits 5 to
--                         C_NUM_BITS_REG-1
--------------------------
CONTROL_REG_GENERATE: for j in 5 to C_NUM_BITS_REG-1 generate
begin
-----
    I_CONTROL_REG_PROCESS:process(Bus2IP_Clk)
    begin
        if (Bus2IP_Clk'event and Bus2IP_Clk='1') then
            if (Reset = RESET_ACTIVE) then
                control_register_data_int(j) <= '0';
            elsif (wr_ce_reduce_ack_gen  and Bus2IP_Control_Reg_WrCE) = '1' then
                control_register_data_int(j) <=
                         Bus2IP_Control_Reg_Data(C_DBUS_WIDTH-C_NUM_BITS_REG+j);
            end if;
        end if;
    end process I_CONTROL_REG_PROCESS;
-----
end generate CONTROL_REG_GENERATE;
----------------------------------
control_bits34_Reset <= (not Bus2IP_Control_Reg_WrCE) or Reset;
---------------------------------------------------------------
--  CONTROL_REG_RD_GENERATE : Control Register Read Data Generate
-----------------------------
CONTROL_REG_RD_GENERATE: for j in 0 to C_NUM_BITS_REG-1 generate
begin
     Reg2SA_Control_Reg_Data(j) <= control_register_data_int(j) and
                                                        Bus2IP_Control_Reg_RdCE;
end generate CONTROL_REG_RD_GENERATE;
-------------------------------------

-- CONTROL_REG_78_GENERATE: This logic is newly added to register _T signals
-- ------------------------ in IOB. This logic simplifies the register method
--                          for _T in IOB, without affecting functionality.

CONTROL_REG_78_GENERATE: for i in 7 to C_NUM_BITS_REG-2 generate
begin

SPI_TRISTATE_CONTROL_I: component FDRE
        port map
        (
        Q  => Control_bit_7_8(i)        ,
        C  => Bus2IP_Clk                ,--: in
        CE => Bus2IP_Control_Reg_WrCE   ,--: in
        R  => Reset                     ,-- : in
        D  => Bus2IP_Control_Reg_Data(C_DBUS_WIDTH-C_NUM_BITS_REG+i)    --: in
        );
end generate CONTROL_REG_78_GENERATE;

end imp;
--------------------------------------------------------------------------------
