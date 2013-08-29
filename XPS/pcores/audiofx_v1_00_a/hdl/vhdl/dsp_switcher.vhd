library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package dsp_types_pkg is

    type slv32_array is array(natural range <>) of std_logic_vector(31 downto 0);
    type slv16_array is array(natural range <>) of std_logic_vector(15 downto 0);
    type int_array is array(natural range<>) of integer;

end package;

----------------------------------------------------------------------------------------------------

----------------------
-- References:
-- http://forums.xilinx.com/t5/General-Technical-Discussion/Fundamental-misunderstanding-of-clock-enables/td-p/66752

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.dsp_types_pkg.all;

entity dsp_switcher is
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
end dsp_switcher;

architecture IMP of dsp_switcher is

    -- Registers between each DSP stage.
    signal dsp_input : slv16_array(0 to NUM_DSPS);  -- one extra for registered output

begin

    REGISTER_EACH_DSP : process(sys_clk)
    begin
        if rising_edge(sys_clk) then                    -- Global system clock (125 MHz)
        
            if (reset = '1') then                       -- Synchronout reset
                dsp_input <= (others => (others => '0'));
            
            elsif (samp_ena = '1') then                 -- DSP clock enable (48 kHz)
            
                -- The first DSP's input is the input to this switcher.
                dsp_input(0) <= samp_in;
            
                for i in 0 to NUM_DSPS-1 loop
                    -- The next DSP's input is this DSP's return if this DSP is enabled.
                    -- Otherwise it is just this DSP's dry input (bypassing this DSP).
                    if dsp_enables(i) = '1' then
                        dsp_input(i+1) <= dsp_returns(i);
                    else
                        dsp_input(i+1) <= dsp_input(i);
                    end if;
                    --dsp_input(i+1) <= dsp_returns(i) when (dsp_enables(i) = '1') else dsp_input(i);
                end loop;
            
            end if;
        end if; -- rising_edge(sys_clk)
    end process REGISTER_EACH_DSP; 
    
    dsp_sends <= dsp_input(0 to NUM_DSPS-1);
    samp_out <= dsp_input(NUM_DSPS);

end IMP;