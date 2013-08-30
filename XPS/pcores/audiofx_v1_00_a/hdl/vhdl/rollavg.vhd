library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity rollavg is
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
end entity rollavg;    


architecture IMP of rollavg is
    
    signal avg : std_logic_vector(XY_WIDTH-1 downto 0) := (others => '0');
    
begin


    GO : process(clk) is
        variable x_s : signed(x'range);
        variable avg_s : unsigned(avg'length + A_SHIFT downto 0);
    begin
        if rising_edge(clk) then
            if (reset = '1') then
                avg <= (others => '0');
                
            elsif (samp_ena = '1') then
                -- In C:  avg = ((avg<<12) - avg + ABS(x)) >> 12
                
                x_s := signed(x);
                if (x_s < to_signed(0, x_s'length)) then
                    x_s := -x_s;
                end if;
                
                avg_s := resize(unsigned(avg), avg_s'length);
                avg_s := shift_left(avg_s, A_SHIFT) - avg_s;        -- times (1 - 2**A_SHIFT)
                avg_s := avg_s + unsigned(x_s);
                avg_s := shift_right(avg_s, A_SHIFT);
                
                avg <= std_logic_vector(avg_s(avg'range));
            
            end if;
        end if;
    end process;
    
    y <= avg;

    
end IMP;

