Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

 entity fpgaBombPO is
	 port (
		 clk,btH,btM,btS: in std_logic;
		 rst: in std_logic;                                -- CTL
		 enabledStatus: in std_logic_vector(2 downto 0);   -- CTL
	    zerado: out std_logic;
		 oSenha: out std_logic_vector(7 downto 0);
		 dspH0,dspH1,dspM0,dspM1,dspS0,dspS1,dspP0,dspP1: out std_logic_vector(6 downto 0)
		 );
 end fpgaBombPO; 
 
architecture arq of fpgaBombPO is

signal clk05s,clk1s,srst: std_logic;
signal opctimer: std_logic_vector(1 downto 0);
signal btSenha: std_logic;
signal dH0,dH1,dM0,dM1,dS0,dS1,dP0,dP1,drH0,drH1,drM0,drM1,drS0,drS1: std_logic_vector(6 downto 0);
signal sHora,sMin,sSeg: std_logic_vector(7 downto 0);
signal sEnabledF0,sEnabledF1,sEnabledF2: std_logic;
signal soHora,soMin,soSeg,soSenha: std_logic_vector(7 downto 0);   

component divisorfrequencia is
	 port (
		 clk: in std_logic;   -- 50Mhz     
		 clock_0_5s: out std_logic;
		 clock_1s: out std_logic
		 );
 end component; 
 
component fullTimer is
	 port (
		 clk,rst,enabled: in std_logic;
		 opc: in std_logic_vector(1 downto 0);         -- h/m/s  01/10
		 hora,min,seg: out std_logic_vector(7 downto 0);
		 dspH0,dspH1,dspM0,dspM1,dspS0,dspS1: out std_logic_vector(6 downto 0)
		 );
 end component;

 component parcialTimer is
	 port (
		 clk,rst,enabled: in std_logic;
		 hora_min_coddec: in std_logic_vector(1 downto 0);   
		 result: out std_logic_vector(7 downto 0);
		 dsp0,dsp1: out std_logic_vector(6 downto 0)		 );
 end component; 
 
 component registrador8bit is
	port(
		in8 : in std_logic_vector (7 downto 0);
		rst,clk, load: in std_logic;
		out8,notout8: out std_logic_vector (7 downto 0)
		);
 end component;
 
 component HMSregressivo IS 
	port (
		clock, load : IN std_logic;
		carga_segundos, carga_minutos, carga_horas : IN std_logic_vector(7 downto 0);
		zerado: out std_logic;
		saida_segundos, saida_minutos, saida_horas : OUT std_logic_vector(7 downto 0);
		dspH0,dspH1,dspM0,dspM1,dspS0,dspS1: out std_logic_vector(6 downto 0)
	); 
 end component;

 begin

   freq1s: divisorfrequencia port map(clk => clk, clock_1s => clk1s,clock_0_5s=>clk05s);
	configTimer: fullTimer port map(clk=>clk,rst=>rst,enabled=>sEnabledF0,opc=>opctimer,
					dspH0=>dH0,dspH1=>dH1,dspM0=>dM0,dspM1=>dM1,dspS0=>dS0,dspS1=>dS1,hora=>sHora,min=>sMin,seg=>sSeg);
	saveHora:registrador8bit port map(clk=>clk,rst=>rst,load=>sEnabledF0,in8=>sHora,out8=>soHora);
	saveMin:registrador8bit port map(clk=>clk,rst=>rst,load=>sEnabledF0,in8=>sMin,out8=>soMin);
	saveSeg:registrador8bit port map(clk=>clk,rst=>rst,load=>sEnabledF0,in8=>sSeg,out8=>soSeg);
	configSenha: parcialTimer port map(clk=>clk,rst=>srst,enabled=>btSenha,hora_min_coddec=>"11",result=>oSenha,dsp0=>dP0,dsp1=>dP1);
	regressivo: HMSregressivo port map(clock=>clk,load=>sEnabledF2,carga_segundos=>soSeg,carga_minutos=>soMin,carga_horas=>soHora,zerado=>zerado,
	dspH0=>drH0,dspH1=>drH1,dspM0=>drM0,dspM1=>drM1,dspS0=>drS0,dspS1=>drS1);
	
	process (clk)  -- indica qual estrutura utiliza o display conforme o status
	begin
		if (clk'EVENT and clk = '1') then    
			if enabledStatus="000" then
				sEnabledF0<='1';
				sEnabledF1<='0';
				sEnabledF2<='0';
				srst<=rst;
				dspH0<=dH0;
				dspH1<=dH1;
				dspM0<=dM0;
				dspM1<=dM1;
				dspS0<=dS0;
				dspS1<=dS1;
				dspP0<="1111111";
				dspP1<="1111111";
			elsif enabledStatus="001" then
				sEnabledF0<='0';
				sEnabledF1<='1';
				sEnabledF2<='0';
				srst<=rst;
				dspH0<="1111111";
				dspH1<="1111111";
				dspM0<="1111111";
				dspM1<="1111111";
				dspS0<="1111111";
				dspS1<="1111111";
				dspP0<=dP0;
				dspP1<=dP1;
			elsif enabledStatus="010" then
				sEnabledF0<='0';
				sEnabledF1<='0';
				sEnabledF2<='1';
				srst<='1';
				dspH0<=drH0;
				dspH1<=drH1;
				dspM0<=drM0;
				dspM1<=drM1;
				dspS0<=drS0;
				dspS1<=drS1;
				dspP0<=dP0;
				dspP1<=dP1;
			elsif enabledStatus="011" then
				sEnabledF0<='0';
				sEnabledF1<='0';
				sEnabledF2<='0';
				srst<=rst;
				dspH0<=drH0;
				dspH1<=drH1;
				dspM0<=drM0;
				dspM1<=drM1;
				dspS0<=drS0;
				dspS1<=drS1;
				dspP0<=dP0;
				dspP1<=dP1;
			elsif enabledStatus="100" then
				sEnabledF0<='0';
				sEnabledF1<='0';
				sEnabledF2<='0';
				srst<=rst;
				dspH0<="1111111";
				dspH1<="1111111";
				dspM0<="1111111";
				dspM1<="1111111";
				dspS0<="1111111";
				dspS1<="1111111";
				dspP0<="1010101";
				dspP1<="1010101";
			elsif enabledStatus="101" then
				sEnabledF0<='0';
				sEnabledF1<='0';
				sEnabledF2<='0';
				srst<=rst;
				dspH0<="1000000";
				dspH1<="1000000";
				dspM0<="1000000";
				dspM1<="1000000";
				dspS0<="1000000";
				dspS1<="1000000";
				dspP0<="1000000";
				dspP1<="1000000";
			else
				sEnabledF0<='0';
				sEnabledF1<='0';
				sEnabledF2<='0';
				srst<=rst;
				dspH0<="1111111";
				dspH1<="1111111";
				dspM0<="1111111";
				dspM1<="1111111";
				dspS0<="1111111";
				dspS1<="1111111";
				dspP0<="1111111";
				dspP1<="1111111";
			end if;
		end if;  
   end process;
 
   process (clk,btH,btM,btS)    -- define qual push button esta em uso em cada fase
	begin   
		if enabledStatus = "000" then     -- status 0
			btSenha<='0';
			if btH='0' then
				opctimer<="01";
			elsif btM='0' then
				opctimer<="10";
			elsif btS='0' then
				opctimer<="11";
			else
				opctimer<="00";
			end if;
		elsif enabledStatus = "001" then   -- status 1
			btSenha<=not btS;
			opctimer<="00";
		elsif enabledStatus = "010" then   -- status 2
			btSenha<='0';
			opctimer<="00";
		elsif enabledStatus = "011" then   -- status 3
			btSenha<=not btS;
			opctimer<="00";
		else
			btSenha<='0';
			opctimer<="00";
		end if;  
   end process;


end arq;
