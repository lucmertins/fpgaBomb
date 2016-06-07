Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

 entity divisorfrequencia is
	 port (
		 clk: in std_logic;
		 clock_out: out std_logic
		 );
 end divisorfrequencia; 

 architecture arq of divisorfrequencia is 

 constant TIMECONST : integer := 15000000;

 signal count1: integer range 0 to 15000000 := 0;

 signal D: std_logic := '0';

 begin 
	 process (CLK)
	 begin
	 if (CLK'event and CLK = '1') then
	 	 if (count1 = TIMECONST) then
			count1 <= 0;
		 	D <= not D;
		 end if;
		 count1 <= count1 + 1;
	 end if;

  clock_out <= D;
 end process;

 end arq;
