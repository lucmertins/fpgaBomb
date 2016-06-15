Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

 entity fpgaBomb is
	 port (
		 clk,btH,btM,btS,ativar: in std_logic;
		 dspH0,dspH1,dspM0,dspM1,dspS0,dspS1: out std_logic_vector(6 downto 0)
		 );
 end fpgaBomb; 
 
architecture arq of fpgaBomb is
	signal senabledF0,srstF0: std_logic;
	
 component fpgaBombPC is
	 port (
		 clk,ativar: in std_logic;
		 enabledF0,rstF0: out std_logic   -- CTL
		 );
 end component; 

 component fpgaBombPO is
	 port (
		 clk,btH,btM,btS: in std_logic;
		 enabledF0,rstF0: in std_logic;   -- CTL
		 dspH0,dspH1,dspM0,dspM1,dspS0,dspS1: out std_logic_vector(6 downto 0)
		 );
 end component;
begin

controle: fpgaBombPC port map(clk => clk, ativar => ativar,enabledF0=>senabledF0,rstF0=>srstF0);
operacao: fpgaBombPO port map(clk => clk, btH=>btH,btM=>btM,btS=>btS,enabledF0=>senabledF0,rstF0=>srstF0,
										dspH0=>dspH0,dspH1=>dspH1,dspM0=>dspM0,dspM1=>dspM1,dspS0=>dspS0,dspS1=>dspS1);
end arq;