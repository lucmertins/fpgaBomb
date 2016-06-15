Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

 entity divisorfrequencia is
	 port (
		 clk: in std_logic;   -- 50Mhz     50000000 ciclos para 1  	seg
		 clock_1s: out std_logic
		 );
 end divisorfrequencia; 

 architecture arq of divisorfrequencia is 

 constant TIMECONST1S : integer := 50000000;

 signal count1s: integer range 0 to 50000000 := 0;

 signal D1s: std_logic := '0';

 begin 
	 process (CLK)
	 begin
	 if (CLK'event and CLK = '1') then
	 	 if (count1s = TIMECONST1S) then
			count1s <= 0;
		 	D1s <= not D1s;
		 end if;
		 count1s <= count1s + 1;
	 end if;

  clock_1s <= D1s;
 end process;

 end arq;