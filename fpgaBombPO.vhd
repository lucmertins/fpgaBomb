Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

 entity fpgaBombPO is
	 port (
		 clk,btH,btM,btS: in std_logic;
		 rst: in std_logic;                                -- CTL
		 enabledStatus: in std_logic_vector(1 downto 0);   -- CTL
		 oHora,oMin,oSeg,oSenha: out std_logic_vector(7 downto 0);    --- temporariamente para avaliar no grafico
		 dspH0,dspH1,dspM0,dspM1,dspS0,dspS1: out std_logic_vector(6 downto 0)
		 );
 end fpgaBombPO; 
 
architecture arq of fpgaBombPO is

signal clk1s: std_logic;
signal opctimer: std_logic_vector(1 downto 0);
signal btSenha: std_logic;
signal dH0,dH1,dM0,dM1,dS0,dS1,dSenha0,dSenha1: std_logic_vector(6 downto 0);
signal sHora,sMin,sSeg,sSenha: std_logic_vector(7 downto 0);
signal sEnabledF0,sEnabledF1: std_logic;


component divisorfrequencia is
	 port (
		 clk: in std_logic;   -- 50Mhz    S
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
 
 begin

   freq1s: divisorfrequencia port map(clk => clk, clock_1s => clk1s);
	configTimer: fullTimer port map(clk=>clk,rst=>rst,enabled=>sEnabledF0,opc=>opctimer,
					dspH0=>dH0,dspH1=>dH1,dspM0=>dM0,dspM1=>dM1,dspS0=>dS0,dspS1=>dS1,hora=>sHora,min=>sMin,seg=>sSeg);
	saveHora:registrador8bit port map(clk=>clk,rst=>rst,load=>sEnabledF0,in8=>sHora,out8=>oHora);
	saveMin:registrador8bit port map(clk=>clk,rst=>rst,load=>sEnabledF0,in8=>sMin,out8=>oMin);
	saveSeg:registrador8bit port map(clk=>clk,rst=>rst,load=>sEnabledF0,in8=>sSeg,out8=>oSeg);
	configSenha: parcialTimer port map(clk=>clk,rst=>rst,enabled=>btSenha,hora_min_coddec=>"11",dsp0=>dsenha0,dsp1=>dsenha1);
	saveSenha:registrador8bit port map(clk=>clk,rst=>rst,load=>sEnabledF1,in8=>sSenha,out8=>oSenha);

	
	process (clk)  -- indica qual estrutura utiliza o display conforme o status
	begin
		if (clk'EVENT and clk = '1') then    
			if enabledStatus="00" then
				sEnabledF0<='1';
				sEnabledF1<='0';
				dspH0<=dH0;
				dspH1<=dH1;
				dspM0<=dM0;
				dspM1<=dM1;
				dspS0<=dS0;
				dspS1<=dS1;
			elsif enabledStatus="01" then
				sEnabledF0<='0';
				sEnabledF1<='1';
				dspH0<="1111111";
				dspH1<="1111111";
				dspM0<="1111111";
				dspM1<="1111111";
				dspS0<=dsenha0;
				dspS1<=dsenha1;
			else
				sEnabledF0<='0';
				sEnabledF1<='0';
				dspH0<="1111111";
				dspH1<="1111111";
				dspM0<="1111111";
				dspM1<="1111111";
				dspS0<="1111111";
				dspS1<="1111111";
			end if;
		end if;  
   end process;
 
   process (btH,btM,btS)    -- define qual push button esta em uso em cada fase
	begin   
		if enabledStatus = "00" then     -- status 0
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
		elsif enabledStatus = "01" then   -- status 1
				btSenha<=not btH;
				opctimer<="00";
		else
			btSenha<='0';
			opctimer<="00";
		end if;  
   end process;


end arq;
