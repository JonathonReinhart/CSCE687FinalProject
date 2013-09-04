library ieee;
use ieee.std_logic_1164.all;

entity clockgen is
    generic (
        PERIOD : time := 20 ns;
        RST_DUR : integer := 2
    );
    port (
        clk : out std_logic;
        rst : out std_logic
    );
end clockgen;

architecture behavioral of clockgen is
    signal c : std_logic := '1';
    
    
begin
    run: process
        variable i : integer := 0;
    begin

        while true loop

            -- Drive reset high for RST_DUR full clock periods
            if (i < 2*RST_DUR) then
                rst <= '1';
                i := i + 1;
            else
                rst <= '0';
            end if;
            
            -- Change clock state
            c <= not c;
            
            wait for (PERIOD/2);
            
        end loop;
        
        
    
    end process run;

    clk <= c;

end behavioral;