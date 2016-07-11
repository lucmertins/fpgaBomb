Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

 entity divisorfrequencia is
	 port (
		 clk: in std_logic;   -- 50Mhz     
		 clock_0_5s: out std_logic;
		 clock_1s: out std_logic;
		 clock_config: out std_logic
		 );
 end divisorfrequencia; 

 architecture arq of divisorfrequencia is 

 constant TIMECONFIG    : integer := 5555555;
 constant TIMECONST0_5S : integer := 3333333;  
 constant TIMECONST1S   : integer := 16777216;   -- 25000000
 
 
  
 signal sclock_config: integer range 0 to 5555555 := 0;
 signal count0_5s: integer range 0 to 3333333 :=0;  -- 8388608
 signal count1s: integer range 0 to 16777216 := 0;  -- 25000000

 
 signal D0_Config: std_logic := '0';
 signal D1s: std_logic := '0';
 signal D0_5s: std_logic := '0';

 begin 
	 process (CLK)
	 begin
	 if (CLK'event and CLK = '1') then
	 	 if (count1s = TIMECONST1S) then
			count1s <= 0;
		 	D1s <= not D1s;
		 end if;
		 if (count0_5s = TIMECONST0_5S) then
			count0_5s <= 0;
		 	D0_5s <= not D0_5s;
		 end if;
		 if (sclock_config = TIMECONFIG) then
			sclock_config <= 0;
		 	D0_Config <= not D0_Config;
		 end if;
		 count0_5s <= count0_5s + 1;
		 count1s <= count1s + 1;
		 sclock_config<=sclock_config+1;
	 end if;
	 clock_0_5s<=D0_5s;
	 clock_1s <= D1s;
	 clock_config<=D0_Config;
 end process;

 end arq;