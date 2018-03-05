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


component segment7_mux port ( -- the mux to turn the 2 7-segment display on simultaneously
		clk	: in  std_logic :='0';
		DIN2	: in std_logic_vector(6 downto 0);
		DIN1	: in std_logic_vector(6 downto 0);
		DOUT	: out std_logic_vector(6 downto 0);
		DIG2	: out std_logic;
		DIG1	: out std_logic
		);
end component;

component EnergyControl is port (
	CurrentGreater, CurrentEqual, CurrentSmaller : in std_logic;
	DoorWindowOpenControl : in std_logic_vector(2 downto 0); -- our push buttons
	-- remember it is active low, so 0 means door open
	--Fdoor->pb2 window->pb1 Bdoor ->pb0
	--Fdoor-> led6 window->led5, Bdoor -> led4
	
	FurnaceON: out std_logic; -- 1 if on
	SystemAtTemp: out std_logic;-- 1 if on
	ACON: out std_logic;-- 1 if on
	BlowerON: out std_logic;-- 1 if on
	DoorWindowOpenOutput: out std_logic_vector(2 downto 0)-- 1 if on
	);
end component;


------------------------------------------------------------------
signal Current_Temp : std_logic_vector(3 downto 0); -- represents the current Temp
signal Desired_Temp : std_logic_vector(3 downto 0); -- represents the desired temp
signal GT, EQ, LT : std_logic;
signal sevenseg_Current_Temp, sevenseg_Desired_Temp : std_logic_vector(6 downto 0); -- the signal that goes directly into the sevenseg mux



begin
----- input from our switches for temperature -----------------
Current_Temp <= sw(7 downto 4); -- left side input
Desired_Temp <= sw(3 downto 0); -- right side input



---------------- comparing Current_Temp to Desired_Temp -----------------------------
	INST1: fourbitcomparator port map(Current_Temp(0),Current_Temp(1),Current_Temp(2),Current_Temp(3), 
	Desired_Temp(0),Desired_Temp(1),Desired_Temp(2),Desired_Temp(3),
	GT,EQ,LT); -- a bit inefficient in terms of amount if input, but does the job
				  -- could be cleaner


------------------DISPLAYING THE TEMPS--------------------
	INST2: SevenSegment port map(Current_Temp, sevenseg_Current_Temp);
	INST3: sevenSegment port map(Desired_Temp, sevenseg_Desired_Temp);
	INST4: segment7_mux port map (clkin_50	, sevenseg_Current_Temp, sevenseg_Desired_Temp, seg7_data, seg7_char1, seg7_char2);
------------------END OF DISPLAYING-----------------------

------------------CONTROLLING THE outputs using our Energy Control component------------------------------
	INST5: EnergyControl port map(GT,EQ,LT, pb(2 downto 0), leds(0), leds(1), leds(2), leds(3), leds(6 downto 4) );

--------------- 

end Energy_Monitor;

