-------------------------------------------------------------------------------
-- MODULE NAME:  LED_BRIGHTNESS
--
-- DESCRIPTION:  This design uses a COUNTER to change the duty cycle of a PWM
--				 	  signal. These PWM signals are used to change the brightness
-- 				  of the LED. The higher the duty cycle the brighter the LED
--				 	  becomes. A signal with 100% duty cycle would make the LED the
--				 	  brightest possible, this is the same as driving the line high.
--
--				 	Changing the LED_MAX_COUNT determine how
--				 	long it takes the LED's to reach maximum brightness.
-------------------------------------------------------------------------------

-- Libraries
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
use IEEE.math_real.ALL;

-- Entity
entity LED_BRIGHTNESS is
	Generic (
		INPUT_CLK		: integer := 25000000; -- 50 MHz default
		NUM_LEDS 		: integer := 8);		
	Port (
		Led_Out			: out std_logic_vector(NUM_LEDS - 1 downto 0);
		Clk				: in std_logic;
		Enable			: in std_logic);	-- Active Low
end LED_BRIGHTNESS;

-- Architecture
architecture behavior of LED_BRIGHTNESS is

-- Components
-- Pulse Width Modulation Design
component PWM
	Generic (
		BIT_DEPTH	: integer := 8;
		INPUT_CLK	: integer := 25000000; -- 50MHz
		FREQ		: integer := 25); -- 50Hz
	Port (
		Pwm_Out 	: out std_logic;
		Duty_Cycle	: in std_logic_vector(BIT_DEPTH - 1 downto 0);
		Clk			: in std_logic;
		Enable		: in std_logic);
end component PWM;

-- COUNTER
component COUNTER
	Generic (
		MAX_VAL 		: integer := 2**30;
		SYNCH_Reset		: boolean := true);
	Port (
		Max_Count 		: out std_logic;
		Clk 			: in std_logic;
		Reset 			: in std_logic);
end component COUNTER;

-- Signals and Constants
-- 85 is from taking 255, the max PWM value, and dividing by 3 seconds
constant LED_MAX_COUNT	: integer := INPUT_CLK / 85;
constant SYN_RESET		: boolean := true;
constant MAX_LED_DUTY	: integer := 255;

signal led_max_cnt		: std_logic := '0';
signal led_pwm_reg		: std_logic := '0';

signal led_duty_cycle	: unsigned(7 downto 0) := (others => '0');

begin
	-- Assign Output
	Led_Out <= (others => led_pwm_reg);
	
	-- LED Counter
	LED_COUNTER: COUNTER 
		generic map(LED_MAX_COUNT, SYN_RESET) 
		port map(led_max_cnt, Clk,  Enable);
	
		
	-- LED PWM Signal Generator (8 bit, 50Hz)
	LED_PWM: PWM
		generic map(8, INPUT_CLK, 25)
		port map(led_pwm_reg, std_logic_vector(led_duty_cycle), Clk, NOT Enable);
		
	
	-- LED PWM Count update Process
	Led_Count_Proc: process(Clk)
	begin
		if rising_edge(Clk) then
			if (led_duty_cycle = MAX_LED_DUTY) then
				led_duty_cycle <= (others => '0');
			elsif (led_max_cnt = '1') then
				led_duty_cycle <= led_duty_cycle + 1;
			end if;
		end if;
	end process Led_Count_Proc;
	
	
	
end behavior;