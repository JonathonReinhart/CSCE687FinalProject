library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity rollavg_TB is
end rollavg_TB;

architecture BEHAVIORAL of rollavg_TB is

--------------
--- Components
    component rollavg is
        generic (
            XY_WIDTH            : positive := 16;
            A_SHIFT             : positive := 10
        );
        port (
            clk         : in  std_logic;
            samp_ena    : in  std_logic;
            reset       : in  std_logic;
            x           : in  std_logic_vector(XY_WIDTH-1 downto 0);    -- input
            y           : out std_logic_vector(XY_WIDTH-1 downto 0)     -- output 
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
    
-----------    
--- Signals    

    -- Driven by TB (UUT 'in' ports)
    signal clk : std_logic;
    signal samp_ena : std_logic;
    signal x : std_logic_vector(15 downto 0);
   
    -- Driven by FSL device (UUT 'out' ports)
    signal y : std_logic_vector(15 downto 0);
    
    -- Constants
    constant CLK_PER  : time := 1 ns;

begin

    CLKGEN_INST : clockgen
        generic map (
            PERIOD => CLK_PER
            )
        port map (
            clk => clk,
            rst => open
            );

    UUT : rollavg
        generic map (
            XY_WIDTH => 16,
            A_SHIFT => 12
        )
        port map (
            clk => clk,
            samp_ena => samp_ena,
            reset => '0',
            x => x,
            y => y
        );


    SIM : process is
    begin
        wait until rising_edge(clk);
        
        samp_ena <= '0';
        x <= std_logic_vector(to_signed(-10000, x'length));
        wait for 10*CLK_PER;
        
        samp_ena <= '1';
        wait for 1000*CLK_PER;
        
        x <= std_logic_vector(to_signed(20000, x'length));
        wait for 1000*CLK_PER;
        
        x <= std_logic_vector(to_signed(0, x'length));
        
        wait;

    end process;
   
end architecture BEHAVIORAL;
