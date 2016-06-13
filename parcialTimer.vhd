Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

-- o entrada hora_min indica se deve ir ate 23 ou 59
-- o result informa o valor em binario
-- dec0 e dec1 informam os digitos decimai, preparando para o display

 entity parcialTimer is
	 port (
		 clk,rst,enabled,hora_min: in std_logic;
		 result: out std_logic_vector(7 downto 0);
		 dec0,dec1: out std_logic_vector(3 downto 0)
		 );
 end parcialTimer; 
 
 architecture arq of parcialTimer is 
	
 begin	
	process(clk,rst)
		variable cont: integer range 0 to 60;
	begin
		if rst='1' then
			cont:=0;
		elsif clk'event and clk = '1' then
			if enabled='1' then
				cont:=cont+1;
				if (hora_min='0' and cont=24)or(hora_min='1' and cont=60) then
					cont:=0;
				end if;
			end if;
		end if;
		dec1<=conv_std_logic_vector(cont/10,4);
		dec0<=conv_std_logic_vector(cont mod 10,4);
		result<=conv_std_logic_vector(cont,8);
	end process;
 end arq;
