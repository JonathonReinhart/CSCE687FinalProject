library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.dsp_types_pkg.all;

entity dsp_switcher_TB is
end dsp_switcher_TB;

architecture BEHAVIORAL of dsp_switcher_TB is

--------------
--- Components
    component dsp_switcher is
        generic (
            NUM_DSPS        : positive := 4
        );
        port (
            sys_clk         : in  std_logic;     -- Global system clock (125 MHz)
            samp_ena        : in  std_logic;     -- "Sample present" clock enable (48 kHz)
            reset           : in  std_logic;
            samp_in         : in  std_logic_vector(15 downto 0);
            samp_out        : out std_logic_vector(15 downto 0);
            
            dsp_enables     : in  std_logic_vector(NUM_DSPS-1 downto 0);
            dsp_sends       : out slv16_array(0 to NUM_DSPS-1);
            dsp_returns     : in  slv16_array(0 to NUM_DSPS-1)
        );
    end component;
    
    component clockgen is
        generic (
            PERIOD : time := 20 ns;
            RST_DUR : integer := 2
        );
        port (
            clk : out std_logic;
            rst : out std_logic
        );
    end component;

-------------
--- Constants
    constant CLK_PER  : time := 1 ns;
    constant NUM_DSPS : positive := 4;

    
-----------    
--- Signals    

    -- Driven by TB (UUT 'in' ports)
    signal clk              : std_logic;
    signal samp_ena         : std_logic;
    signal x                : std_logic_vector(15 downto 0);
    signal dsp_enables      : std_logic_vector(NUM_DSPS-1 downto 0);
    signal dsp_returns      : slv16_array(0 to NUM_DSPS-1);
   
    -- Driven by FSL device (UUT 'out' ports)
    signal y                : std_logic_vector(15 downto 0);
    signal dsp_sends        : slv16_array(0 to NUM_DSPS-1);


begin

    CLKGEN_INST : clockgen
        generic map (
            PERIOD => CLK_PER
        )
        port map (
            clk => clk,
            rst => open
        );

    UUT : dsp_switcher
        generic map (
            NUM_DSPS => NUM_DSPS
        )
        port map (
            sys_clk => clk,
            samp_ena => samp_ena,
            reset => '0',
            samp_in => x,
            samp_out => y,
            
            dsp_enables => dsp_enables,
            dsp_sends => dsp_sends,
            dsp_returns => dsp_returns
        );
            

    -- DSP 0 will invert the signal
    dsp_returns(0) <= std_logic_vector( -signed(dsp_sends(0)) );
    
    -- DSP 1 will add one to the signal
    dsp_returns(1) <= std_logic_vector( signed(dsp_sends(1)) + 1 );
    
    -- DSP 2 will shift the signal left one
    dsp_returns(2) <=  std_logic_vector( signed(dsp_sends(2)) * 2 );
    
    -- DSP 3 will simply put out a 666
    dsp_returns(3) <= std_logic_vector(to_signed(666, 16));


    SIM : process is
    begin
        wait until rising_edge(clk);
        
        dsp_enables <= (others => '0');  -- disable all DSPs
        

        samp_ena <= '0';
        x <= std_logic_vector(to_signed(-10000, x'length));
        wait for 10*CLK_PER;
        
        samp_ena <= '1';
        wait for 10*CLK_PER;
        
        -- DSP 0
        dsp_enables <= "0001";
        wait for 10*CLK_PER;
        
        -- DSP 1
        dsp_enables <= "0010";
        wait for 10*CLK_PER;
        
        -- DSP 2
        dsp_enables <= "0100";
        wait for 10*CLK_PER;

        -- DSP 3
        dsp_enables <= "1000";
        wait for 10*CLK_PER;
        
        -- DSP 0 + 1
        dsp_enables <= "0011";
        wait for 10*CLK_PER;
        
        -- DSP 0 + 1 + 2
        dsp_enables <= "0111";
        wait for 10*CLK_PER;
        
        wait;

    end process;
   
end architecture BEHAVIORAL;
