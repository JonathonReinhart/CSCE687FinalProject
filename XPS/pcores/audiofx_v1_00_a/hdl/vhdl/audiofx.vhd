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

entity audiofx is
    port (
        FSL_Clk         : in  std_logic;
        FSL_Rst         : in  std_logic;

        FSL_S_Clk       : in  std_logic;
        FSL_S_Read      : out std_logic;
        FSL_S_Data      : in  std_logic_vector(0 to 31);
        FSL_S_Control   : in  std_logic;
        FSL_S_Exists    : in  std_logic;

        FSL_M_Clk       : in  std_logic;
        FSL_M_Write     : out std_logic;
        FSL_M_Data      : out std_logic_vector(0 to 31);
        FSL_M_Control   : out std_logic;
        FSL_M_Full      : in  std_logic
    );

    attribute SIGIS : string; 
    attribute SIGIS of FSL_Clk   : signal is "Clk"; 
    attribute SIGIS of FSL_S_Clk : signal is "Clk"; 
    attribute SIGIS of FSL_M_Clk : signal is "Clk"; 

end audiofx;


architecture EXAMPLE of audiofx is
   
    signal okay_to_transfer : std_logic;

begin

    -- Simply shove a sample through when it's available, and clear to send.
    okay_to_transfer <= FSL_S_Exists and not FSL_M_Full;
    
    FSL_S_Read <= okay_to_transfer;
    FSL_M_Data <= std_logic_vector(-signed(FSL_S_Data));
    FSL_M_Write <= okay_to_transfer;
    
   
end architecture EXAMPLE;
