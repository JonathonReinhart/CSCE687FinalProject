library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-------------------------------------------------------------------------------------
--
--
-- Definition of Ports
-- FSL_Clk             : Synchronous clock
-- FSL_Rst           : System reset, should always come from FSL bus
-- FSL_S_Clk       : Slave asynchronous clock
-- FSL_S_Read      : Read signal, requiring next available input to be read
-- FSL_S_Data      : Input data
-- FSL_S_CONTROL   : Control Bit, indicating the input data are control word
-- FSL_S_Exists    : Data Exist Bit, indicating data exist in the input FSL bus
-- FSL_M_Clk       : Master asynchronous clock
-- FSL_M_Write     : Write signal, enabling writing to output FSL bus
-- FSL_M_Data      : Output data
-- FSL_M_Control   : Control Bit, indicating the output data are contol word
-- FSL_M_Full      : Full Bit, indicating output FSL bus is full
--
-------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Entity Section
------------------------------------------------------------------------------

entity audiofx_TB is
end audiofx_TB;

architecture BEHAVIORAL of audiofx_TB is

--------------
--- Components
    component audiofx is
        port 
        (
            FSL_Clk	: in	std_logic;
            FSL_Rst	: in	std_logic;
            
            FSL_S_Clk	: in	std_logic;
            FSL_S_Read	: out	std_logic;
            FSL_S_Data	: in	std_logic_vector(0 to 31);
            FSL_S_Control	: in	std_logic;
            FSL_S_Exists	: in	std_logic;
            
            FSL_M_Clk	: in	std_logic;
            FSL_M_Write	: out	std_logic;
            FSL_M_Data	: out	std_logic_vector(0 to 31);
            FSL_M_Control	: out	std_logic;
            FSL_M_Full	: in	std_logic
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
    signal FSL_Clk : std_logic;
    signal FSL_S_Clk : std_logic;       -- async clocks,
    signal FSL_M_Clk : std_logic;       -- (unused)
    signal FSL_Rst : std_logic;
    
    signal FSL_S_Data : std_logic_vector(0 to 31);  -- Data TO FSL device
    signal FSL_S_Control : std_logic;
    signal FSL_S_Exists	: std_logic;                -- Indicate to device that data exists on bus to be read
    signal FSL_M_Full : std_logic;                  -- Indicate to device that bus is full and can't be written
   
    -- Driven by FSL device (UUT 'out' ports)
    signal FSL_S_Read :	std_logic;                  -- Active when slave device reads from S FSL
    signal FSL_M_Write : std_logic;                 -- Active when slave writes to M FSL
    signal FSL_M_Data : std_logic_vector(0 to 31);  -- Data FROM FSL device
    signal FSL_M_Control : std_logic;
    
    -- Constants
    constant CLK_PER  : time := 10 ns;

begin

    CLKGEN_INST : clockgen
        generic map (
            PERIOD => CLK_PER
            )
        port map (
            clk => FSL_Clk,
            rst => FSL_Rst
            );

    UUT : audiofx
        port map (
            FSL_Clk         => FSL_Clk,
            FSL_Rst         => FSL_Rst,
            
            FSL_S_Clk       => FSL_S_Clk,
            FSL_S_Read      => FSL_S_Read,
            FSL_S_Data      => FSL_S_Data,
            FSL_S_Control   => FSL_S_Control,
            FSL_S_Exists    => FSL_S_Exists,
            
            FSL_M_Clk       => FSL_M_Clk,
            FSL_M_Write     => FSL_M_Write,
            FSL_M_Data      => FSL_M_Data,
            FSL_M_Control   => FSL_M_Control,
            FSL_M_Full      => FSL_M_Full
            );


    SIM : process is
    begin
        wait until rising_edge(FSL_Clk);

        FSL_S_Clk <= 'X';
        FSL_M_Clk <= 'X';
        
        FSL_S_Exists <= '1';
        FSL_M_Full <= '0';
        
        FSL_S_Data <= x"00000004";
        wait until FSL_M_Write = '1' and rising_edge(FSL_Clk);
        
        FSL_S_Data <= x"00000005";
        wait until FSL_M_Write = '1' and rising_edge(FSL_Clk);
        
        FSL_S_Data <= x"00000006";
        wait until FSL_M_Write = '1' and rising_edge(FSL_Clk);
        
        wait;

    end process;
   
   
   
end architecture BEHAVIORAL;
