Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

 entity fpgaBombPC is
	 port (
		 clk,ativar: in std_logic;
		 enabledF0,rstF0: out std_logic   -- CTL
		 );
 end fpgaBombPC; 
 
architecture arq of fpgaBombPC is
	type STATE_TYPE is (estado_0, estado_1); 
	signal estado_atual, proximo_estado: STATE_TYPE;

begin

	process (clk)  
	begin   
		if (clk'EVENT and clk = '1') then    
			estado_atual <= proximo_estado;  
		end if;  
	end process;
	
	process (estado_atual)  
	begin   
		case estado_atual is      
			when estado_0  =>
				enabledF0<='1';
				rstF0<='0';
				if ativar='0' then
					proximo_estado <= estado_1;
				end if;
			when estado_1  =>
				enabledF0<='0';
				rstF0<='0';
		end case;  
	end process;
end arq;
