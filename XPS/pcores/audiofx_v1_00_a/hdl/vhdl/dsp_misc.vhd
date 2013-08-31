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

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;  --try to use this library as much as possible.

entity counter is
port (sys_clk : in  std_logic;
      samp_ena: in  std_logic;
      top     : in  std_logic_vector(15 downto 0);
      rate    : in  std_logic_vector(15 downto 0);
      dataout : out std_logic_vector(15 downto 0)
      );
end counter;

architecture Behavioral of counter is
signal i   : unsigned(15 downto 0) := (others => '0');
signal cnt : unsigned(15 downto 0) := (others => '0');
signal up  : std_logic := '1';
begin

process(sys_clk)
begin
  --to check the rising edge of the clock signal
  if(rising_edge(sys_clk)) then  --1
    if(samp_ena = '1') then
      dataout <= std_logic_vector(i);
      cnt <= cnt + 1;
      if cnt = unsigned(rate) then  --2
        if (up = '1') then  --3
          i <= i + X"0001";
          if(i = unsigned(top)) then  --4
            up <= '0';
          end if;  --4
        else  --3
          i <= i - X"0001";
          if(i = X"0001") then  --4
            up <= '1';
          end if;  --4
        end if; --3
        cnt <= (others => '0');
      end if;  --2
    end if;
  end if; --1
end process;

end Behavioral;


----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;

entity delay_reg is
  generic ( width : positive := 16 ); --just going to assume 16 bit sound, will need to rewrite for 8 bit
    port    (
        sys_clk : in  std_logic;
        samp_ena: in  std_logic;
	      x_in            : in  std_logic_vector((width-1) downto 0);
        y_out           : out std_logic_vector((width-1) downto 0)
    );
end delay_reg;

architecture delay_reg_arch of delay_reg is
begin

process(sys_clk)
begin
  if (rising_edge(sys_clk)) then
    if(samp_ena = '1') then
      y_out <= x_in;
    end if;
  end if;
end process;

end delay_reg_arch;


