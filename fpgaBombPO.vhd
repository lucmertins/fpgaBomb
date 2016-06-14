Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

 entity fpgaBombPO is
	 port (
		 clk,btH,btM,btS: in std_logic;
		 enabledF0,rstF0: in std_logic;   -- CTL
		 dspH0,dspH1,dspM0,dspM1,dspS0,dspS1: out std_logic_vector(6 downto 0)
		 );
 end fpgaBombPO; 
 
architecture arq of fpgaBombPO is

signal clk1s: std_logic;
signal opctimer: std_logic_vector(1 downto 0);
signal dH0,dH1,dM0,dM1,dS0,dS1: std_logic_vector(6 downto 0);

component divisorfrequencia is
	 port (
		 clk: in std_logic;   -- 50Mhz    S
		 clock_1s: out std_logic
		 );
 end component; 
 
component fullTimer is
	 port (
		 clk,rst,enabled: in std_logic;
		 opc: in std_logic_vector(1 downto 0);         -- h/m/s  01/10/11
		 hora,min,seg: out std_logic_vector(7 downto 0);
		 dspH0,dspH1,dspM0,dspM1,dspS0,dspS1: out std_logic_vector(6 downto 0)
		 );
 end component;

 
 
 begin

   freq1s: divisorfrequencia port map(clk => clk, clock_1s => clk1s);
	configTimer: fullTimer port map(clk=>clk1s,rst=>rstF0,enabled=>enabledF0,opc=>opctimer,
					dspH0=>dH0,dspH1=>dH1,dspM0=>dM0,dspM1=>dM1,dspS0=>dS0,dspS1=>dS1);
	
	process (clk,enabledF0)  
	begin   
		if (clk'EVENT and clk = '1') then    
			if enabledF0='1' then
				dspH0<=dH0;
				dspH1<=dH1;
				dspM0<=dM0;
				dspM1<=dM1;
				dspS0<=dS0;
				dspS1<=dS1;
			else
				dspH0<="1111111";
				dspH1<="1111111";
				dspM0<="1111111";
				dspM1<="1111111";
				dspS0<="1111111";
				dspS1<="1111111";
			end if;
		end if;  
   end process;
 
   process (clk)  
	begin   
		if (clk'EVENT and clk = '1') then    
			if btH='0' then
				opctimer<="01";
			elsif btM='0' then
				opctimer<="10";
			elsif btS='0' then
				opctimer<="11";
			else
				opctimer<="00";
			end if;
		end if;  
   end process;


end arq;
