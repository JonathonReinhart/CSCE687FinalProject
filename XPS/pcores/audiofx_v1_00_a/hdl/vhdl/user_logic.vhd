library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library proc_common_v3_00_a;
use proc_common_v3_00_a.proc_common_pkg.all;


--USER libraries added here

------------------------------------------------------------------------------
-- Entity section
------------------------------------------------------------------------------
-- Definition of Generics:
--   C_SLV_DWIDTH                 -- Slave interface data bus width
--   C_NUM_REG                    -- Number of software accessible registers
--
-- Definition of Ports:
--   Bus2IP_Clk                   -- Bus to IP clock
--   Bus2IP_Reset                 -- Bus to IP reset
--   Bus2IP_Data                  -- Bus to IP data bus
--   Bus2IP_BE                    -- Bus to IP byte enables
--   Bus2IP_RdCE                  -- Bus to IP read chip enable
--   Bus2IP_WrCE                  -- Bus to IP write chip enable
--   IP2Bus_Data                  -- IP to Bus data bus
--   IP2Bus_RdAck                 -- IP to Bus read transfer acknowledgement
--   IP2Bus_WrAck                 -- IP to Bus write transfer acknowledgement
--   IP2Bus_Error                 -- IP to Bus error response
------------------------------------------------------------------------------

entity user_logic is
  generic
  (
    -- ADD USER GENERICS BELOW THIS LINE ---------------
    --USER generics added here
    -- ADD USER GENERICS ABOVE THIS LINE ---------------

    -- DO NOT EDIT BELOW THIS LINE ---------------------
    -- Bus protocol parameters, do not add to or delete
    C_SLV_DWIDTH                   : integer              := 32;
    C_NUM_REG                      : integer              := 128
    -- DO NOT EDIT ABOVE THIS LINE ---------------------
  );
  port
  (
    -- ADD USER PORTS BELOW THIS LINE ------------------
    --USER ports added here
    -- ADD USER PORTS ABOVE THIS LINE ------------------

    -- DO NOT EDIT BELOW THIS LINE ---------------------
    -- Bus protocol ports, do not add to or delete
    Bus2IP_Clk                     : in  std_logic;
    Bus2IP_Reset                   : in  std_logic;
    Bus2IP_Data                    : in  std_logic_vector(0 to C_SLV_DWIDTH-1);
    Bus2IP_BE                      : in  std_logic_vector(0 to C_SLV_DWIDTH/8-1);
    Bus2IP_RdCE                    : in  std_logic_vector(0 to C_NUM_REG-1);
    Bus2IP_WrCE                    : in  std_logic_vector(0 to C_NUM_REG-1);
    IP2Bus_Data                    : out std_logic_vector(0 to C_SLV_DWIDTH-1);
    IP2Bus_RdAck                   : out std_logic;
    IP2Bus_WrAck                   : out std_logic;
    IP2Bus_Error                   : out std_logic
    -- DO NOT EDIT ABOVE THIS LINE ---------------------
  );

  attribute MAX_FANOUT : string;
  attribute SIGIS : string;

  attribute SIGIS of Bus2IP_Clk    : signal is "CLK";
  attribute SIGIS of Bus2IP_Reset  : signal is "RST";

end entity user_logic;

------------------------------------------------------------------------------
-- Architecture section
------------------------------------------------------------------------------

architecture IMP of user_logic is

  --USER signal declarations added here, as needed for user logic

  ------------------------------------------
  -- Signals for user logic slave model s/w accessible register example
  ------------------------------------------
  signal slv_reg0                       : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg1                       : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg2                       : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg3                       : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg4                       : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg5                       : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg6                       : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg7                       : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg8                       : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg9                       : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg10                      : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg11                      : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg12                      : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg13                      : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg14                      : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg15                      : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg16                      : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg17                      : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg18                      : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg19                      : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg20                      : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg21                      : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg22                      : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg23                      : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg24                      : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg25                      : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg26                      : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg27                      : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg28                      : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg29                      : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg30                      : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg31                      : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg32                      : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg33                      : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg34                      : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg35                      : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg36                      : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg37                      : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg38                      : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg39                      : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg40                      : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg41                      : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg42                      : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg43                      : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg44                      : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg45                      : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg46                      : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg47                      : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg48                      : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg49                      : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg50                      : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg51                      : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg52                      : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg53                      : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg54                      : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg55                      : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg56                      : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg57                      : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg58                      : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg59                      : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg60                      : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg61                      : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg62                      : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg63                      : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg64                      : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg65                      : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg66                      : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg67                      : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg68                      : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg69                      : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg70                      : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg71                      : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg72                      : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg73                      : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg74                      : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg75                      : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg76                      : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg77                      : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg78                      : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg79                      : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg80                      : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg81                      : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg82                      : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg83                      : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg84                      : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg85                      : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg86                      : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg87                      : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg88                      : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg89                      : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg90                      : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg91                      : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg92                      : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg93                      : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg94                      : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg95                      : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg96                      : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg97                      : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg98                      : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg99                      : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg100                     : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg101                     : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg102                     : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg103                     : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg104                     : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg105                     : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg106                     : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg107                     : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg108                     : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg109                     : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg110                     : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg111                     : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg112                     : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg113                     : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg114                     : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg115                     : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg116                     : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg117                     : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg118                     : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg119                     : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg120                     : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg121                     : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg122                     : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg123                     : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg124                     : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg125                     : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg126                     : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg127                     : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_reg_write_sel              : std_logic_vector(0 to 127);
  signal slv_reg_read_sel               : std_logic_vector(0 to 127);
  signal slv_ip2bus_data                : std_logic_vector(0 to C_SLV_DWIDTH-1);
  signal slv_read_ack                   : std_logic;
  signal slv_write_ack                  : std_logic;

begin

  --USER logic implementation added here

  ------------------------------------------
  -- Example code to read/write user logic slave model s/w accessible registers
  -- 
  -- Note:
  -- The example code presented here is to show you one way of reading/writing
  -- software accessible registers implemented in the user logic slave model.
  -- Each bit of the Bus2IP_WrCE/Bus2IP_RdCE signals is configured to correspond
  -- to one software accessible register by the top level template. For example,
  -- if you have four 32 bit software accessible registers in the user logic,
  -- you are basically operating on the following memory mapped registers:
  -- 
  --    Bus2IP_WrCE/Bus2IP_RdCE   Memory Mapped Register
  --                     "1000"   C_BASEADDR + 0x0
  --                     "0100"   C_BASEADDR + 0x4
  --                     "0010"   C_BASEADDR + 0x8
  --                     "0001"   C_BASEADDR + 0xC
  -- 
  ------------------------------------------
  slv_reg_write_sel <= Bus2IP_WrCE(0 to 127);
  slv_reg_read_sel  <= Bus2IP_RdCE(0 to 127);
  slv_write_ack     <= Bus2IP_WrCE(0) or Bus2IP_WrCE(1) or Bus2IP_WrCE(2) or Bus2IP_WrCE(3) or Bus2IP_WrCE(4) or Bus2IP_WrCE(5) or Bus2IP_WrCE(6) or Bus2IP_WrCE(7) or Bus2IP_WrCE(8) or Bus2IP_WrCE(9) or Bus2IP_WrCE(10) or Bus2IP_WrCE(11) or Bus2IP_WrCE(12) or Bus2IP_WrCE(13) or Bus2IP_WrCE(14) or Bus2IP_WrCE(15) or Bus2IP_WrCE(16) or Bus2IP_WrCE(17) or Bus2IP_WrCE(18) or Bus2IP_WrCE(19) or Bus2IP_WrCE(20) or Bus2IP_WrCE(21) or Bus2IP_WrCE(22) or Bus2IP_WrCE(23) or Bus2IP_WrCE(24) or Bus2IP_WrCE(25) or Bus2IP_WrCE(26) or Bus2IP_WrCE(27) or Bus2IP_WrCE(28) or Bus2IP_WrCE(29) or Bus2IP_WrCE(30) or Bus2IP_WrCE(31) or Bus2IP_WrCE(32) or Bus2IP_WrCE(33) or Bus2IP_WrCE(34) or Bus2IP_WrCE(35) or Bus2IP_WrCE(36) or Bus2IP_WrCE(37) or Bus2IP_WrCE(38) or Bus2IP_WrCE(39) or Bus2IP_WrCE(40) or Bus2IP_WrCE(41) or Bus2IP_WrCE(42) or Bus2IP_WrCE(43) or Bus2IP_WrCE(44) or Bus2IP_WrCE(45) or Bus2IP_WrCE(46) or Bus2IP_WrCE(47) or Bus2IP_WrCE(48) or Bus2IP_WrCE(49) or Bus2IP_WrCE(50) or Bus2IP_WrCE(51) or Bus2IP_WrCE(52) or Bus2IP_WrCE(53) or Bus2IP_WrCE(54) or Bus2IP_WrCE(55) or Bus2IP_WrCE(56) or Bus2IP_WrCE(57) or Bus2IP_WrCE(58) or Bus2IP_WrCE(59) or Bus2IP_WrCE(60) or Bus2IP_WrCE(61) or Bus2IP_WrCE(62) or Bus2IP_WrCE(63) or Bus2IP_WrCE(64) or Bus2IP_WrCE(65) or Bus2IP_WrCE(66) or Bus2IP_WrCE(67) or Bus2IP_WrCE(68) or Bus2IP_WrCE(69) or Bus2IP_WrCE(70) or Bus2IP_WrCE(71) or Bus2IP_WrCE(72) or Bus2IP_WrCE(73) or Bus2IP_WrCE(74) or Bus2IP_WrCE(75) or Bus2IP_WrCE(76) or Bus2IP_WrCE(77) or Bus2IP_WrCE(78) or Bus2IP_WrCE(79) or Bus2IP_WrCE(80) or Bus2IP_WrCE(81) or Bus2IP_WrCE(82) or Bus2IP_WrCE(83) or Bus2IP_WrCE(84) or Bus2IP_WrCE(85) or Bus2IP_WrCE(86) or Bus2IP_WrCE(87) or Bus2IP_WrCE(88) or Bus2IP_WrCE(89) or Bus2IP_WrCE(90) or Bus2IP_WrCE(91) or Bus2IP_WrCE(92) or Bus2IP_WrCE(93) or Bus2IP_WrCE(94) or Bus2IP_WrCE(95) or Bus2IP_WrCE(96) or Bus2IP_WrCE(97) or Bus2IP_WrCE(98) or Bus2IP_WrCE(99) or Bus2IP_WrCE(100) or Bus2IP_WrCE(101) or Bus2IP_WrCE(102) or Bus2IP_WrCE(103) or Bus2IP_WrCE(104) or Bus2IP_WrCE(105) or Bus2IP_WrCE(106) or Bus2IP_WrCE(107) or Bus2IP_WrCE(108) or Bus2IP_WrCE(109) or Bus2IP_WrCE(110) or Bus2IP_WrCE(111) or Bus2IP_WrCE(112) or Bus2IP_WrCE(113) or Bus2IP_WrCE(114) or Bus2IP_WrCE(115) or Bus2IP_WrCE(116) or Bus2IP_WrCE(117) or Bus2IP_WrCE(118) or Bus2IP_WrCE(119) or Bus2IP_WrCE(120) or Bus2IP_WrCE(121) or Bus2IP_WrCE(122) or Bus2IP_WrCE(123) or Bus2IP_WrCE(124) or Bus2IP_WrCE(125) or Bus2IP_WrCE(126) or Bus2IP_WrCE(127);
  slv_read_ack      <= Bus2IP_RdCE(0) or Bus2IP_RdCE(1) or Bus2IP_RdCE(2) or Bus2IP_RdCE(3) or Bus2IP_RdCE(4) or Bus2IP_RdCE(5) or Bus2IP_RdCE(6) or Bus2IP_RdCE(7) or Bus2IP_RdCE(8) or Bus2IP_RdCE(9) or Bus2IP_RdCE(10) or Bus2IP_RdCE(11) or Bus2IP_RdCE(12) or Bus2IP_RdCE(13) or Bus2IP_RdCE(14) or Bus2IP_RdCE(15) or Bus2IP_RdCE(16) or Bus2IP_RdCE(17) or Bus2IP_RdCE(18) or Bus2IP_RdCE(19) or Bus2IP_RdCE(20) or Bus2IP_RdCE(21) or Bus2IP_RdCE(22) or Bus2IP_RdCE(23) or Bus2IP_RdCE(24) or Bus2IP_RdCE(25) or Bus2IP_RdCE(26) or Bus2IP_RdCE(27) or Bus2IP_RdCE(28) or Bus2IP_RdCE(29) or Bus2IP_RdCE(30) or Bus2IP_RdCE(31) or Bus2IP_RdCE(32) or Bus2IP_RdCE(33) or Bus2IP_RdCE(34) or Bus2IP_RdCE(35) or Bus2IP_RdCE(36) or Bus2IP_RdCE(37) or Bus2IP_RdCE(38) or Bus2IP_RdCE(39) or Bus2IP_RdCE(40) or Bus2IP_RdCE(41) or Bus2IP_RdCE(42) or Bus2IP_RdCE(43) or Bus2IP_RdCE(44) or Bus2IP_RdCE(45) or Bus2IP_RdCE(46) or Bus2IP_RdCE(47) or Bus2IP_RdCE(48) or Bus2IP_RdCE(49) or Bus2IP_RdCE(50) or Bus2IP_RdCE(51) or Bus2IP_RdCE(52) or Bus2IP_RdCE(53) or Bus2IP_RdCE(54) or Bus2IP_RdCE(55) or Bus2IP_RdCE(56) or Bus2IP_RdCE(57) or Bus2IP_RdCE(58) or Bus2IP_RdCE(59) or Bus2IP_RdCE(60) or Bus2IP_RdCE(61) or Bus2IP_RdCE(62) or Bus2IP_RdCE(63) or Bus2IP_RdCE(64) or Bus2IP_RdCE(65) or Bus2IP_RdCE(66) or Bus2IP_RdCE(67) or Bus2IP_RdCE(68) or Bus2IP_RdCE(69) or Bus2IP_RdCE(70) or Bus2IP_RdCE(71) or Bus2IP_RdCE(72) or Bus2IP_RdCE(73) or Bus2IP_RdCE(74) or Bus2IP_RdCE(75) or Bus2IP_RdCE(76) or Bus2IP_RdCE(77) or Bus2IP_RdCE(78) or Bus2IP_RdCE(79) or Bus2IP_RdCE(80) or Bus2IP_RdCE(81) or Bus2IP_RdCE(82) or Bus2IP_RdCE(83) or Bus2IP_RdCE(84) or Bus2IP_RdCE(85) or Bus2IP_RdCE(86) or Bus2IP_RdCE(87) or Bus2IP_RdCE(88) or Bus2IP_RdCE(89) or Bus2IP_RdCE(90) or Bus2IP_RdCE(91) or Bus2IP_RdCE(92) or Bus2IP_RdCE(93) or Bus2IP_RdCE(94) or Bus2IP_RdCE(95) or Bus2IP_RdCE(96) or Bus2IP_RdCE(97) or Bus2IP_RdCE(98) or Bus2IP_RdCE(99) or Bus2IP_RdCE(100) or Bus2IP_RdCE(101) or Bus2IP_RdCE(102) or Bus2IP_RdCE(103) or Bus2IP_RdCE(104) or Bus2IP_RdCE(105) or Bus2IP_RdCE(106) or Bus2IP_RdCE(107) or Bus2IP_RdCE(108) or Bus2IP_RdCE(109) or Bus2IP_RdCE(110) or Bus2IP_RdCE(111) or Bus2IP_RdCE(112) or Bus2IP_RdCE(113) or Bus2IP_RdCE(114) or Bus2IP_RdCE(115) or Bus2IP_RdCE(116) or Bus2IP_RdCE(117) or Bus2IP_RdCE(118) or Bus2IP_RdCE(119) or Bus2IP_RdCE(120) or Bus2IP_RdCE(121) or Bus2IP_RdCE(122) or Bus2IP_RdCE(123) or Bus2IP_RdCE(124) or Bus2IP_RdCE(125) or Bus2IP_RdCE(126) or Bus2IP_RdCE(127);

  -- implement slave model software accessible register(s)
  SLAVE_REG_WRITE_PROC : process( Bus2IP_Clk ) is
  begin

    if Bus2IP_Clk'event and Bus2IP_Clk = '1' then
      if Bus2IP_Reset = '1' then
        slv_reg0 <= (others => '0');
        slv_reg1 <= (others => '0');
        slv_reg2 <= (others => '0');
        slv_reg3 <= (others => '0');
        slv_reg4 <= (others => '0');
        slv_reg5 <= (others => '0');
        slv_reg6 <= (others => '0');
        slv_reg7 <= (others => '0');
        slv_reg8 <= (others => '0');
        slv_reg9 <= (others => '0');
        slv_reg10 <= (others => '0');
        slv_reg11 <= (others => '0');
        slv_reg12 <= (others => '0');
        slv_reg13 <= (others => '0');
        slv_reg14 <= (others => '0');
        slv_reg15 <= (others => '0');
        slv_reg16 <= (others => '0');
        slv_reg17 <= (others => '0');
        slv_reg18 <= (others => '0');
        slv_reg19 <= (others => '0');
        slv_reg20 <= (others => '0');
        slv_reg21 <= (others => '0');
        slv_reg22 <= (others => '0');
        slv_reg23 <= (others => '0');
        slv_reg24 <= (others => '0');
        slv_reg25 <= (others => '0');
        slv_reg26 <= (others => '0');
        slv_reg27 <= (others => '0');
        slv_reg28 <= (others => '0');
        slv_reg29 <= (others => '0');
        slv_reg30 <= (others => '0');
        slv_reg31 <= (others => '0');
        slv_reg32 <= (others => '0');
        slv_reg33 <= (others => '0');
        slv_reg34 <= (others => '0');
        slv_reg35 <= (others => '0');
        slv_reg36 <= (others => '0');
        slv_reg37 <= (others => '0');
        slv_reg38 <= (others => '0');
        slv_reg39 <= (others => '0');
        slv_reg40 <= (others => '0');
        slv_reg41 <= (others => '0');
        slv_reg42 <= (others => '0');
        slv_reg43 <= (others => '0');
        slv_reg44 <= (others => '0');
        slv_reg45 <= (others => '0');
        slv_reg46 <= (others => '0');
        slv_reg47 <= (others => '0');
        slv_reg48 <= (others => '0');
        slv_reg49 <= (others => '0');
        slv_reg50 <= (others => '0');
        slv_reg51 <= (others => '0');
        slv_reg52 <= (others => '0');
        slv_reg53 <= (others => '0');
        slv_reg54 <= (others => '0');
        slv_reg55 <= (others => '0');
        slv_reg56 <= (others => '0');
        slv_reg57 <= (others => '0');
        slv_reg58 <= (others => '0');
        slv_reg59 <= (others => '0');
        slv_reg60 <= (others => '0');
        slv_reg61 <= (others => '0');
        slv_reg62 <= (others => '0');
        slv_reg63 <= (others => '0');
        slv_reg64 <= (others => '0');
        slv_reg65 <= (others => '0');
        slv_reg66 <= (others => '0');
        slv_reg67 <= (others => '0');
        slv_reg68 <= (others => '0');
        slv_reg69 <= (others => '0');
        slv_reg70 <= (others => '0');
        slv_reg71 <= (others => '0');
        slv_reg72 <= (others => '0');
        slv_reg73 <= (others => '0');
        slv_reg74 <= (others => '0');
        slv_reg75 <= (others => '0');
        slv_reg76 <= (others => '0');
        slv_reg77 <= (others => '0');
        slv_reg78 <= (others => '0');
        slv_reg79 <= (others => '0');
        slv_reg80 <= (others => '0');
        slv_reg81 <= (others => '0');
        slv_reg82 <= (others => '0');
        slv_reg83 <= (others => '0');
        slv_reg84 <= (others => '0');
        slv_reg85 <= (others => '0');
        slv_reg86 <= (others => '0');
        slv_reg87 <= (others => '0');
        slv_reg88 <= (others => '0');
        slv_reg89 <= (others => '0');
        slv_reg90 <= (others => '0');
        slv_reg91 <= (others => '0');
        slv_reg92 <= (others => '0');
        slv_reg93 <= (others => '0');
        slv_reg94 <= (others => '0');
        slv_reg95 <= (others => '0');
        slv_reg96 <= (others => '0');
        slv_reg97 <= (others => '0');
        slv_reg98 <= (others => '0');
        slv_reg99 <= (others => '0');
        slv_reg100 <= (others => '0');
        slv_reg101 <= (others => '0');
        slv_reg102 <= (others => '0');
        slv_reg103 <= (others => '0');
        slv_reg104 <= (others => '0');
        slv_reg105 <= (others => '0');
        slv_reg106 <= (others => '0');
        slv_reg107 <= (others => '0');
        slv_reg108 <= (others => '0');
        slv_reg109 <= (others => '0');
        slv_reg110 <= (others => '0');
        slv_reg111 <= (others => '0');
        slv_reg112 <= (others => '0');
        slv_reg113 <= (others => '0');
        slv_reg114 <= (others => '0');
        slv_reg115 <= (others => '0');
        slv_reg116 <= (others => '0');
        slv_reg117 <= (others => '0');
        slv_reg118 <= (others => '0');
        slv_reg119 <= (others => '0');
        slv_reg120 <= (others => '0');
        slv_reg121 <= (others => '0');
        slv_reg122 <= (others => '0');
        slv_reg123 <= (others => '0');
        slv_reg124 <= (others => '0');
        slv_reg125 <= (others => '0');
        slv_reg126 <= (others => '0');
        slv_reg127 <= (others => '0');
      else
        case slv_reg_write_sel is
          when "10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg0(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "01000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg1(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg2(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg3(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg4(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg5(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg6(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg7(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg8(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg9(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg10(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg11(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg12(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg13(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg14(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg15(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg16(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg17(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg18(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg19(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg20(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg21(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg22(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg23(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg24(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg25(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg26(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg27(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg28(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg29(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg30(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg31(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg32(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg33(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg34(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg35(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg36(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg37(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg38(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg39(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg40(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg41(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg42(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg43(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg44(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg45(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg46(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg47(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg48(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg49(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg50(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg51(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg52(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg53(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg54(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg55(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg56(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg57(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg58(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg59(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg60(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg61(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg62(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg63(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg64(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg65(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg66(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg67(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg68(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg69(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg70(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg71(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg72(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg73(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg74(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg75(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg76(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg77(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg78(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg79(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg80(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg81(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg82(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg83(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg84(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg85(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg86(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg87(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg88(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg89(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg90(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg91(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg92(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg93(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg94(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg95(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg96(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg97(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg98(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg99(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg100(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg101(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg102(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg103(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg104(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg105(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg106(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg107(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg108(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg109(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg110(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg111(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg112(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg113(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg114(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg115(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg116(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg117(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg118(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg119(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg120(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg121(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg122(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg123(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg124(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg125(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg126(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001" =>
            for byte_index in 0 to (C_SLV_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg127(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when others => null;
        end case;
      end if;
    end if;

  end process SLAVE_REG_WRITE_PROC;

  -- implement slave model software accessible register(s) read mux
  SLAVE_REG_READ_PROC : process( slv_reg_read_sel, slv_reg0, slv_reg1, slv_reg2, slv_reg3, slv_reg4, slv_reg5, slv_reg6, slv_reg7, slv_reg8, slv_reg9, slv_reg10, slv_reg11, slv_reg12, slv_reg13, slv_reg14, slv_reg15, slv_reg16, slv_reg17, slv_reg18, slv_reg19, slv_reg20, slv_reg21, slv_reg22, slv_reg23, slv_reg24, slv_reg25, slv_reg26, slv_reg27, slv_reg28, slv_reg29, slv_reg30, slv_reg31, slv_reg32, slv_reg33, slv_reg34, slv_reg35, slv_reg36, slv_reg37, slv_reg38, slv_reg39, slv_reg40, slv_reg41, slv_reg42, slv_reg43, slv_reg44, slv_reg45, slv_reg46, slv_reg47, slv_reg48, slv_reg49, slv_reg50, slv_reg51, slv_reg52, slv_reg53, slv_reg54, slv_reg55, slv_reg56, slv_reg57, slv_reg58, slv_reg59, slv_reg60, slv_reg61, slv_reg62, slv_reg63, slv_reg64, slv_reg65, slv_reg66, slv_reg67, slv_reg68, slv_reg69, slv_reg70, slv_reg71, slv_reg72, slv_reg73, slv_reg74, slv_reg75, slv_reg76, slv_reg77, slv_reg78, slv_reg79, slv_reg80, slv_reg81, slv_reg82, slv_reg83, slv_reg84, slv_reg85, slv_reg86, slv_reg87, slv_reg88, slv_reg89, slv_reg90, slv_reg91, slv_reg92, slv_reg93, slv_reg94, slv_reg95, slv_reg96, slv_reg97, slv_reg98, slv_reg99, slv_reg100, slv_reg101, slv_reg102, slv_reg103, slv_reg104, slv_reg105, slv_reg106, slv_reg107, slv_reg108, slv_reg109, slv_reg110, slv_reg111, slv_reg112, slv_reg113, slv_reg114, slv_reg115, slv_reg116, slv_reg117, slv_reg118, slv_reg119, slv_reg120, slv_reg121, slv_reg122, slv_reg123, slv_reg124, slv_reg125, slv_reg126, slv_reg127 ) is
  begin

    case slv_reg_read_sel is
      when "10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg0;
      when "01000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg1;
      when "00100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg2;
      when "00010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg3;
      when "00001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg4;
      when "00000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg5;
      when "00000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg6;
      when "00000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg7;
      when "00000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg8;
      when "00000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg9;
      when "00000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg10;
      when "00000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg11;
      when "00000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg12;
      when "00000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg13;
      when "00000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg14;
      when "00000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg15;
      when "00000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg16;
      when "00000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg17;
      when "00000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg18;
      when "00000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg19;
      when "00000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg20;
      when "00000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg21;
      when "00000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg22;
      when "00000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg23;
      when "00000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg24;
      when "00000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg25;
      when "00000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg26;
      when "00000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg27;
      when "00000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg28;
      when "00000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg29;
      when "00000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg30;
      when "00000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg31;
      when "00000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg32;
      when "00000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg33;
      when "00000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg34;
      when "00000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg35;
      when "00000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg36;
      when "00000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg37;
      when "00000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg38;
      when "00000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg39;
      when "00000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg40;
      when "00000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg41;
      when "00000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg42;
      when "00000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg43;
      when "00000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg44;
      when "00000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg45;
      when "00000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg46;
      when "00000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg47;
      when "00000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg48;
      when "00000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg49;
      when "00000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg50;
      when "00000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg51;
      when "00000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg52;
      when "00000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg53;
      when "00000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg54;
      when "00000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg55;
      when "00000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg56;
      when "00000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg57;
      when "00000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg58;
      when "00000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg59;
      when "00000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg60;
      when "00000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg61;
      when "00000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg62;
      when "00000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg63;
      when "00000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg64;
      when "00000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg65;
      when "00000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg66;
      when "00000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg67;
      when "00000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg68;
      when "00000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg69;
      when "00000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg70;
      when "00000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg71;
      when "00000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg72;
      when "00000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg73;
      when "00000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg74;
      when "00000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg75;
      when "00000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg76;
      when "00000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg77;
      when "00000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg78;
      when "00000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg79;
      when "00000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg80;
      when "00000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg81;
      when "00000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg82;
      when "00000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg83;
      when "00000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg84;
      when "00000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg85;
      when "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg86;
      when "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg87;
      when "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg88;
      when "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg89;
      when "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg90;
      when "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg91;
      when "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg92;
      when "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg93;
      when "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000" => slv_ip2bus_data <= slv_reg94;
      when "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000" => slv_ip2bus_data <= slv_reg95;
      when "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000" => slv_ip2bus_data <= slv_reg96;
      when "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000" => slv_ip2bus_data <= slv_reg97;
      when "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000" => slv_ip2bus_data <= slv_reg98;
      when "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000" => slv_ip2bus_data <= slv_reg99;
      when "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000" => slv_ip2bus_data <= slv_reg100;
      when "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000" => slv_ip2bus_data <= slv_reg101;
      when "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000" => slv_ip2bus_data <= slv_reg102;
      when "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000" => slv_ip2bus_data <= slv_reg103;
      when "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000" => slv_ip2bus_data <= slv_reg104;
      when "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000" => slv_ip2bus_data <= slv_reg105;
      when "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000" => slv_ip2bus_data <= slv_reg106;
      when "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000" => slv_ip2bus_data <= slv_reg107;
      when "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000" => slv_ip2bus_data <= slv_reg108;
      when "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000" => slv_ip2bus_data <= slv_reg109;
      when "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000" => slv_ip2bus_data <= slv_reg110;
      when "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000" => slv_ip2bus_data <= slv_reg111;
      when "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000" => slv_ip2bus_data <= slv_reg112;
      when "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000" => slv_ip2bus_data <= slv_reg113;
      when "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000" => slv_ip2bus_data <= slv_reg114;
      when "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000" => slv_ip2bus_data <= slv_reg115;
      when "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000" => slv_ip2bus_data <= slv_reg116;
      when "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000" => slv_ip2bus_data <= slv_reg117;
      when "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000" => slv_ip2bus_data <= slv_reg118;
      when "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000" => slv_ip2bus_data <= slv_reg119;
      when "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000" => slv_ip2bus_data <= slv_reg120;
      when "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000" => slv_ip2bus_data <= slv_reg121;
      when "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000" => slv_ip2bus_data <= slv_reg122;
      when "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000" => slv_ip2bus_data <= slv_reg123;
      when "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000" => slv_ip2bus_data <= slv_reg124;
      when "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100" => slv_ip2bus_data <= slv_reg125;
      when "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010" => slv_ip2bus_data <= slv_reg126;
      when "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001" => slv_ip2bus_data <= slv_reg127;
      when others => slv_ip2bus_data <= (others => '0');
    end case;

  end process SLAVE_REG_READ_PROC;

  ------------------------------------------
  -- Example code to drive IP to Bus signals
  ------------------------------------------
  IP2Bus_Data  <= slv_ip2bus_data when slv_read_ack = '1' else
                  (others => '0');

  IP2Bus_WrAck <= slv_write_ack;
  IP2Bus_RdAck <= slv_read_ack;
  IP2Bus_Error <= '0';

end IMP;
