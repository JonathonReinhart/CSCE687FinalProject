library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package data_types is 

    type slv_array is array ( natural range<> ) of std_logic_vector(15 downto 0);
    type u_array is array ( natural range<> ) of unsigned(15 downto 0);
    type s_array is array ( natural range<> ) of signed(15 downto 0);
  
end package data_types;

----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity sawtooth is
    port (
        sys_clk     : in  std_logic;
        samp_ena    : in  std_logic;
        top         : in  std_logic_vector(15 downto 0);
        rate        : in  std_logic_vector(15 downto 0);
        dataout     : out std_logic_vector(15 downto 0)
    );
end sawtooth;

architecture Behavioral of sawtooth is
    signal sawval   : unsigned(15 downto 0) := (others => '0');
    signal cnt      : unsigned(15 downto 0) := (others => '0');
    signal up       : std_logic := '1';
begin

    dataout <= std_logic_vector(sawval);

    process(sys_clk)
    begin
        if rising_edge(sys_clk) then
            if (samp_ena = '1') then
                cnt <= cnt + 1;
                
                -- Once cnt reaches rate, we change our output value.
                if cnt = unsigned(rate) then
                    cnt <= (others => '0');
                    
                    if (up = '1') then
                        sawval <= sawval + 1;
                        if (sawval = unsigned(top)) then
                            up <= '0';
                        end if;
                    else
                        sawval <= sawval - 1;
                        if (sawval = 0) then
                            up <= '1';
                        end if;
                    end if;
                    
                end if;
            
            end if; --samp_ena
        end if; --rising_edge(sys_clk)
    end process;

end Behavioral;


----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------

