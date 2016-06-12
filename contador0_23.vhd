Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

 entity contador0_23 is
	 port (
		 clk,rst,enabled: in std_logic;
		 result: out std_logic_vector(7 downto 0)
		 );
 end contador0_23; 
 
 architecture arq of contador0_23 is 
	
 begin	
	process(clk,rst)
	variable cont: integer range 0 to 23;
	begin
		if rst='1' then
			cont:=0;
		elsif clk'event and clk = '1' then
			if enabled='1' then
				cont:=cont+1;
				if cont=24 then
					cont:=0;
				end if;
			end if;
		end if;
		result<=conv_std_logic_vector(cont,8);
	end process;
 end arq;