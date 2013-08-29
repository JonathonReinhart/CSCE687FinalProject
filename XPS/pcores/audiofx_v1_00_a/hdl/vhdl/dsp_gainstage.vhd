library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--library ieee_proposed;
--use ieee_proposed.fixed_pkg.all;    -- ufixed, sfixed

entity dsp_gainstage is
    generic (
        XY_WIDTH            : natural := 16;
        A_WIDTH             : natural := 32;
        A_FRACTIONAL_BITS   : natural := 16
    );
    port (
        samp_clk    : in  std_logic;
        x           : in  std_logic_vector(XY_WIDTH-1 downto 0);    -- input
        a           : in  std_logic_vector(A_WIDTH-1  downto 0);    -- gain
        y           : out std_logic_vector(XY_WIDTH-1 downto 0)     -- output 
    );
end entity dsp_gainstage;    


architecture IMP of dsp_gainstage is
    
begin

    y <= std_logic_vector( shift_right(signed(x)*signed(a), A_FRACTIONAL_BITS)(y'range) );
    
end IMP;

