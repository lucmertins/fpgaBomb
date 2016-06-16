Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

 entity fullTimer is
	 port (
		 clk,rst,enabled: in std_logic;
		 opc: in std_logic_vector(1 downto 0);         -- h/m/s  01/10
		 hora,min,seg: out std_logic_vector(7 downto 0);
		 dspH0,dspH1,dspM0,dspM1,dspS0,dspS1: out std_logic_vector(6 downto 0)
		 );
 end fullTimer; 
 
 architecture arq of fullTimer is 
	signal enabledH,enabledM,enabledS : std_logic;
	
	component parcialTimer 
		port(
		 clk,rst,enabled: in std_logic;
		 hora_min_coddec: in std_logic_vector(1 downto 0); 
		 result: out std_logic_vector(7 downto 0);
		 dec0,dec1: out std_logic_vector(3 downto 0);
		 dsp0,dsp1: out std_logic_vector(6 downto 0)
		 );
	end component;


 begin
	horacomp: parcialTimer port map(clk=>clk,rst=>rst,enabled=>enabledH,hora_min_coddec=>"01",result=>hora,dsp0=>dspH0,dsp1=>dspH1);
	mincomp: parcialTimer  port map(clk=>clk,rst=>rst,enabled=>enabledM,hora_min_coddec=>"10",result=>min,dsp0=>dspM0,dsp1=>dspM1);
	segcomp: parcialTimer  port map(clk=>clk,rst=>rst,enabled=>enabledS,hora_min_coddec=>"10",result=>seg,dsp0=>dspS0,dsp1=>dspS1);
	
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
