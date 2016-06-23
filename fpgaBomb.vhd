Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

 entity fpgaBomb is
	 port (
		 clk,btH,btM,btS,ativar: in std_logic;
		 oSenha: out std_logic_vector(7 downto 0);  -- temporario para avaliacao
		 enabledStatus: out std_logic_vector(2 downto 0);   -- temporario para avaliacao
		 dspH0,dspH1,dspM0,dspM1,dspS0,dspS1,dspP0,dspP1: out std_logic_vector(6 downto 0)
		 );
 end fpgaBomb; 
 
architecture arq of fpgaBomb is
	signal senabledStatus: std_logic_vector(2 downto 0);
	signal sSenha: std_logic_vector(7 downto 0);
	signal srst: std_logic;
	
 component fpgaBombPC is
	 port (
		 clk,ativar: in std_logic;
		 rst: out std_logic;
		 senha: in std_logic_vector(7 downto 0);
		 oSenha: out std_logic_vector(7 downto 0);  -- temporario para avaliacao
		 enabledStatus: out std_logic_vector(2 downto 0)   -- CTL
		 );
 end component; 

 component fpgaBombPO is
	 port (
		 clk,btH,btM,btS: in std_logic;
		 rst: in std_logic;                                -- CTL
		 enabledStatus: in std_logic_vector(2 downto 0);   -- CTL
		 zerado: out std_logic;
		 oSenha: out std_logic_vector(7 downto 0);
		 dspH0,dspH1,dspM0,dspM1,dspS0,dspS1,dspP0,dspP1: out std_logic_vector(6 downto 0)
		 );
 end component;
begin

enabledStatus<=senabledStatus;

controle: fpgaBombPC port map(clk => clk, ativar => ativar, enabledStatus=>senabledStatus, rst=>srst,senha=>ssenha,oSenha=>oSenha);
operacao: fpgaBombPO port map(clk => clk, btH=>btH, btM=>btM, btS=>btS, enabledStatus=>senabledStatus, rst=>srst,
										dspH0=>dspH0, dspH1=>dspH1, dspM0=>dspM0, dspM1=>dspM1, dspS0=>dspS0, dspS1=>dspS1,
										dspP0=>dspP0,dspP1=>dspP1,oSenha=>sSenha);
end arq;