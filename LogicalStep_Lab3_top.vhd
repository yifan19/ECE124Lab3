library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity LogicalStep_Lab3_top is port (
   clkin_50		: in	std_logic;
	pb				: in	std_logic_vector(3 downto 0);
 	sw   			: in  std_logic_vector(7 downto 0); -- The switch inputs
   leds			: out std_logic_vector(7 downto 0);	-- for displaying the switch content
   seg7_data 	: out std_logic_vector(6 downto 0); -- 7-bit outputs to a 7-segment
	seg7_char1  : out	std_logic;							-- seg7 digi selectors
	seg7_char2  : out	std_logic							-- seg7 digi selectors
	
); 
end LogicalStep_Lab3_top;

architecture Energy_Monitor of LogicalStep_Lab3_top is
--
-- Components Used
------------------------------------------------------------------- 
component fourbitcomparator port(

	bitA0, bitA1, bitA2, bitA3, bitB0, bitB1, bitB2, bitB3 : in std_logic;
	
	AGTB	: out std_logic;
	AEQB	: out std_logic;
	ALTB	: out std_logic

	);
end component;


component SevenSegment port ( -- converts a 4-bit number to 7 bit-number to be use for the 7-segment display
   hex   		:  in  std_logic_vector(3 downto 0);   -- The 4 bit data to be displayed
   sevenseg 	:  out std_logic_vector(6 downto 0)    -- 7-bit outputs to a 7-segment
   ); 
end component;


component segment7_mux port ( 
		clk	: in  std_logic :='0';
		DIN2	: in std_logic_vector(6 downto 0);
		DIN1	: in std_logic_vector(6 downto 0);
		DOUT	: out std_logic_vector(6 downto 0);
		DIG2	: out std_logic;
		DIG1	: out std_logic
		);
end component;
	
------------------------------------------------------------------
signal input1 : std_logic_vector(3 downto 0);
signal input2 : std_logic_vector(3 downto 0);
signal GT, EQ, LT : std_logic;
signal sevenseg_input1, sevenseg_input2 : std_logic_vector(6 downto 0);

begin

input1 <= sw(7 downto 4);
input2 <= sw(3 downto 0);

--GT <=leds(2);
--EQ <=leds(1);
--LT <=leds(0);


INST1: fourbitcomparator port map(input1(0),input1(1),input1(2),input1(3), input2(0),input2(1),input2(2),input2(3),leds(2),leds(1),leds(0));
INST2: SevenSegment port map(input1, sevenseg_input1);
INST3: sevenSegment port map(input2, sevenseg_input2);

INST4: segment7_mux port map (clkin_50	, sevenseg_input1, sevenseg_input2, seg7_data, seg7_char1, seg7_char2);


end Energy_Monitor;

