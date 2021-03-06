LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_arith.all;
USE IEEE.std_logic_unsigned.all;

ENTITY regressivoHMS IS 
	PORT (
		clk,rst,ld,enbl: in std_logic;
		offtime: out std_logic;
		iHora,iMin,iSeg: in std_logic_vector(7 downto 0);
		oHora,oMin,oSeg: out std_logic_vector(7 downto 0);
		dspH0,dspH1,dspM0,dspM1,dspS0,dspS1: out std_logic_vector(6 downto 0)
	); 
END regressivoHMS;

 architecture arq of regressivoHMS is 
 
component regressivo8bits IS 
	PORT (
		clk,rst,ld,enbl : in std_logic;
		input: in std_logic_vector(7 downto 0);
		result: out std_logic_vector(7 downto 0)
	); 
END component;
component flipflopjkcp IS 
	PORT (
		clock, j, k : IN std_logic;
		clear, preset : IN std_logic;
		q, q_not : OUT std_logic
	); 
	end component;
 
component seg7 
		port(
		 entrada: in std_logic_vector(3 downto 0);
		 s: out std_logic_vector(6 downto 0)
		 );
end component;

 signal sclkmin,sclkhora: std_logic;
 signal sHora,sMin,sSeg: std_logic_vector(7 downto 0);
 signal sdec0,sdec1,mdec0,mdec1,hdec0,hdec1: std_logic_vector(3 downto 0);


 
 begin
 
 hora: regressivo8bits port map(clk=>sclkhora,rst=>rst,ld=>ld,enbl=>enbl,input=>iHora,result=>sHora);
 min: regressivo8bits port map(clk=>sclkmin,rst=>rst,ld=>ld,enbl=>enbl,input=>iMin,result=>sMin);
 seg: regressivo8bits port map(clk=>clk,rst=>rst,ld=>ld,enbl=>enbl,input=>iSeg,result=>sSeg);
 
 oHora<=sHora;
 oMin<=sMin;
 oSeg<=sSeg;
 
 oHora<=sHora;
 oMin<=sMin;
 oSeg<=sSeg;
 
 process(clk)
 begin
	offtime<='0';
	sclkmin<='0';
	sclkhora<='0';
	if sSeg="00000000" and sMin="00000000" and sHora="00000000" then
		offtime<='1';
	else
		if sSeg="00111011" then
			sclkmin<='1';
		end if;
		if sMin="00111011" then
			sclkhora<='1';
		end if;
	end if; 
 end process;
 
 		
	displayS0: seg7 port map(entrada=>sdec0,s=>dspS0);
	displayS1: seg7 port map(entrada=>sdec1,s=>dspS1);
	displayM0: seg7 port map(entrada=>mdec0,s=>dspM0);
	displayM1: seg7 port map(entrada=>mdec1,s=>dspM1);
	displayH0: seg7 port map(entrada=>hdec0,s=>dspH0);
	displayH1: seg7 port map(entrada=>hdec1,s=>dspH1);
	
	sdec1<=conv_std_logic_vector(conv_integer(sSeg)/10,4);
	sdec0<=conv_std_logic_vector(conv_integer(sSeg) mod 10,4);
	mdec1<=conv_std_logic_vector(conv_integer(sMin)/10,4);
	mdec0<=conv_std_logic_vector(conv_integer(sMin) mod 10,4);
	hdec1<=conv_std_logic_vector(conv_integer(sHora)/10,4);
	hdec0<=conv_std_logic_vector(conv_integer(sHora) mod 10,4);

 
 end arq;