library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity gainstage_TB is
end gainstage_TB;

architecture BEHAVIORAL of gainstage_TB is

--------------
--- Components
    component dsp_gainstage is
        port (
            samp_clk    : in  std_logic;
            x           : in  std_logic_vector(15 downto 0);    -- input
            a           : in  std_logic_vector(31 downto 0);    -- gain (signed fixed point, 16 fractional bits)
            y           : out std_logic_vector(15 downto 0)     -- output 
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
    signal x : std_logic_vector(15 downto 0);
    signal a : std_logic_vector(31 downto 0);
   
    -- Driven by FSL device (UUT 'out' ports)
    signal y : std_logic_vector(15 downto 0);
    
    -- Constants
    constant CLK_PER  : time := 10 ns;

begin

    CLKGEN_INST : clockgen
        generic map (
            PERIOD => CLK_PER
            )
        port map (
            clk => clk,
            rst => open
            );

    UUT : dsp_gainstage
        port map (
            samp_clk => clk,
            x => x,
            a => a,
            y => y
            );


    SIM : process is
    begin
        wait until rising_edge(clk);

        x <= std_logic_vector(to_signed(10000, x'length));
        
        a <= x"00010000";       -- 1.0
        wait for CLK_PER;

        a <= x"00008000";       -- 0.5
        wait for CLK_PER;
        
        a <= x"0002C000";       -- 2.75
        wait for CLK_PER;
        
        a <= x"FFFF0000";       -- -1.0
        wait for CLK_PER;
        
        
        x <= std_logic_vector(to_signed(-10000, x'length));
        
        a <= x"00010000";       -- 1.0
        wait for CLK_PER;

        a <= x"00008000";       -- 0.5
        wait for CLK_PER;
        
        a <= x"0002C000";       -- 2.75
        wait for CLK_PER;
        
        a <= x"FFFF0000";       -- -1.0
        wait for CLK_PER;
        
        wait;

    end process;
   
end architecture BEHAVIORAL;
