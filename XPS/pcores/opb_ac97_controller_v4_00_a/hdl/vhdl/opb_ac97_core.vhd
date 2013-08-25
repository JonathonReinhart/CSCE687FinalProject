-------------------------------------------------------------------------------
-- $Id: opb_ac97_core.vhd,v 1.1 2003/07/01 10:42:08 patoh Exp $
-------------------------------------------------------------------------------
-- opb_ac97_core.vhd
-------------------------------------------------------------------------------
--
--                  ****************************
--                  ** Copyright Xilinx, Inc. **
--                  ** All rights reserved.   **
--                  ****************************
--
-------------------------------------------------------------------------------
-- Filename:        opb_ac97_core.vhd
--
-- Description:     
--                  
-- VHDL-Standard:   VHDL'93
-------------------------------------------------------------------------------
-- Structure:   
--              opb_ac97_core.vhd
--
-------------------------------------------------------------------------------
-- Author:          goran
-- Revision:        $Revision: 1.1 $
-- Date:            $Date: 2003/07/01 10:42:08 $
--
-- History:
--   goran  2002-01-24    First Version
--   Caleb  2004-03-31    Version 3.00e
--                        * fixed record and status readback function
--                          * delayed data_in grabbing by one clock cycle
--                          * increased slot_no range to 5
--   Caleb  2004-04-06    Version 4.00a
--                        * removed chipscope test signals
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

entity opb_ac97_core is
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

end entity opb_ac97_core;

library unisim;
use unisim.all;

architecture IMP of opb_ac97_core is

  component SRL16E is
    -- pragma translate_off
    generic (
      INIT : bit_vector := X"0000"
      );
    -- pragma translate_on    
    port (
      CE  : in  std_logic;
      D   : in  std_logic;
      Clk : in  std_logic;
      A0  : in  std_logic;
      A1  : in  std_logic;
      A2  : in  std_logic;
      A3  : in  std_logic;
      Q   : out std_logic);
  end component SRL16E;

  component FDRSE is
    port (
      Q  : out std_logic;
      C  : in  std_logic;
      CE : in  std_logic;
      D  : in  std_logic;
      S  : in  std_logic;
      R  : in  std_logic);
  end component FDRSE;

  component FDCE is
    port (
      Q   : out std_logic;
      C   : in  std_logic;
      CE  : in  std_logic;
      D   : in  std_logic;
      CLR : in  std_logic);
  end component FDCE;

  component FD is
    -- pragma translate_off
    generic (
      INIT : bit := '0'
      );
    -- pragma translate_on        
    port (
      Q : out std_logic;
      C : in  std_logic;
      D : in  std_logic
      );
  end component FD;

  signal rst_n    : std_logic;
  signal sync_i : std_logic;

  signal start_from_reset : std_logic;
  signal start_sync       : std_logic;
  signal start_sync_clean : std_logic;
  signal reset_sync       : std_logic;

  signal new_slot    : std_logic;
  signal con_slot    : std_logic;
  signal slot_end    : std_logic;
  signal slot_end_1  : std_logic;
  signal delay_4     : std_logic;
  signal last_slot   : std_logic;

  signal new_data_out : std_logic_vector(19 downto 0);
  signal data_out     : std_logic_vector(19 downto 0);
  signal data_in      : std_logic_vector(19 downto 0);

  signal data_valid    : std_logic;
  signal got_read_data : std_logic;
  signal got_request   : std_logic;

  signal read_fifo   : std_logic;
  signal read_fifo_1 : std_logic;
  
  signal slot0 : std_logic_vector(15 downto 0);
  signal slot1 : std_logic_vector(19 downto 0);
  signal slot2 : std_logic_vector(19 downto 0);

  signal valid_Frame           : std_logic;
  signal valid_Control_Addr    : std_logic;
  signal valid_Control_Data    : std_logic;
  signal valid_Playback_Data_L : std_logic;
  signal valid_Playback_Data_R : std_logic;

  signal got_record_data : std_logic;
  
  signal valid_Record_Data_L : std_logic;
  signal valid_Record_Data_R : std_logic;
  signal fifo_written        : std_logic;
  signal write_fifo          : std_logic;

  signal slot_No : natural range 0 to 5;
  signal slot_No_1 : natural range 0 to 5;

  signal Bit_Index : integer;

  signal ac97_Reg_Access_1 : std_logic;
  signal ac97_Reg_Access_2 : std_logic;

  signal ac97_read_access  : std_logic;
  signal ac97_write_access : std_logic;

  signal ac97_Reg_Finished_i   : std_logic;
 
  signal In_Data_FIFO_i : std_logic_vector(0 to 15);

 
begin  -- architecture IMP

--  In_Data_FIFO_i <= (others => '0') when In_Data_Exists = '0' else In_Data_FIFO;
  In_Data_FIFO_i <= In_Data_FIFO;

  -----------------------------------------------------------------------------
  -- Temporary signals for debugging in VHDL Simulator
  -----------------------------------------------------------------------------
    -- pragma translate_off
  Dbg : process (Bit_Clk) is
    variable tmp  : std_logic;
    variable tmp2 : std_logic;
  begin  -- process Dbg
    if Reset = '1' then                 -- asynchronous reset (active high)
      Bit_Index <= 15;
      tmp       := '0';
      tmp2      := '0';
    elsif Bit_Clk'event and Bit_Clk = '1' then  -- rising clock edge
      if (tmp = '1') then
        Bit_Index <= 15;
      elsif (tmp2 = '1') then
        Bit_Index <= 19;
      else
        Bit_Index <= Bit_Index - 1;
      end if;
      tmp  := start_sync;
      tmp2 := slot_end;
    end if;
  end process Dbg;
    -- pragma translate_on

  rst_n <= not reset;

  -----------------------------------------------------------------------------
  -- Handle AC97 register accesses
  -----------------------------------------------------------------------------
  Reg_Access_Handle : process (Bit_Clk) is
  begin  -- process Reg_Access_Handle
    if Bit_Clk'event and Bit_Clk = '1' then  -- rising clock edge
      ac97_Reg_Access_1 <= AC97_Reg_Access;
      ac97_Reg_Access_2 <= ac97_Reg_Access_1;
      -- detect a rising edge on AC97_Reg_Access
      if (ac97_Reg_Access_1 = '1' and ac97_Reg_Access_2 = '0') then
        valid_Control_Addr <= '1';
        valid_Control_Data <= not AC97_Reg_Read;  -- '1' on writes
        AC97_Got_Request   <= '1';
      elsif (valid_Control_Addr and got_request) = '1' then
        valid_Control_Addr <= '0';
        valid_Control_Data <= '0';
        AC97_Got_Request   <= '0';
      end if;
    end if;
  end process Reg_Access_Handle;

  -----------------------------------------------------------------------------
  -- Setup slot0 at start of frame
  -----------------------------------------------------------------------------
  Setup_Slot0 : process (Bit_Clk) is
  begin  -- process Setup_Slot0
    if Bit_Clk'event and Bit_Clk = '1' then  -- rising clock edge
      if (delay_4 and last_slot) = '1' then
        slot0(15)         <= valid_Frame;
        slot0(14)         <= valid_Control_Addr;
        slot0(13)         <= valid_Control_Data;
        slot0(12)         <= valid_Playback_Data_L;
        slot0(11)         <= valid_Playback_Data_R;
        got_request       <= valid_Control_Addr;
        ac97_read_access  <= slot0(14) and not slot0(13);
        ac97_write_access <= slot0(14) and slot0(13);
      end if;
    end if;
  end process Setup_Slot0;

  valid_Frame <= valid_Control_Addr or valid_Playback_Data_L or valid_Playback_Data_R;

  slot1(19)           <= AC97_Reg_Read;
  slot1(18 downto 12) <= AC97_Reg_Addr;
  slot1(11 downto 0) <= (others => '0');

  slot2(19 downto 4) <= AC97_Reg_Write_Data;
  slot2( 3 downto 0) <= (others => '0');

  -----------------------------------------------------------------------------
  -- Generating the Sync signal
  -----------------------------------------------------------------------------
  Sync_SRL16E : SRL16E
    -- pragma translate_off
    generic map (
      INIT => X"0000")                  -- [bit_vector]
    -- pragma translate_on
    port map (
      CE  => '1',                       -- [in  std_logic]
      D   => start_Sync,                -- [in  std_logic]
      Clk => Bit_Clk,                   -- [in  std_logic]
      A0  => '1',                       -- [in  std_logic]
      A1  => '1',                       -- [in  std_logic]
      A2  => '1',                       -- [in  std_logic]
      A3  => '1',                       -- [in  std_logic]
      Q   => reset_Sync);               -- [out std_logic]

  Sync_FDRSE : FDRSE
    port map (
      Q  => sync_i,                     -- [out std_logic]
      C  => Bit_Clk,                    -- [in  std_logic]
      CE => start_Sync,                 -- [in  std_logic]
      D  => '1',                        -- [in  std_logic]
      S  => '0',                        -- [in  std_logic]
      R  => reset_Sync);                -- [in std_logic]

  Sync <= sync_i;

  -----------------------------------------------------------------------------
  -- Generating a 16 delay followed with continous 20 clock delays
  -----------------------------------------------------------------------------

  new_slot <= slot_end when last_slot = '0' else '0';

  Delay_4_SRL16 : SRL16E
    -- pragma translate_off
    generic map (
      INIT => X"0000")                  -- [bit_vector]
    -- pragma translate_on
    port map (
      CE  => '1',                       -- [in  std_logic]
      D   => new_slot,                  -- [in  std_logic]
      Clk => Bit_Clk,                   -- [in  std_logic]
      A0  => '1',                       -- [in  std_logic]
      A1  => '1',                       -- [in  std_logic]
      A2  => '0',                       -- [in  std_logic]
      A3  => '0',                       -- [in  std_logic]
      Q   => delay_4);                  -- [out std_logic]

  con_slot <= (start_Sync or delay_4);

  Delay_16_SRL16 : SRL16E
    -- pragma translate_off
    generic map (
      INIT => X"0000")                  -- [bit_vector]
    -- pragma translate_on
    port map (
      CE  => '1',                       -- [in  std_logic]
      D   => con_slot,                  -- [in  std_logic]
      Clk => Bit_Clk,                   -- [in  std_logic]
      A0  => '1',                       -- [in  std_logic]
      A1  => '1',                       -- [in  std_logic]
      A2  => '1',                       -- [in  std_logic]
      A3  => '1',                       -- [in  std_logic]
      Q   => slot_end);                 -- [out std_logic]

  -- slot_end will go '1' after 16 clock cycle from start sync and each 20
  -- clock cycle there after

  -----------------------------------------------------------------------------
  -- Count 13 slot_ends to restart a new frame
  -----------------------------------------------------------------------------

  Slot_count_SRL16 : SRL16E
    -- pragma translate_off
    generic map (
      INIT => X"0000")                  -- [bit_vector]
    -- pragma translate_on
    port map (
      CE  => slot_end,                  -- [in  std_logic]
      D   => sync_i,                    -- [in  std_logic]
      Clk => Bit_Clk,                   -- [in  std_logic]
      A0  => '1',                       -- [in  std_logic]
      A1  => '1',                       -- [in  std_logic]
      A2  => '0',                       -- [in  std_logic]
      A3  => '1',                       -- [in  std_logic]
      Q   => last_slot);                -- [out std_logic]

  start_Sync <= (last_slot and slot_end) or not start_from_reset;

  start_from_reset_FD : FD
    port map (
      Q => start_from_reset,            -- [out std_logic]
      C => Bit_Clk,                     -- [in  std_logic]
      D => '1');                        -- [in std_logic]

  -----------------------------------------------------------------------------
  -- Handling the SData_Out
  -----------------------------------------------------------------------------
  Slot_Cnt_Handle : process (Bit_Clk) is
  begin  -- process Data_Out_Handle
    if Bit_Clk'event and Bit_Clk = '1' then  -- rising clock edge
      if (start_sync = '1') then
        slot_No <= 0;
      elsif (slot_end = '1') then
        if (slot_No < 5) then
          slot_No <= slot_No + 1;
        end if;
      end if;
    end if;
  end process Slot_Cnt_Handle;

  -----------------------------------------------------------------------------
  -- 
  -----------------------------------------------------------------------------
  process (start_sync, slot_No,slot_end, slot0, slot1, slot2, In_Data_FIFO_i) is
  begin  -- process
    new_data_out <= (others => '0');
    read_fifo    <= '0';
    if (start_sync = '1') then
      new_data_out(19 downto 4) <= slot0;
      read_fifo                 <= '0';
    elsif (slot_end = '1') then
      read_fifo    <= '0';
      case slot_No is
        when 0 => new_data_out(slot1'range) <= slot1;
        when 1 => new_data_out(slot2'range) <= slot2;
        when 2 =>
          if (C_PLAYBACK = 1) then
            new_data_out(19 downto 4) <= In_Data_FIFO_i;
            read_fifo                 <= slot0(12);
          end if;
        when 3 =>
          if (C_PLAYBACK = 1) then
            new_data_out(19 downto 4) <= In_Data_FIFO_i;
            read_fifo                 <= slot0(11);
          end if;
        when others => null;
      end case;
    end if;
  end process;

  Read_FIFO_DFF: process (Bit_Clk) is
  begin  -- process Read_FIFO_DFF
    if Bit_Clk'event and Bit_Clk = '1' then    -- rising clock edge
      read_FIFO_1 <= read_fifo;
    end if;
  end process Read_FIFO_DFF;
  
  -----------------------------------------------------------------------------
  -- 
  -----------------------------------------------------------------------------
  Reading_the_FIFO : process (Clk, Reset) is
    variable tmp   : std_logic;
    variable tmp_1 : std_logic;
  begin  -- process Reading_the_FIFO
    if Reset = '1' then                 -- asynchronous reset (active high)
      in_FIFO_Read <= '0';
      tmp          := '0';
      tmp_1        := '0';
    elsif Clk'event and Clk = '1' then  -- rising clock edge
      in_FIFO_Read <= '0';
      if ((tmp_1 = '0' and tmp = '1')) then
        in_FIFO_Read <= '1';
      end if;
      tmp_1 := tmp;
      tmp   := read_FIFO_1;
    end if;
  end process Reading_the_FIFO;

  -----------------------------------------------------------------------------
  -- 
  -----------------------------------------------------------------------------
  Data_Out_Handle : process (Bit_Clk) is
  begin  -- process Data_Out_Handle
    if Bit_Clk'event and Bit_Clk = '1' then  -- rising clock edge
      SData_Out <= data_out(19);
      if (start_sync = '1') or (slot_end = '1') then
        data_out <= New_Data_Out;
      else
        data_out(19 downto 0) <= data_out(18 downto 0) & '0';
      end if;
    end if;
  end process Data_Out_Handle;

  -----------------------------------------------------------------------------
  -- 
  -----------------------------------------------------------------------------
  Shifting_Data_Coming_Back : process (Bit_Clk) is
  begin  -- process Shifting_Data_Coming_Back
    if Bit_Clk'event and Bit_Clk = '0' then  -- falling clock edge
      data_in(19 downto 0) <= data_in(18 downto 0) & SData_In;
    end if;
  end process Shifting_Data_Coming_Back;

  -----------------------------------------------------------------------------
  -- 
  -----------------------------------------------------------------------------
  Signal_Delays : process (Bit_Clk) is
   begin
    if Bit_Clk'event and Bit_Clk= '1' then
	 slot_No_1 <= slot_No;
	 slot_end_1 <= slot_end;
    end if;
  end process Signal_Delays;

  -----------------------------------------------------------------------------
  -- 
  -----------------------------------------------------------------------------
 Grabbing_Data_Coming_Back : process (Bit_Clk) is
  begin  -- process Grabbing_Data_Coming_Back
    if Bit_Clk'event and Bit_Clk = '1' then  -- rising clock edge
      if (slot_No_1 = 0 and slot_end_1 = '1') then
        codec_rdy           <= data_in(15);
        data_valid          <= data_in(13);
        valid_Record_Data_L <= data_in(12);
        valid_Record_Data_R <= data_in(11);
      end if;
    end if;
  end process Grabbing_Data_Coming_Back;

  -----------------------------------------------------------------------------
  -- Get slot 1 data
  -----------------------------------------------------------------------------
  Get_Slot_1_Data : process (Bit_Clk) is
  begin  -- process Get_Slot_1_Data
    if Bit_Clk'event and Bit_Clk = '1' then  -- rising clock edge
      if (slot_end_1 = '1' and slot_No_1 = 1) then
        valid_Playback_Data_L <= not data_in(11);
        valid_Playback_Data_R <= not data_in(10);
      end if;
    end if;
  end process Get_Slot_1_Data;

  -----------------------------------------------------------------------------
  -- Get slot 2 data
  -----------------------------------------------------------------------------
  Get_Reg_Read_Data : process (Bit_Clk) is
  begin  -- process Get_Reg_Read_Data
    if Bit_Clk'event and Bit_Clk = '1' then  -- rising clock edge
      got_read_data <= '0';
      if (slot_end_1 = '1' and slot_No_1 = 2 and data_valid = '1') then
        AC97_Reg_Read_Data <= data_in(19 downto 4);
        got_read_data <= '1';
      end if;
    end if;
  end process Get_Reg_Read_Data;

  -----------------------------------------------------------------------------
  -- Get slot 3 and 4 data
  -----------------------------------------------------------------------------
  Get_Record_Data : process (Bit_Clk) is
  begin  -- process Get_Record_Data
    if Bit_Clk'event and Bit_Clk = '1' then  -- rising clock edge
      got_record_data <= '0';
      if (C_RECORD = 1) then
        if (slot_end_1 = '1' and slot_No_1 = 3 and valid_Record_Data_L = '1') then
          Out_Data_FIFO   <= data_in(19 downto 4);
          got_record_data <= '1';
        elsif (slot_end_1 = '1' and slot_No_1 = 4 and valid_Record_Data_R = '1') then
          Out_Data_FIFO   <= data_in(19 downto 4);
          got_record_data <= '1';
        end if;
      end if;
    end if;
  end process Get_Record_Data;

  Got_Record_Data_DFF : FDCE
    port map (
      Q   => write_fifo,                -- [out std_logic]
      C   => Bit_Clk,                   -- [in  std_logic]
      CE  => Got_Record_Data,           -- [in  std_logic]
      D   => '1',                       -- [in  std_logic]
      CLR => fifo_written);             -- [in std_logic]

  Write_FIFO_Handle: process (Clk, Reset) is
    variable tmp   : std_logic;
    variable tmp_1 : std_logic;
  begin  -- process Write_FIFO_Handle
    if Reset = '1' then                 -- asynchronous reset (active high)
      fifo_written <= '0';
      tmp   := '0';
      tmp_1 := '0';
    elsif Clk'event and Clk = '1' then  -- rising clock edge
      fifo_written <= '0';
      if ((tmp = '1') and (tmp_1 = '0')) then
        fifo_written <= '1';
      end if;
      tmp_1 := tmp;
      tmp := write_fifo;
    end if;
  end process Write_FIFO_Handle;

  Out_FIFO_Write <= fifo_written;
  
  ac97_Reg_Finished_i <= (got_read_data and ac97_read_access) or  -- Read operation
                         (start_sync and ac97_write_access);  -- Write operation

  Req_Finished_DFF : FDCE
    port map (
      Q   => ac97_Reg_Finished,         -- [out std_logic]
      C   => Bit_Clk,                   -- [in  std_logic]
      CE  => ac97_Reg_Finished_i,       -- [in  std_logic]
      D   => '1',                       -- [in  std_logic]
      CLR => AC97_Request_Finished);    -- [in std_logic]

end architecture IMP;

