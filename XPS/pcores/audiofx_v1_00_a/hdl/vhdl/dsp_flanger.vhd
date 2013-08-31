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
    component counter is
        port (
            sys_clk         : in  std_logic;
            samp_ena        : in  std_logic;
            top             : in  std_logic_vector(15 downto 0);
            rate            : in  std_logic_vector(15 downto 0);
            dataout         : out std_logic_vector(15 downto 0)
        );
    end component;
  
    --signals
    constant MAX_REG        : integer := 450;
    signal delay_queue      : slv_array(0 to MAX_REG) := (others => (others => '0'));
    signal delay_line       : std_logic_vector(15 downto 0) := (others => '0');
    signal rate_line        : std_logic_vector(15 downto 0);
    signal rate_line2       : natural;
    signal xd1,xd2          : signed(15 downto 0) := (others => '0');
    signal f_sel            : std_logic_vector(31 downto 0);
    
begin

    delay_queue(0) <= x_in;

    -- Synchronous delay cycles.
    DELAYS : process(sys_clk)
    begin
        if rising_edge(sys_clk) then
            if samp_ena = '1' then
                -- Shift delay_queue by one sample.
                -- http://stackoverflow.com/questions/18247955
                delay_queue(1 to delay_queue'high) <= delay_queue(0 to delay_queue'high-1);
            end if;
        end if;
    end process;

    count : counter
        port map(
            sys_clk => sys_clk,
            samp_ena => samp_ena,
            top => X"01C0",
            rate => rate,
            dataout => rate_line
        );
	
    rate_line2 <= natural(to_integer(unsigned(rate_line)));

    delay_line <= delay_queue(rate_line2);

    xd1 <= shift_right(signed(x_in),1);
    xd2 <= shift_right(signed(delay_line),1);

    y_out <= std_logic_vector(xd1+xd2);

end IMP;