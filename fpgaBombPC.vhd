Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

 entity fpgaBombPC is
	 port (
		 clk,ativar: in std_logic;
		 rst: out std_logic;
		 enabledStatus: out std_logic_vector(1 downto 0)
		 );
 end fpgaBombPC; 
 
architecture arq of fpgaBombPC is
	type STATE_TYPE is (estado_0, estado_1,estado_2); 
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
				enabledStatus<="00";
				if ativar='0' then
					proximo_estado <= estado_1;
				else
					proximo_estado <= estado_0;
				end if;
			when estado_1  =>
				enabledStatus<="01";
				if ativar='0' then
					proximo_estado <= estado_2;
				else
					proximo_estado <= estado_1;
				end if;
			when estado_2  =>
				enabledStatus<="10";
				proximo_estado <= estado_2;

		end case;  
	end process;
end arq;
