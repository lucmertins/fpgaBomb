Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

-- o entrada hora_min_coddec indica se deve ir ate 23 ou 59 ou 99. 01/10/11
-- o result informa o valor em binario
-- dec0 e dec1 informam os digitos decimai, preparando para o display

 entity parcialTimer is
	 port (
		 clk,rst,enabled: in std_logic;
		 hora_min_coddec: in std_logic_vector(1 downto 0);   
		 result: out std_logic_vector(7 downto 0);
		 dec0,dec1: out std_logic_vector(3 downto 0);
		 dsp0,dsp1: out std_logic_vector(6 downto 0)
		 );
 end parcialTimer; 
 
 architecture arq of parcialTimer is 

	signal sdec0,sdec1: std_logic_vector(3 downto 0);
 
	component seg7 
		port(
		 entrada: in std_logic_vector(3 downto 0);
		 s: out std_logic_vector(6 downto 0)
		 );
	end component;

 begin	
 
 	display0: seg7 port map(entrada=>sdec0,s=>dsp0);
	display1: seg7 port map(entrada=>sdec1,s=>dsp1);
 
	process(clk,rst)
		variable cont: integer range 0 to 100;
	begin
		if rst='1' then
			cont:=0;
		elsif clk'event and clk = '1' then
			if enabled='1' then
				cont:=cont+1;
				if (hora_min_coddec="01" and cont=24) or (hora_min_coddec="10" and cont=60) or (hora_min_coddec="11" and cont=100) then
					cont:=0;
				end if;
			end if;
		end if;
		sdec1<=conv_std_logic_vector(cont/10,4);
		sdec0<=conv_std_logic_vector(cont mod 10,4);
		dec1<=sdec1;
		dec0<=sdec0;
		result<=conv_std_logic_vector(cont,8);
	end process;
 end arq;
