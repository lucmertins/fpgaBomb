Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

 entity fullTimer is
	 port (
		 clk,rst,enabled: in std_logic;
		 opc: in std_logic_vector(1 downto 0);         -- h/m/s  01/10/11
		 hora,min,seg: out std_logic_vector(7 downto 0);
		 dspH0,dspH1,dspM0,dspM1,dspS0,dspS1: out std_logic_vector(6 downto 0)
		 );
 end fullTimer; 
 
 architecture arq of fullTimer is 
	signal decH0,decH1,decM0,decM1,decS0,decS1 : std_logic_vector(3 downto 0);
	signal enabledH,enabledM,enabledS : std_logic;
	
	component parcialTimer 
		port(
		 clk,rst,enabled,hora_min: in std_logic;
		 result: out std_logic_vector(7 downto 0);
		 dec0,dec1: out std_logic_vector(3 downto 0)
		 );
	end component;

	component seg7 
		port(
		 entrada: in std_logic_vector(3 downto 0);
		 s: out std_logic_vector(6 downto 0)
		 );
	end component;
	
 begin
	horacomp: parcialTimer port map(clk=>clk,rst=>rst,enabled=>enabledH,hora_min=>'0',dec0=>decH0,dec1=>decH1,result=>hora);
	mincomp: parcialTimer  port map(clk=>clk,rst=>rst,enabled=>enabledM,hora_min=>'1',dec0=>decM0,dec1=>decM1,result=>min);
	segcomp: parcialTimer  port map(clk=>clk,rst=>rst,enabled=>enabledS,hora_min=>'1',dec0=>decS0,dec1=>decS1,result=>seg);
	displayH0: seg7 port map(entrada=>decH0,s=>dspH0);
	displayH1: seg7 port map(entrada=>decH1,s=>dspH1);
	displayM0: seg7 port map(entrada=>decM0,s=>dspM0);
	displayM1: seg7 port map(entrada=>decM1,s=>dspM1);
	displayS0: seg7 port map(entrada=>decS0,s=>dspS0);
	displayS1: seg7 port map(entrada=>decS1,s=>dspS1);	
	
	process(rst,clk)	
	begin
		if rst='1' then 
			enabledH<='0';
			enabledM<='0';
			enabledS<='0';
		elsif clk'EVENT and clk='1' and enabled='1' then
			case opc is
				when "00" =>
					enabledH<='0';
					enabledM<='0';
					enabledS<='0';
				when "01" =>   -- hora
					enabledH<='1';
					enabledM<='0';
					enabledS<='0';
				when "10" =>    --min
					enabledH<='0';
					enabledM<='1';
					enabledS<='0';
				when "11" =>    --seg
					enabledH<='0';
					enabledM<='0';
					enabledS<='1';
			end case;
		end if;		
	end process;
	
 end arq;
