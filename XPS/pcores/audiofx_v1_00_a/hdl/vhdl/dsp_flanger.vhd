library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library audiofx_v1_00_a;
use audiofx_v1_00_a.data_types.all;

entity dsp_flanger is
    port (
        sys_clk         : in  std_logic;
        samp_ena        : in  std_logic;
        rate            : in  std_logic_vector(15 downto 0);
        x_in            : in  std_logic_vector(15 downto 0);
        y_out           : out std_logic_vector(15 downto 0)
    );
end dsp_flanger;

architecture IMP of dsp_flanger is
    --components  
    component sawtooth is
        port (
            sys_clk         : in  std_logic;
            samp_ena        : in  std_logic;
            top             : in  std_logic_vector(15 downto 0);
            rate            : in  std_logic_vector(15 downto 0);
            dataout         : out std_logic_vector(15 downto 0)
        );
    end component;
  
    --signals
    constant DELAY_ADDR_BITS    : positive := 10;
    constant DELAY_RAM_SIZE     : positive := 2**DELAY_ADDR_BITS;
    constant SAW_MAX            : positive := 480;  -- 10 ms
    
    signal delay_ram            : slv_array(0 to DELAY_RAM_SIZE-1) := (others => (others => '0'));
    signal next_samp_idx        : unsigned(DELAY_ADDR_BITS-1 downto 0);
    signal delay_samp_idx       : unsigned(DELAY_ADDR_BITS-1 downto 0);
    
    signal delay_samp           : std_logic_vector(15 downto 0);
    
    signal x_in_div2            : signed(15 downto 0);
    signal delay_samp_div2      : signed(15 downto 0);
    
    signal sawtooth_sig     : std_logic_vector(15 downto 0);

    
begin

    SAWTOOTH_I : sawtooth
        port map(
            sys_clk => sys_clk,
            samp_ena => samp_ena,
            top => std_logic_vector(to_unsigned(SAW_MAX, 16)), -- TODO: Make this configurable
            rate => rate,
            dataout => sawtooth_sig
        );
        

    EACH_NEW_SAMPLE : process(sys_clk) is
    begin
        if rising_edge(sys_clk) then
            if samp_ena = '1' then
            
                -- Store the next sample and increment the pointer
            
                -- Register the next sample
                delay_ram( to_integer(next_samp_idx) ) <= x_in;
                
                -- This will wrap around to zero, creating a circular buffer
                next_samp_idx <= next_samp_idx + 1;
                
                -----------------------------------------------------------------------------------
                
                -- Since the RAM is always a power-of-two in length, an underflow in this
                -- subtraction will cause the desired wrap-around to the end of the RAM.
                -- (ex. assuming length of 8,  3-5 = -2 = 0b110 = 6 = 8-2)
                delay_samp_idx <= next_samp_idx - resize(unsigned(sawtooth_sig), DELAY_ADDR_BITS);


                -- Get the delayed sample from the RAM.
                delay_samp <= delay_ram( to_integer(delay_samp_idx) );
                
            end if;
        end if;
    
    end process EACH_NEW_SAMPLE;
    


    
    -- Weighted addition (each is 1/2)
    x_in_div2 <= shift_right(signed(x_in), 1);
    delay_samp_div2 <= shift_right(signed(delay_samp), 1);
    y_out <= std_logic_vector( x_in_div2 + delay_samp_div2 );

end IMP;