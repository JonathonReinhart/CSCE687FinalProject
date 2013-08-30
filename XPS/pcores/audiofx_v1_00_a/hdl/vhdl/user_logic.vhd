library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library proc_common_v3_00_a;
use proc_common_v3_00_a.proc_common_pkg.all;

library audiofx_v1_00_a;
use audiofx_v1_00_a.all;


--USER libraries added here

------------------------------------------------------------------------------
-- Entity section
------------------------------------------------------------------------------
-- Definition of Generics:
--   C_SLV_DWIDTH                 -- Slave interface data bus width
--   C_NUM_REG                    -- Number of software accessible registers
--
-- Definition of Ports:
--   Bus2IP_Clk                   -- Bus to IP clock
--   Bus2IP_Reset                 -- Bus to IP reset
--   Bus2IP_Data                  -- Bus to IP data bus
--   Bus2IP_BE                    -- Bus to IP byte enables
--   Bus2IP_RdCE                  -- Bus to IP read chip enable
--   Bus2IP_WrCE                  -- Bus to IP write chip enable
--   IP2Bus_Data                  -- IP to Bus data bus
--   IP2Bus_RdAck                 -- IP to Bus read transfer acknowledgement
--   IP2Bus_WrAck                 -- IP to Bus write transfer acknowledgement
--   IP2Bus_Error                 -- IP to Bus error response
------------------------------------------------------------------------------

entity user_logic is
    generic
    (
        -- ADD USER GENERICS BELOW THIS LINE ---------------
        --USER generics added here
        -- ADD USER GENERICS ABOVE THIS LINE ---------------

        -- DO NOT EDIT BELOW THIS LINE ---------------------
        -- Bus protocol parameters, do not add to or delete
        C_SLV_DWIDTH                   : integer              := 32;
        C_NUM_REG                      : integer              := 16;
        -- DO NOT EDIT ABOVE THIS LINE ---------------------
        
        C_FSL_DWIDTH      : integer                   := 32
    );
    port
    (
        -- ADD USER PORTS BELOW THIS LINE ------------------
        --USER ports added here
        -- ADD USER PORTS ABOVE THIS LINE ------------------

        -- DO NOT EDIT BELOW THIS LINE ---------------------
        -- Bus protocol ports, do not add to or delete
        Bus2IP_Clk                     : in  std_logic;
        Bus2IP_Reset                   : in  std_logic;
        Bus2IP_Data                    : in  std_logic_vector(0 to C_SLV_DWIDTH-1);
        Bus2IP_BE                      : in  std_logic_vector(0 to C_SLV_DWIDTH/8-1);
        Bus2IP_RdCE                    : in  std_logic_vector(0 to C_NUM_REG-1);
        Bus2IP_WrCE                    : in  std_logic_vector(0 to C_NUM_REG-1);
        IP2Bus_Data                    : out std_logic_vector(0 to C_SLV_DWIDTH-1);
        IP2Bus_RdAck                   : out std_logic;
        IP2Bus_WrAck                   : out std_logic;
        IP2Bus_Error                   : out std_logic;
        -- DO NOT EDIT ABOVE THIS LINE ---------------------
        
        
        -- BEGIN  FSL Bus ports
        FSL_Clk         : in  std_logic;
        FSL_Rst         : in  std_logic;

        FSL_S_Clk       : in  std_logic;
        FSL_S_Read      : out std_logic;
        FSL_S_Data      : in  std_logic_vector(0 to C_FSL_DWIDTH-1);
        FSL_S_Control   : in  std_logic;
        FSL_S_Exists    : in  std_logic;

        FSL_M_Clk       : in  std_logic;
        FSL_M_Write     : out std_logic;
        FSL_M_Data      : out std_logic_vector(0 to C_FSL_DWIDTH-1);
        FSL_M_Control   : out std_logic;
        FSL_M_Full      : in  std_logic
        -- END  FSL Bus ports        
    );

    attribute MAX_FANOUT : string;
    attribute SIGIS : string;

    attribute SIGIS of Bus2IP_Clk    : signal is "CLK";
    attribute SIGIS of Bus2IP_Reset  : signal is "RST";
    
    attribute SIGIS of FSL_Clk   : signal is "Clk"; 
    attribute SIGIS of FSL_S_Clk : signal is "Clk"; 
    attribute SIGIS of FSL_M_Clk : signal is "Clk";     

end entity user_logic;

------------------------------------------------------------------------------
-- Architecture section
------------------------------------------------------------------------------

architecture IMP of user_logic is

    constant C_SAMPWIDTH : integer := 16;

  ------------------------------------------
  -- Signals for user logic slave model s/w accessible register example
  ------------------------------------------
  signal slv_reg0_00h_CTRL_RW           : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg1_04h_STATUS_RO         : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg2_08h_DSPENA_RW         : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg3_0Ch_TESTCTR_RO        : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg4_10h                   : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg5_14h                   : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg6_18h                   : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg7_1Ch                   : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg8_20h                   : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg9_24h                   : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg10_28h                  : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg11_2Ch                  : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg12_30h                  : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg13_34h                  : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg14_38h                  : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg15_3Ch                  : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg_write_sel              : std_logic_vector(0 to 15);
  signal slv_reg_read_sel               : std_logic_vector(0 to 15);
  signal slv_ip2bus_data                : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_read_ack                   : std_logic;
  signal slv_write_ack                  : std_logic;
  
  
  
  --------------------------------------
  -- FSL
  
    type FSL_STATE_TYPE is (FSL_IDLE, FSL_SREAD_L, FSL_SREAD_R, FSL_MWRITE_L, FSL_MWRITE_R);
    signal fsl_state: FSL_STATE_TYPE;
    
    --signal samp_clk_l, samp_clk_r : std_logic;
    
    signal sample_l, sample_r : std_logic_vector(C_SAMPWIDTH-1 downto 0);
    signal samp_ena_l, samp_ena_r : std_logic;      -- clock enables for DSP logic
    
    signal result_l, result_r, result_muxed : std_logic_vector(C_SAMPWIDTH-1 downto 0);

begin


----------------------------------------------------------------------------------------------------   
--- BEGIN   FSL bus transaction implementation

    FSL_PROCESS : process (FSL_Clk) is
    begin
        if rising_edge(FSL_Clk) then
            if FSL_Rst = '1' then
                fsl_state <= FSL_IDLE;
                sample_l <= (others => '0');
                sample_r <= (others => '0');
                samp_ena_l <= '0';
                samp_ena_r <= '0';
                
            else    -- not reset
                case fsl_state is
                    -- Idle
                    when FSL_IDLE =>
                        if (FSL_S_Exists = '1') then
                            fsl_state <= FSL_SREAD_L;
                            samp_ena_l <= '0';
                            samp_ena_r <= '0';
                        end if;
                        
                    -- Read the Left channel
                    when FSL_SREAD_L =>   
                        if (FSL_S_Exists = '1') then
                            sample_l <= FSL_S_Data(C_FSL_DWIDTH - 16 to C_FSL_DWIDTH - 1);
                            samp_ena_l <= '1';
                            fsl_state <= FSL_SREAD_R;
                        end if;
                    -- Read the Right channel
                    when FSL_SREAD_R =>   
                        if (FSL_S_Exists = '1') then
                            sample_r <= FSL_S_Data(C_FSL_DWIDTH - 16 to C_FSL_DWIDTH - 1);
                            samp_ena_r <= '1';
                            fsl_state <= FSL_MWRITE_L;
                        end if;
                        
                    -- Write the Left channel
                    when FSL_MWRITE_L =>
                        if (FSL_M_Full = '0') then
                            fsl_state <= FSL_MWRITE_R;
                        end if;
                    -- Write the Right channel
                    when FSL_MWRITE_R =>
                        if (FSL_M_Full = '0') then
                            fsl_state <= FSL_IDLE;
                        end if;
                        
                end case;
                
                -- Make sure the "sample present" clock enables are only active for one clock cycle.
                if (samp_ena_l = '1') then
                    samp_ena_l <= '0';
                end if;
                if (samp_ena_r = '1') then
                    samp_ena_r <= '0';
                end if;
                
            end if;
        end if;  -- rising_edge(FSL_Clk)
    end process FSL_PROCESS;
    
    -- When we're in one of the FSL_SREAD_x states, and there's incoming data, read it.
    FSL_S_Read  <= FSL_S_Exists   when (fsl_state = FSL_SREAD_L) or (fsl_state = FSL_SREAD_R)   else '0';
    
    -- When we're in one of the FSL_MWRITE_x states, and the outgoing FIFO isn't full, write it.
    FSL_M_Write <= not FSL_M_Full when (fsl_state = FSL_MWRITE_L) or (fsl_state = FSL_MWRITE_R)  else '0';

    -- Interleave the outgoing data.
    result_muxed <= result_l when (fsl_state = FSL_MWRITE_L) else
                    result_r when (fsl_state = FSL_MWRITE_R) else
                    (others => '0');
    FSL_M_Data <= (0 to C_FSL_DWIDTH-result_muxed'length-1 => '0') & result_muxed;
    
    
    -- TEMP:
    -- Just write the samples back out - in the opposite channel for test!
    result_l <= sample_r;   --sample_l;
    result_r <= sample_l;   --sample_r;
    
    
    
    -- See if we're getting any signal
    AVG_LEVEL_L : entity audiofx_v1_00_a.rollavg
    generic map (
        XY_WIDTH => 16,
        A_SHIFT => 8
    )
    port map (
        clk => FSL_Clk,
        samp_ena => samp_ena_l,
        reset => FSL_Rst,
        x => sample_l,
        y => slv_reg4_10h(16 to 31)
    );
    
    AVG_LEVEL_R : entity audiofx_v1_00_a.rollavg
    generic map (
        XY_WIDTH => 16,
        A_SHIFT => 8
    )
    port map (
        clk => FSL_Clk,
        samp_ena => samp_ena_r,
        reset => FSL_Rst,
        x => sample_r,
        y => slv_reg5_14h(16 to 31)
    );
    
    
    COUNT_SAMPLES : process (FSL_Clk) is
    begin
        if rising_edge(FSL_Clk) then
            if samp_ena_l = '1' then
                slv_reg3_0Ch_TESTCTR_RO <= slv_reg3_0Ch_TESTCTR_RO + 1;
            end if;
        end if; -- rising_edge(FSL_Clk)
    end process;
    


    
    
--- END     FSL bus transaction implementation  
----------------------------------------------------------------------------------------------------     
  
  
  
----------------------------------------------------------------------------------------------------   
--- BEGIN   PLB Software Register Implementation  
  
  ------------------------------------------
  -- Example code to read/write user logic slave model s/w accessible registers
  -- 
  -- Note:
  -- The example code presented here is to show you one way of reading/writing
  -- software accessible registers implemented in the user logic slave model.
  -- Each bit of the Bus2IP_WrCE/Bus2IP_RdCE signals is configured to correspond
  -- to one software accessible register by the top level template. For example,
  -- if you have four 32 bit software accessible registers in the user logic,
  -- you are basically operating on the following memory mapped registers:
  -- 
  --    Bus2IP_WrCE/Bus2IP_RdCE   Memory Mapped Register
  --                     "1000"   C_BASEADDR + 0x0
  --                     "0100"   C_BASEADDR + 0x4
  --                     "0010"   C_BASEADDR + 0x8
  --                     "0001"   C_BASEADDR + 0xC
  -- 
  ------------------------------------------
  slv_reg_write_sel <= Bus2IP_WrCE(0 to 15);
  slv_reg_read_sel  <= Bus2IP_RdCE(0 to 15);
  slv_write_ack     <= Bus2IP_WrCE(0) or Bus2IP_WrCE(1) or Bus2IP_WrCE(2) or Bus2IP_WrCE(3) or Bus2IP_WrCE(4) or Bus2IP_WrCE(5) or Bus2IP_WrCE(6) or Bus2IP_WrCE(7) or Bus2IP_WrCE(8) or Bus2IP_WrCE(9) or Bus2IP_WrCE(10) or Bus2IP_WrCE(11) or Bus2IP_WrCE(12) or Bus2IP_WrCE(13) or Bus2IP_WrCE(14) or Bus2IP_WrCE(15);
  slv_read_ack      <= Bus2IP_RdCE(0) or Bus2IP_RdCE(1) or Bus2IP_RdCE(2) or Bus2IP_RdCE(3) or Bus2IP_RdCE(4) or Bus2IP_RdCE(5) or Bus2IP_RdCE(6) or Bus2IP_RdCE(7) or Bus2IP_RdCE(8) or Bus2IP_RdCE(9) or Bus2IP_RdCE(10) or Bus2IP_RdCE(11) or Bus2IP_RdCE(12) or Bus2IP_RdCE(13) or Bus2IP_RdCE(14) or Bus2IP_RdCE(15);

  -- implement slave model software accessible register(s)
  SLAVE_REG_WRITE_PROC : process( Bus2IP_Clk ) is
  begin

    if Bus2IP_Clk'event and Bus2IP_Clk = '1' then
      if Bus2IP_Reset = '1' then
        slv_reg0_00h_CTRL_RW <= (others => '0');
        --slv_reg1_04h_STATUS_RO <= (others => '0');
        slv_reg2_08h_DSPENA_RW <= (others => '0');
        --slv_reg3_0Ch_TESTCTR_RO <= (others => '0');
        --slv_reg4_10h <= (others => '0');
        --slv_reg5_14h <= (others => '0');
        slv_reg6_18h <= (others => '0');
        slv_reg7_1Ch <= (others => '0');
        slv_reg8_20h <= (others => '0');
        slv_reg9_24h <= (others => '0');
        slv_reg10_28h <= (others => '0');
        slv_reg11_2Ch <= (others => '0');
        slv_reg12_30h <= (others => '0');
        slv_reg13_34h <= (others => '0');
        slv_reg14_38h <= (others => '0');
        slv_reg15_3Ch <= (others => '0');
      else
        case slv_reg_write_sel is
          when "1000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg0_00h_CTRL_RW(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          --when "0100000000000000" =>
          --  for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
          --    if ( Bus2IP_BE(byte_index) = '1' ) then
          --      slv_reg1_04h_STATUS_RO(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
          --    end if;
          --  end loop;
          when "0010000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg2_08h_DSPENA_RW(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          --when "0001000000000000" =>
          --  for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
          --    if ( Bus2IP_BE(byte_index) = '1' ) then
          --      slv_reg3_0Ch_TESTCTR_RO(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
          --    end if;
          --  end loop;
          --when "0000100000000000" =>
          --  for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
          --    if ( Bus2IP_BE(byte_index) = '1' ) then
          --      slv_reg4_10h(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
          --    end if;
          --  end loop;
          --when "0000010000000000" =>
          --  for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
          --    if ( Bus2IP_BE(byte_index) = '1' ) then
          --      slv_reg5_14h(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
          --    end if;
          --  end loop;
          when "0000001000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg6_18h(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "0000000100000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg7_1Ch(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "0000000010000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg8_20h(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "0000000001000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg9_24h(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "0000000000100000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg10_28h(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "0000000000010000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg11_2Ch(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "0000000000001000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg12_30h(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "0000000000000100" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg13_34h(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "0000000000000010" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg14_38h(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "0000000000000001" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg15_3Ch(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when others => null;
        end case;
      end if;
    end if;

  end process SLAVE_REG_WRITE_PROC;

  -- implement slave model software accessible register(s) read mux
  SLAVE_REG_READ_PROC : process( slv_reg_read_sel, slv_reg0_00h_CTRL_RW, slv_reg1_04h_STATUS_RO, slv_reg2_08h_DSPENA_RW, slv_reg3_0Ch_TESTCTR_RO, slv_reg4_10h, slv_reg5_14h, slv_reg6_18h, slv_reg7_1Ch, slv_reg8_20h, slv_reg9_24h, slv_reg10_28h, slv_reg11_2Ch, slv_reg12_30h, slv_reg13_34h, slv_reg14_38h, slv_reg15_3Ch ) is
  begin

    case slv_reg_read_sel is
      when "1000000000000000" => slv_ip2bus_data <= slv_reg0_00h_CTRL_RW;
      when "0100000000000000" => slv_ip2bus_data <= slv_reg1_04h_STATUS_RO;
      when "0010000000000000" => slv_ip2bus_data <= slv_reg2_08h_DSPENA_RW;
      when "0001000000000000" => slv_ip2bus_data <= slv_reg3_0Ch_TESTCTR_RO;
      when "0000100000000000" => slv_ip2bus_data <= slv_reg4_10h;
      when "0000010000000000" => slv_ip2bus_data <= slv_reg5_14h;
      when "0000001000000000" => slv_ip2bus_data <= slv_reg6_18h;
      when "0000000100000000" => slv_ip2bus_data <= slv_reg7_1Ch;
      when "0000000010000000" => slv_ip2bus_data <= slv_reg8_20h;
      when "0000000001000000" => slv_ip2bus_data <= slv_reg9_24h;
      when "0000000000100000" => slv_ip2bus_data <= slv_reg10_28h;
      when "0000000000010000" => slv_ip2bus_data <= slv_reg11_2Ch;
      when "0000000000001000" => slv_ip2bus_data <= slv_reg12_30h;
      when "0000000000000100" => slv_ip2bus_data <= slv_reg13_34h;
      when "0000000000000010" => slv_ip2bus_data <= slv_reg14_38h;
      when "0000000000000001" => slv_ip2bus_data <= slv_reg15_3Ch;
      when others => slv_ip2bus_data <= (others => '0');
    end case;

  end process SLAVE_REG_READ_PROC;

  ------------------------------------------
  -- Example code to drive IP to Bus signals
  ------------------------------------------
  IP2Bus_Data  <= slv_ip2bus_data when slv_read_ack = '1' else
                  (others => '0');

  IP2Bus_WrAck <= slv_write_ack;
  IP2Bus_RdAck <= slv_read_ack;
  IP2Bus_Error <= '0';

--- END     PLB Software Register Implementation  
----------------------------------------------------------------------------------------------------   


end IMP;
