library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity EnergyControl is port (
	CurrentGreater, CurrentEqual, CurrentSmaller : in std_logic;
	DoorWindowOpenControl : in std_logic_vector(2 downto 0); -- our push buttons
	-- remember it is active low, so 0 means door open
	FurnaceON: out std_logic; -- 1 if on
	SystemAtTemp: out std_logic;-- 1 if on
	ACON: out std_logic;-- 1 if on
	BlowerON: out std_logic;-- 1 if on
	DoorWindowOpenOutput: out std_logic_vector(2 downto 0)-- 1 if on
	
); 
end EnergyControl;


architecture Behaviour of EnergyControl is 

	signal isolatedSystem: std_logic; --- 1 if it is isolated 

begin
	-- hooking up the PB to LEDS to show if anything is open
	DoorWindowOpenOutput(0) <= not DoorWindowOpenControl(0);

	DoorWindowOpenOutput(1) <= not DoorWindowOpenControl(1);
	DoorWindowOpenOutput(2) <= not DoorWindowOpenControl(2);
	
	-- check if everything is shut
	isolatedSystem <= DoorWindowOpenControl(0) AND DoorWindowOpenControl(1) AND DoorWindowOpenControl(2);
	
	
	
	-- check if blower should be on
	BlowerON <= (CurrentGreater or CurrentSmaller) AND (isolatedSystem);
	
	-- check if AC should be on
	ACON <= (CurrentGreater)AND (isolatedSystem);
	
	-- check if Furnace should be on
	FurnaceON <= (CurrentSmaller) AND (isolatedSystem);
	
	--check if current temperature is equal 
	SystemAtTemp <= (CurrentEqual);
	
	
	
	

end Behaviour;