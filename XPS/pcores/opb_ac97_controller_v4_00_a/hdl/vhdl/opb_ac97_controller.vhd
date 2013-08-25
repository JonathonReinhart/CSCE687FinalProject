-------------------------------------------------------------------------------
-- $Id: opb_ac97_controller.vhd,v 1.1 2003/07/01 10:42:08 patoh Exp $
-------------------------------------------------------------------------------
-- opb_ac97_controller.vhd
-------------------------------------------------------------------------------
--
--                  ****************************
--                  ** Copyright Xilinx, Inc. **
--                  ** All rights reserved.   **
--                  ****************************
--
-------------------------------------------------------------------------------
-- Filename:        opb_ac97_controller.vhd
--
-- Description:     
--                  
-- VHDL-Standard:   VHDL'93
-------------------------------------------------------------------------------
-- Structure:   
--              opb_ac97_controller.vhd
--
-------------------------------------------------------------------------------
-- Author:          goran
-- Revision:        $Revision: 1.1 $
-- Date:            $Date: 2004/04/04 10:42:08 $
--
-- History:
--   goran  2002-01-09    First Version
--   Caleb  2004-03-31    Version 3.00e
--                        *fix ac 97 core for record
--                        *modify core for fsl functionality only
--                        *added chipscope core for debug only 
--   Caleb  2004-04-04    Version 3.10a
--                        *added opb functinality option
--                        *fix interrupt routines (OPB only)
--   Caleb  2004-04-06    Version 4.00a
--                        *identical to 3.10a, but with Chipscope connections removed
--   
--
-------------------------------------------------------------------------------
-- Naming Conventions:
--      active low signals:                     "*_n"
--      clock signals:                          "clk", "clk_div#", "clk_#x" 
--      reset signals:                          "rst", "rst_n" 
--      generics:                               "C_*" 
--      user defined types:                     "*_TYPE" 
--      state machine next state:               "*_ns" 
--      state machine current state:            "*_cs" 
--      combinatorial signals:                  "*_com" 
--      pipelined or register delay signals:    "*_d#" 
--      counter signals:                        "*cnt*"
--      clock enable signals:                   "*_ce" 
--      internal version of output port         "*_i"
--      device pins:                            "*_pin" 
--      ports:                                  - Names begin with Uppercase 
--      processes:                              "*_PROCESS" 
--      component instantiations:               "<ENTITY_>I_<#|FUNC>
-------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

library unisim;
use unisim.all;

entity OPB_AC97_CONTROLLER is
  generic (
    C_OPB_AWIDTH      : integer                   := 32;
    C_OPB_DWIDTH      : integer                   := 32;
    C_BASEADDR        : std_logic_vector(0 to 31) := X"FFFF_8000";
    C_HIGHADDR        : std_logic_vector          := X"FFFF_80FF";
    C_PLAYBACK_OPB    : integer                   := 1;
    C_PLAYBACK_FSL    : integer                   := 0;
    C_RECORD_OPB      : integer                   := 1;
    C_RECORD_FSL      : integer                   := 0;
    C_FSL_DWIDTH      : integer                   := 32;
    C_PLAY_INTR_LEVEL : integer                   := 0;
    C_REC_INTR_LEVEL  : integer                   := 0;
    C_STATUS_INTR     : integer                   := 0;
    C_INTR_IS_HIGH    : integer                   := 1
    );

  port (
    -- Global signals
    OPB_Clk : in std_logic;
    OPB_Rst : in std_logic;

    -- OPB signals
    OPB_ABus    : in std_logic_vector(0 to C_OPB_AWIDTH - 1);
    OPB_BE      : in std_logic_vector(0 to 3);
    OPB_RNW     : in std_logic;
    OPB_select  : in std_logic;
    OPB_seqAddr : in std_logic;
    OPB_DBus    : in std_logic_vector(0 to C_OPB_DWIDTH - 1);

    OPB_AC97_CONTROLLER_DBus    : out std_logic_vector(0 to C_OPB_DWIDTH - 1);
    OPB_AC97_CONTROLLER_errAck  : out std_logic;
    OPB_AC97_CONTROLLER_retry   : out std_logic;
    OPB_AC97_CONTROLLER_toutSup : out std_logic;
    OPB_AC97_CONTROLLER_xferAck : out std_logic;

    -- CODEC signals
    Bit_Clk   : in  std_logic;
    Sync      : out std_logic;
    SData_Out : out std_logic;
    SData_In  : in  std_logic;

    -- PlayBack FSL signals
    FSL_S_Clk     : out std_logic;
    FSL_S_Read    : out std_logic;
    FSL_S_Data    : in  std_logic_vector(0 to C_FSL_DWIDTH-1);
    FSL_S_Control : in  std_logic;
    FSL_S_Exists  : in  std_logic;

	-- Read Sound FSL signals
    FSL_M_Clk     : out std_logic;
    FSL_M_Write   : out std_logic;
    FSL_M_Data    : out std_logic_vector(0 to C_FSL_DWIDTH-1);
    FSL_M_Control : out std_logic;
    FSL_M_Full    : in  std_logic;

    --Interrupt Signals
    Playback_Interrupt  : out std_logic;
    Record_Interrupt    : out std_logic;
    Status_Interrupt    : out std_logic

    );

end entity OPB_AC97_CONTROLLER;

architecture IMP of OPB_AC97_CONTROLLER is

  component opb_ac97_core is
    generic (
      C_PLAYBACK : integer := 1;
      C_RECORD   : integer := 0
      );
    port (
      -- signals belonging to Clk clock region
      Clk   : in std_logic;
      Reset : in std_logic;

      AC97_Reg_Addr         : in  std_logic_vector(0 to 6);
      AC97_Reg_Read         : in  std_logic;
      AC97_Reg_Write_Data   : in  std_logic_vector(0 to 15);
      AC97_Reg_Read_Data    : out std_logic_vector(0 to 15);
      AC97_Reg_Access       : in  std_logic;
      AC97_Got_Request      : out std_logic;
      AC97_Reg_Finished     : out std_logic;
      AC97_Request_Finished : in  std_logic;
      CODEC_RDY             : out std_logic;

      In_Data_FIFO   : in  std_logic_vector(0 to 15);
      In_Data_Exists : in  std_logic;
      in_FIFO_Read   : out std_logic;

      Out_Data_FIFO  : out std_logic_vector(0 to 15);
      Out_FIFO_Full  : in  std_logic;
      Out_FIFO_Write : out std_logic;

      -- signals belonging to Bit_Clk clock region
      Bit_Clk   : in  std_logic;
      Sync      : out std_logic;
      SData_Out : out std_logic;
      SData_In  : in  std_logic

   );
  end component opb_ac97_core;

  component SRL_FIFO is
    generic (
      C_DATA_BITS : integer;
      C_DEPTH     : integer);
    port (
      Clk         : in  std_logic;
      Reset       : in  std_logic;
      Clear_FIFO  : in  std_logic;
      FIFO_Write  : in  std_logic;
      Data_In     : in  std_logic_vector(0 to C_DATA_BITS-1);
      FIFO_Read   : in  std_logic;
      Data_Out    : out std_logic_vector(0 to C_DATA_BITS-1);
      FIFO_Full   : out std_logic;
      Data_Exists : out std_logic;
      Half_Full   : out std_logic;
      Half_Empty  : out std_logic
      );
  end component SRL_FIFO;

  component pselect is
    generic (
      C_AB  : integer;
      C_AW  : integer;
      C_BAR : std_logic_vector);
    port (
      A      : in  std_logic_vector(0 to C_AW-1);
      AValid : in  std_logic;
      CS     : out std_logic);
  end component pselect;

  component FDRE is
    port (
      Q  : out std_logic;
      C  : in  std_logic;
      CE : in  std_logic;
      D  : in  std_logic;
      R  : in  std_logic);
  end component FDRE;

  component FDSE is
    port (
      Q  : out std_logic;
      C  : in  std_logic;
      CE : in  std_logic;
      D  : in  std_logic;
      S  : in  std_logic);
  end component FDSE;

  component FDR is
    port (Q : out std_logic;
          C : in  std_logic;
          D : in  std_logic;
          R : in  std_logic);
  end component FDR;

  component FDCE is
    port (
      Q   : out std_logic;
      C   : in  std_logic;
      CE  : in  std_logic;
      D   : in  std_logic;
      CLR : in  std_logic);
  end component FDCE;


  function Addr_Bits (x, y : std_logic_vector(0 to C_OPB_AWIDTH-1)) return integer is
    variable addr_nor : std_logic_vector(0 to C_OPB_AWIDTH-1);
  begin
    addr_nor := x xor y;
    for i in 0 to C_OPB_AWIDTH-1 loop
      if addr_nor(i) = '1' then return i;
      end if;
    end loop;
    return(C_OPB_AWIDTH);
  end function Addr_Bits;

  constant C_AB : integer := Addr_Bits(C_HIGHADDR, C_BASEADDR);


  function Func_Active (x, y : integer) return integer is
  begin
    if (X = 1 or Y = 1) then
     return 1;
    else
     return 0;
    end if;
  end function Func_Active;

  constant C_PLAYBACK : integer := Func_Active(C_PLAYBACK_OPB, C_PLAYBACK_FSL);
  constant C_RECORD : integer := Func_Active(C_RECORD_OPB, C_RECORD_FSL);

  subtype  ADDR_CHK is natural range C_OPB_AWIDTH-5 to C_OPB_AWIDTH-3;
  constant IN_FIFO_ADR     : std_logic_vector(0 to 2) := "000";
  constant OUT_FIFO_ADR    : std_logic_vector(0 to 2) := "001";
  constant FIFO_STATUS_ADR : std_logic_vector(0 to 2) := "010";
  constant INTR_CTRL_ADR   : std_logic_vector(0 to 2) := "011";
  constant AC97_CTRL_ADR   : std_logic_vector(0 to 2) := "100";
  constant AC97_READ_ADR   : std_logic_vector(0 to 2) := "101";
  constant AC97_WRITE_ADR  : std_logic_vector(0 to 2) := "110";
  constant FIFO_CTRL_ADR   : std_logic_vector(0 to 2) := "111";

  signal opb_ac97_controller_CS : std_logic;

  signal opb_ac97_controller_CS_1 : std_logic;  -- Active as long as OPB_AC97_CONTROLLER_CS is active
  signal opb_ac97_controller_CS_2 : std_logic;  -- Active only 1 clock cycle during an
  signal opb_ac97_controller_CS_3 : std_logic;  -- Active only 1 clock cycle during an
                                                -- access

  signal xfer_Ack  : std_logic;
  signal opb_RNW_1 : std_logic;

  signal OPB_AC97_CONTROLLER_Dbus_i : std_logic_vector(0 to 15);

  
  -- Read Only
  signal status_Reg : std_logic_vector(7 downto 0);
  -- bit 7 '1' if out_FIFO hade a overrun condition (record)
  -- bit 6 '1' if in_FIFO hade a underrun condition (playback)
  -- bit 5 If the CODEC is ready for commands
  -- bit 4 Register Access is finished and if it was a read the data
  --       is in AC97_Reg_Read register, reading AC97_Reg_Read_Register will clear
  --       this bit
  -- bit 3 out_FIFO_Data_Present
  -- bit 2 out_FIFO_Empty
  -- bit 1 in_FIFO_Empty, OPB Record Only
  -- bit 0 not in_FIFO_Full, OPB Record only

  signal Ctrl_Reg : std_logic_vector(3 downto 0);
  -- bit 3 Clear Record FIFO
  -- bit 2 Clear Playback FIFO
  -- bit 1 Record Enable
  -- bit 0 Playback Enable

  signal ac97_Reg_Addr       : std_logic_vector(0 to 6);
  signal ac97_Reg_Read       : std_logic;
  signal ac97_Reg_Write_Data : std_logic_vector(0 to 15);
  signal ac97_Reg_Read_Data  : std_logic_vector(0 to 15);
  signal ac97_Reg_Access     : std_logic;
  signal ac97_Got_Request    : std_logic;
  signal ac97_reg_access_S   : std_logic;
  signal ac97_Reg_Finished   : std_logic;
  signal ac97_Reg_Finished_i : std_logic;

  signal register_Access_Finished     : std_logic;
  signal register_Access_Finished_Set : std_logic;

  signal codec_rdy : std_logic;

  -- AC97 Input/Output FIFO Signals
  signal In_FIFO_Read       : std_logic;
  signal In_Data_FIFO       : std_logic_vector(0 to 15);
  signal In_Data_Exists     : std_logic;
  signal Out_Data_FIFO      : std_logic_vector(0 to 15);
  signal Out_FIFO_Full      : std_logic;
  signal Out_FIFO_Write     : std_logic;

  -- Miscellaneous FIFO signals
  signal in_FIFO_Read_gated : std_logic;
  signal In_Data_Exists_I   : std_logic;
  signal In_FIFO_Underrun   : std_logic;
  signal Out_Fifo_Full_I    : std_logic;
  signal Out_FIFO_Overrun   : std_logic;
  signal Out_FIFO_Write_I   : std_logic;

  -- Signals for OPB Playback only
  signal In_Fifo_Write      : std_logic;
  signal Clear_In_Fifo      : std_logic;
  signal In_Fifo_Full       : std_logic;
  signal In_Fifo_Half_Full  : std_logic;
  signal In_Fifo_Half_Empty : std_logic;

  -- Signals for OPB Record only
  signal Clear_Out_Fifo      : std_logic;
  signal Out_FIFO_Read       : std_logic;
  signal Out_Data_Exists     : std_logic;
  signal Out_FIFO_Half_Full  : std_logic;
  signal Out_FIFO_Half_Empty : std_logic;
  signal Out_Data_Read       : std_logic_vector(0 to 15);

  signal Record_En        : std_logic;
  signal Playback_En      : std_logic;

  -- Interrupt control signals
  signal Intr_Ctrl_Reg    : std_logic_vector(2 downto 0);
  signal Status_Intr_En   : std_logic;
  signal Rec_Intr_En      : std_logic;
  signal Play_Intr_En     : std_logic;

 signal Playback_Interrupt_I   : std_logic;
 signal Record_Interrupt_I     : std_logic;
 signal Status_Interrupt_I     : std_logic;

begin  -- architecture IMP
 
  -----------------------------------------------------------------------------
  -- Handling the OPB bus interface
  -----------------------------------------------------------------------------

  -- Do the OPB address decoding
  pselect_I : pselect
    generic map (
      C_AB  => C_AB,                    -- [integer]
      C_AW  => C_OPB_AWIDTH,            -- [integer]
      C_BAR => C_BASEADDR)              -- [std_logic_vector]
    port map (
      A      => OPB_ABus,               -- [in  std_logic_vector(0 to C_AW-1)]
      AValid => OPB_select,             -- [in  std_logic]
      CS     => opb_ac97_controller_CS);  -- [out std_logic]

  OPB_AC97_CONTROLLER_errAck  <= '0';
  OPB_AC97_CONTROLLER_retry   <= '0';
  OPB_AC97_CONTROLLER_toutSup <= '0';

  -----------------------------------------------------------------------------
  -- Decoding the OPB control signals
  -----------------------------------------------------------------------------
  opb_ac97_controller_CS_1_DFF : FDR
    port map (
      Q => opb_ac97_controller_CS_1,    -- [out std_logic]
      C => OPB_Clk,                     -- [in  std_logic]
      D => OPB_AC97_CONTROLLER_CS,      -- [in  std_logic]
      R => xfer_Ack);                   -- [in std_logic]

  opb_ac97_controller_CS_2_DFF : process (OPB_Clk, OPB_Rst) is
  begin  -- process opb_ac97_controller_CS_2_DFF
    if OPB_Rst = '1' then               -- asynchronous reset (active high)
      opb_ac97_controller_CS_2 <= '0';
      opb_ac97_controller_CS_3 <= '0';
      opb_RNW_1                <= '0';
    elsif OPB_Clk'event and OPB_Clk = '1' then  -- rising clock edge
      opb_ac97_controller_CS_2 <= opb_ac97_controller_CS_1
                                  and not opb_ac97_controller_CS_2
                                  and not opb_ac97_controller_CS_3;
      opb_ac97_controller_CS_3 <= opb_ac97_controller_CS_2;
      opb_RNW_1                <= OPB_RNW;
    end if;
  end process opb_ac97_controller_CS_2_DFF;

  -- OPB Write Data
  Write_Mux : process (status_reg, OPB_ABus, ac97_Reg_Read_Data, Ctrl_Reg, Out_Data_Read) is
  begin  -- process Read_Mux
    OPB_AC97_CONTROLLER_Dbus_i <= (others => '0');
    if (OPB_ABus(ADDR_CHK) = FIFO_STATUS_ADR) then
      OPB_AC97_CONTROLLER_Dbus_i(15-status_reg'length+1 to 15) <= status_reg;
    elsif (OPB_ABus(ADDR_CHK) = AC97_READ_ADR) then
      OPB_AC97_CONTROLLER_Dbus_i(0 to 15) <= ac97_Reg_Read_Data;
    elsif (OPB_ABus(ADDR_CHK) = FIFO_CTRL_ADR) then
      OPB_AC97_CONTROLLER_Dbus_i(15-Ctrl_Reg'length+1 to 15) <= Ctrl_Reg;
    elsif (OPB_ABus(ADDR_CHK) = INTR_CTRL_ADR) then
      OPB_AC97_CONTROLLER_Dbus_i(15-Intr_Ctrl_Reg'length+1 to 15) <= Intr_Ctrl_Reg;
    elsif (OPB_ABus(ADDR_CHK) = OUT_FIFO_ADR) then
      OPB_AC97_CONTROLLER_Dbus_i(0 to 15) <= Out_Data_Read;
    end if;
  end process Write_Mux;

  DWIDTH_gt_16 : if (C_OPB_DWIDTH > 16) generate
    OPB_AC97_CONTROLLER_Dbus(0 to C_OPB_DWIDTH-17) <= (others => '0');
  end generate DWIDTH_gt_16;

  OPB_rdDBus_DFF : for I in C_OPB_DWIDTH-16 to C_OPB_DWIDTH-1 generate
    OPB_rdBus_FDRE : FDRE
      port map (
        Q  => OPB_AC97_CONTROLLER_DBus(I),  -- [out std_logic]
        C  => OPB_Clk,                  -- [in  std_logic]
        CE => opb_ac97_controller_CS_2,     -- [in  std_logic]
        D  => OPB_AC97_CONTROLLER_Dbus_i(I-(C_OPB_DWIDTH-16)),  -- [in  std_logic]
        R  => xfer_Ack);                -- [in std_logic]
  end generate OPB_rdDBus_DFF;

  XFER_Control : process (OPB_Clk, OPB_Rst) is
  begin  -- process XFER_Control
    if OPB_Rst = '1' then               -- asynchronous reset (active high)
      xfer_Ack <= '0';
    elsif OPB_Clk'event and OPB_Clk = '1' then  -- rising clock edge
      xfer_Ack <= opb_ac97_controller_CS_2;
    end if;
  end process XFER_Control;

  OPB_AC97_CONTROLLER_xferAck <= xfer_Ack;

  -----------------------------------------------------------------------------
  -- Status register
  -----------------------------------------------------------------------------
  status_reg(7) <= Out_FIFO_Overrun;
  status_reg(6) <= In_FIFO_Underrun;
  status_reg(5) <= codec_rdy;
  status_reg(4) <= register_Access_Finished;
  status_reg(3) <= Out_Data_Exists;
  status_reg(2) <= not(Out_FIFO_Full);
  status_reg(1) <= not(in_Data_Exists);
  status_reg(0) <= not(In_Fifo_Full);

  -----------------------------------------------------------------------------
  -- Control register
  -----------------------------------------------------------------------------
  Ctrl_Reg(3) <= Clear_In_FIFO;
  Ctrl_Reg(2) <= Clear_Out_FIFO;
  Ctrl_Reg(1) <= Record_En;
  Ctrl_Reg(0) <= Playback_En;

  -----------------------------------------------------------------------------
  -- AC97 Register Handling
  -----------------------------------------------------------------------------
  AC97_Write_Reg_Data : process (OPB_Clk, OPB_Rst) is
  begin  -- process AC97_Write_Reg_Data
    if OPB_Rst = '1' then               -- asynchronous reset (active high)
      ac97_reg_write_data <= (others => '0');
    elsif OPB_Clk'event and OPB_Clk = '1' then  -- rising clock edge
      if (opb_ac97_controller_CS_2 = '1') and (OPB_RNW_1 = '0') and (OPB_ABus(ADDR_CHK) = AC97_WRITE_ADR) then
        ac97_reg_write_data <= OPB_DBus(C_OPB_DWIDTH-16 to C_OPB_DWIDTH-1);
      end if;
    end if;
  end process AC97_Write_Reg_Data;

  AC97_Access_Reg : process (OPB_Clk, OPB_Rst) is
  begin  -- process AC97_Access_Reg
    if OPB_Rst = '1' then               -- asynchronous reset (active high)
      ac97_reg_addr     <= (others => '0');
      ac97_reg_read     <= '0';
      ac97_reg_access_S <= '0';
    elsif OPB_Clk'event and OPB_Clk = '1' then  -- rising clock edge
      ac97_reg_access_S <= '0';
      if (opb_ac97_controller_CS_2 = '1') and (OPB_RNW_1 = '0') and (OPB_ABus(ADDR_CHK) = AC97_CTRL_ADR) then
        ac97_reg_addr     <= OPB_DBus(C_OPB_DWIDTH-7 to C_OPB_DWIDTH-1);
        ac97_reg_read     <= OPB_DBus(C_OPB_DWIDTH-8);
        ac97_reg_access_S <= '1';
      end if;
    end if;
  end process AC97_Access_Reg;

  ac97_reg_access_FDCE : FDCE
    port map (
      Q   => ac97_reg_access,           -- [out std_logic]
      C   => OPB_Clk,                   -- [in  std_logic]
      CE  => ac97_reg_access_S,         -- [in  std_logic]
      D   => '1',                       -- [in  std_logic]
      CLR => ac97_Got_Request);         -- [in std_logic]

  ac97_reg_access_FDSE : FDSE
    port map (
      Q  => register_Access_Finished,       -- [out std_logic]
      C  => OPB_Clk,                        -- [in  std_logic]
      CE => ac97_reg_access_S,              -- [in  std_logic]
      D  => '0',                            -- [in  std_logic]
      S  => register_Access_Finished_Set);  -- [in std_logic]

  AC97_Register_SM : process (OPB_Clk, OPB_Rst) is
  begin  -- process AC97_Register_SM
    if OPB_Rst = '1' then               -- asynchronous reset (active high)
      ac97_Reg_Finished_i          <= '0';
      register_Access_Finished_Set <= '0';
    elsif OPB_Clk'event and OPB_Clk = '1' then  -- rising clock edge
      register_Access_Finished_Set <= '0'; 
      if (ac97_Reg_Finished = '1' and ac97_Reg_Finished_i = '0') then
        register_Access_Finished_Set <= '1';
      end if;
      ac97_Reg_Finished_i <= ac97_Reg_Finished;
    end if;
  end process AC97_Register_SM;

  -----------------------------------------------------------------------------
  -- FIFO Enable Signals
  -----------------------------------------------------------------------------
  InOut_Fifo_Enable : process (OPB_Clk, OPB_Rst) is
  begin
    if OPB_Rst = '1' then
      Playback_En <= '0';
	 Record_En <= '0';
    elsif OPB_Clk'event and OPB_Clk = '1' then
      if ((opb_ac97_controller_CS_2 = '1') and (OPB_RNW_1 = '0') and (OPB_ABus(ADDR_CHK) = FIFO_CTRL_ADR)) then
	   Playback_En <= OPB_DBus(C_OPB_DWIDTH-1);
	   Record_En <= OPB_DBus(C_OPB_DWIDTH-2);
      end if;
    end if;
  end process InOut_Fifo_Enable;

  -----------------------------------------------------------------------------
  -- FIFO Overrun/Underrun Signals
  -----------------------------------------------------------------------------
  FIFO_OverUnderRun : process (OPB_Clk, OPB_Rst) is
  begin
    if (OPB_Rst = '1') then
      Out_FIFO_Overrun <= '0';
	 In_FIFO_Underrun <= '0';
    elsif (OPB_Clk'event and OPB_Clk = '1') then
      if In_FIFO_Read = '1' then
	   In_FIFO_Underrun <= not In_Data_Exists;
      end if;
      if (Out_FIFO_Write_I = '1') then
	   Out_FIFO_Overrun <= Out_FIFO_Full;
      end if;
    end if;
  end process FIFO_OverUnderRun;  

  -----------------------------------------------------------------------------
  -- Instanciating the Input FIFOs and associate components
  -----------------------------------------------------------------------------

  In_FIFO_Read_Gated <= In_FIFO_Read and In_Data_Exists;
  In_Data_Exists <= In_Data_Exists_I  and Playback_En; 

  Using_OPB_Playback : if (C_PLAYBACK_OPB = 1) generate
    In_FIFO_Write <= opb_ac97_controller_CS_2 and (not OPB_RNW_1) when (OPB_ABus(ADDR_CHK) = IN_FIFO_ADR)  else '0';
    Clear_In_Fifo <= OPB_DBus(C_OPB_DWIDTH-3) and opb_ac97_controller_CS_2 and (not OPB_RNW_1) when (OPB_ABus(ADDR_CHK) = FIFO_CTRL_ADR)  else '0';

   IN_FIFO : SRL_FIFO
     generic map (
       C_DATA_BITS => 16,              -- [integer]
       C_DEPTH     => 16)              -- [integer]
     port map (
       Clk         => OPB_Clk,         -- [in  std_logic]
       Reset       => OPB_Rst,         -- [in  std_logic]
       Clear_FIFO  => Clear_In_Fifo,  -- [in  std_logic]
       FIFO_Write  => In_FIFO_Write,   -- [in  std_logic]
       Data_In     => OPB_DBus(C_OPB_DWIDTH-16 to C_OPB_DWIDTH-1),  -- [in  std_logic_vector(0 to C_OPB_DWIDTH-1)]
       FIFO_Read   => in_FIFO_Read_gated,    -- [in  std_logic]
       Data_Out    => in_Data_FIFO,  -- [out std_logic_vector(0 to C_OPB_DWIDTH-1)]
       FIFO_Full   => in_FIFO_Full,    -- [out std_logic]
       Data_Exists => in_Data_Exists_I,  -- [out std_logic]
       Half_Full   => in_FIFO_Half_Full,    -- [out std_logic]
       Half_Empty  => in_FIFO_Half_Empty);  -- [out std_logic]
  end generate Using_OPB_Playback;   
 
  Using_FSL_Playback : if (C_PLAYBACK_OPB = 0 and C_PLAYBACK_FSL = 1) generate
    In_Data_Exists_I <= FSL_S_Exists;
    In_Data_FIFO <= FSL_S_Data(C_FSL_DWIDTH - 16 to C_FSL_DWIDTH - 1);
    FSL_S_Read <= In_FIFO_Read_Gated;
  end generate Using_FSL_Playback;
     
  No_Playback : if (C_PLAYBACK_OPB = 0 and C_PLAYBACK_FSL = 0) generate
    In_Data_Exists_I <= '0';
    In_Data_FIFO <= (others=>'0');
  end generate No_Playback;

  -----------------------------------------------------------------------------
  -- Instanciating the Output FIFOs and associate components
  -----------------------------------------------------------------------------
  Out_FIFO_Write_I <= Out_FIFO_Write and Record_En;

  Using_OPB_Record : if (C_RECORD_OPB = 1) generate
    Clear_Out_Fifo <= OPB_DBus(C_OPB_DWIDTH-4) and opb_ac97_controller_CS_2 and (not OPB_RNW_1) when (OPB_ABus(ADDR_CHK) = FIFO_CTRL_ADR)  else '0';
    Out_FIFO_Read <= opb_ac97_controller_CS_2 and OPB_RNW_1 when (OPB_ABus(ADDR_CHK) = OUT_FIFO_ADR) else '0';

    OUT_FIFO : SRL_FIFO
      generic map (
        C_DATA_BITS => 16,              -- [integer]
        C_DEPTH     => 16)              -- [integer]
      port map (
        Clk         => OPB_Clk,         -- [in  std_logic]
        Reset       => OPB_Rst,         -- [in  std_logic]
        Clear_FIFO  => Clear_Out_Fifo,  -- [in  std_logic]
        FIFO_Write  => out_FIFO_Write_I,  -- [in  std_logic]
        Data_In     => out_Data_FIFO,  -- [in  std_logic_vector(0 to C_OPB_DWIDTH-1)]
        FIFO_Read   => out_FIFO_Read,   -- [in  std_logic]
        Data_Out    => out_Data_Read,  -- [out std_logic_vector(0 to C_OPB_DWIDTH-1)]
        FIFO_Full   => out_FIFO_Full,   -- [out std_logic]
        Data_Exists => out_Data_Exists,       -- [out std_logic]
        Half_Full   => out_FIFO_Half_Full,    -- [out std_logic]
        Half_Empty  => out_FIFO_Half_Empty);  -- [out std_logic]
  end generate Using_OPB_Record;   
 
  Using_FSL_Record : if (C_RECORD_OPB = 0 and C_RECORD_FSL = 1) generate
    FSL_M_Data(C_FSL_DWIDTH-16 to C_FSL_DWIDTH-1) <= Out_Data_FIFO;
    FSL_M_Write <= Out_FIFO_Write_I;
    Out_FIFO_Full <= FSL_M_Full;
  end generate Using_FSL_Record;
     
  No_Record : if (C_RECORD_OPB = 0 and C_RECORD_FSL = 0) generate
    Out_FIFO_Full <= '0';
  end generate No_Record;

  -----------------------------------------------------------------------------
  -- Instanciating the OPB_AC97_CONTROLLER core
  -----------------------------------------------------------------------------
  opb_ac97_core_I : opb_ac97_core
    generic map (
      C_PLAYBACK => C_PLAYBACK,
      C_RECORD   => C_RECORD
      )
    port map (
      -- signals belonging to Clk clock region
      Clk   => OPB_Clk,                 -- [in  std_logic]
      Reset => OPB_Rst,                 -- [in  std_logic]

      AC97_Reg_Addr         => ac97_Reg_Addr,  -- [in  std_logic_vector(0 to 6)]
      AC97_Reg_Read         => ac97_Reg_Read,  -- [in  std_logic]
      AC97_Reg_Write_Data   => ac97_Reg_Write_Data,  -- [in  std_logic_vector(0 to 15)]
      AC97_Reg_Read_Data    => ac97_Reg_Read_Data,  -- [out std_logic_vector(0 to 15)]
      AC97_Reg_Access       => ac97_Reg_Access,     -- [in  std_logic]
      AC97_Got_Request      => ac97_Got_Request,    -- [out  std_logic]
      AC97_Reg_Finished     => ac97_Reg_Finished,   -- [out std_logic]
      AC97_Request_Finished => register_Access_Finished,  -- [in std_logic]
      CODEC_RDY             => codec_rdy,      -- [out std_logic]

      In_Data_FIFO   => In_Data_FIFO,    -- [in  std_logic_vector(0 to 15)]
      In_Data_Exists => In_Data_Exists,  -- [in  std_logic]
      in_FIFO_Read   => In_FIFO_Read,    -- [out std_logic]

      Out_Data_FIFO  => Out_Data_FIFO,   -- [out std_logic_vector(0 to 15)]
      Out_FIFO_Full  => Out_FIFO_Full,   -- [in  std_logic]
      Out_FIFO_Write => Out_FIFO_Write,  -- [out std_logic]

      -- signals belonging to Bit_Clk clock region
      Bit_Clk   => Bit_Clk,             -- [in  std_logic]
      Sync      => Sync,
      SData_Out => SData_out,
      SData_In => SData_In
	  );           

  -----------------------------------------------------------------------------
  -- Interrupt Control Registers
  -----------------------------------------------------------------------------
  Intr_Ctrl_Reg(2) <= Status_Intr_En;
  Intr_Ctrl_Reg(1) <= Rec_Intr_En;
  Intr_Ctrl_Reg(0) <= Play_Intr_En;

  Interrupt_Enable : process(OPB_Rst, OPB_Clk)
  begin
    if OPB_Rst = '1' then
      Status_Intr_En <= '0';
	 Rec_Intr_En <= '0';
	 Play_Intr_En <= '0';
    elsif OPB_Clk'event and OPB_Clk = '1' then
      if ((opb_ac97_controller_CS_2 = '1') and (OPB_RNW_1 = '0') and (OPB_ABus(ADDR_CHK) = INTR_CTRL_ADR)) then
	   Play_Intr_En <= OPB_DBus(C_OPB_DWIDTH-1);
	   Rec_Intr_En <= OPB_DBus(C_OPB_DWIDTH-2);
	   Status_Intr_En <= OPB_DBus(C_OPB_DWIDTH-3);
      end if;
    end if;
  end process Interrupt_Enable;
 
  -----------------------------------------------------------------------------
  -- Handling the interrupts
  -----------------------------------------------------------------------------
  Playback_Interrupt_Handle : process (In_FIFO_Half_Full, In_FIFO_Half_Empty, In_FIFO_Full, 
      In_Data_Exists, Play_Intr_En) is
  begin
    if (C_PLAY_INTR_LEVEL = 1) then
      Playback_Interrupt_I <=  Play_Intr_En and not(In_Data_Exists);
    elsif (C_PLAY_INTR_LEVEL = 2) then
      Playback_Interrupt_I <=  Play_Intr_En and not(in_FIFO_Half_Empty);
    elsif (C_PLAY_INTR_LEVEL = 3) then
      Playback_Interrupt_I <=  Play_Intr_En and not(in_FIFO_Half_Full);
    elsif (C_PLAY_INTR_LEVEL = 4) then
      Playback_Interrupt_I <=  Play_Intr_En and not(in_FIFO_Full);
    else
      Playback_Interrupt_I <= '0';
    end if;
  end process Playback_Interrupt_Handle;

  Record_Interrupt_Handle: process (out_FIFO_Half_Full, out_FIFO_Half_Empty, out_FIFO_Full, 
     Out_Data_Exists, Rec_Intr_En) is
  begin  -- process Record_Interrupt_Handle
    if (C_REC_INTR_LEVEL = 1) then
      Record_Interrupt_I <=  Rec_Intr_En and Out_Data_Exists;
    elsif (C_REC_INTR_LEVEL = 2) then
      Record_Interrupt_I <=  Rec_Intr_En and out_FIFO_Half_Empty;
    elsif (C_REC_INTR_LEVEL = 3) then
      Record_Interrupt_I <=  Rec_Intr_En and out_FIFO_Half_Full;
    elsif (C_REC_INTR_LEVEL = 4) then
      Record_Interrupt_I <=  Rec_Intr_En and out_FIFO_Full;
    else
      Record_Interrupt_I <= '0';
    end if;
  end process Record_Interrupt_Handle;

  Status_Interrupt_Handle: process (register_Access_Finished, Status_Intr_En)
  begin
    if (C_STATUS_INTR = 1) then
      Status_Interrupt_I <= register_Access_Finished and Status_Intr_En;
    else
      Status_Interrupt_I <= '0';
    end if;
  end process Status_Interrupt_Handle;

  Using_High_Interrupt : if (C_INTR_IS_HIGH = 1) generate
    Status_Interrupt <= Status_Interrupt_I;
    Record_Interrupt <= Record_Interrupt_I;
    Playback_Interrupt <= Playback_Interrupt_I;
  end generate Using_High_Interrupt;

  Using_Low_Interrupt : if (C_INTR_IS_HIGH = 0) generate
    Status_Interrupt <= not(Status_Interrupt_I);
    Record_Interrupt <= not(Record_Interrupt_I);
    Playback_Interrupt <= not(Playback_Interrupt_I);
  end generate Using_Low_Interrupt;

end architecture IMP;



