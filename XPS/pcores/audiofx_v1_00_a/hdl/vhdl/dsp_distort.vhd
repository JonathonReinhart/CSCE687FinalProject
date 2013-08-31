library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dsp_distort is
    port (
        sys_clk         : in  std_logic;
        samp_ena        : in  std_logic;
        x_in            : in  std_logic_vector(15 downto 0);
        thresh          : in  std_logic_vector(15 downto 0);
        y_out           : out std_logic_vector(15 downto 0)
    );
end dsp_distort;

architecture IMP of dsp_distort is
begin

    process(sys_clk)
        variable sample,nthresh,t : integer range -32768 to 32767;
    begin
        if (rising_edge(sys_clk)) then
            if (samp_ena = '1') then
                sample := to_integer(signed(x_in));
                t := to_integer(signed(thresh));
                nthresh := -t;
                if (sample > t) then
                    y_out <= thresh;
                elsif (sample < nthresh) then
                    y_out <= std_logic_vector(signed(not thresh) + 1);
                else
                    y_out <= x_in;
                end if;
            end if; -- samp_ena
        end if; -- rising_edge(sys_clk)        
    end process;

end IMP;

