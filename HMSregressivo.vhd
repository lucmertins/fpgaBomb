LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_arith.all;
USE IEEE.std_logic_unsigned.all;

ENTITY HMSregressivo IS 
	PORT (
		clock, load, enable : IN std_logic;
		carga_segundos, carga_minutos, carga_hrs : IN std_logic_vector(7 downto 0);
		saida_segundos, saida_minutos, saida_hrs : OUT std_logic_vector(7 downto 0);
		dspH0,dspH1,dspM0,dspM1,dspS0,dspS1: out std_logic_vector(6 downto 0);
		offtime : OUT std_logic
	); 
END HMSregressivo;

ARCHITECTURE arqHMSregressivo OF HMSregressivo IS

signal tmp_segundos, tmp_minutos, tmp_horas : std_logic_vector(7 downto 0);
signal enable_minutos, enable_horas, andamento  : std_logic;
signal fake_clock, fake_clock_m, fake_clock_h: std_logic;
signal sdec0,sdec1,mdec0,mdec1,hdec0,hdec1: std_logic_vector(3 downto 0);

component Regressivo60
		port(
			clock, load : IN std_logic;
			carga : IN std_logic_vector(7 downto 0);
			saida : OUT std_logic_vector(7 downto 0)
		);
end component;

component Regressivo24
		port(
			clock, load : IN std_logic;
			carga : IN std_logic_vector(7 downto 0);
			saida : OUT std_logic_vector(7 downto 0)
		);
end component;

component seg7 
		port(
		 entrada: in std_logic_vector(3 downto 0);
		 s: out std_logic_vector(6 downto 0)
		 );
end component;

BEGIN
	
	PROCESS(clock) -- controla os clocks fakes para ativar ou desativar a contagem
	BEGIN
	
		fake_clock <= (load and clock and andamento) or (enable and clock and andamento);
		fake_clock_m <= (load and clock and andamento) or (enable_minutos and andamento);
		fake_clock_h <= (load and clock and andamento) or (enable_horas and andamento);
			
		IF tmp_segundos = "00111011" THEN
			enable_minutos <= '1';
		ELSE
			enable_minutos <= '0';
		END IF;
		
		IF tmp_minutos = "00111011" THEN
			enable_horas <= '1';
		ELSE
			enable_horas <= '0';
		END IF;
		
		IF tmp_segundos = "00000000" and tmp_minutos = "00000000" and tmp_horas = "00000000" THEN
			andamento <= '0';
		ELSE
			andamento <= '1';
		END IF;
		
	END PROCESS;
	
	
	segundos: Regressivo60 port map(clock => fake_clock, load => load, carga => carga_segundos, saida => tmp_segundos);
	minutos: Regressivo60 port map(clock => fake_clock_m, load => load, carga => carga_minutos, saida => tmp_minutos);
	horas: Regressivo24 port map(clock => fake_clock_h, load => load, carga => carga_hrs, saida => tmp_horas);
	
	saida_segundos <= tmp_segundos;
	saida_minutos <= tmp_minutos;
	saida_hrs <= tmp_horas;
	
	offtime <= not andamento;
		
	displayS0: seg7 port map(entrada=>sdec0,s=>dspS0);
	displayS1: seg7 port map(entrada=>sdec1,s=>dspS1);
	displayM0: seg7 port map(entrada=>mdec0,s=>dspM0);
	displayM1: seg7 port map(entrada=>mdec1,s=>dspM1);
	displayH0: seg7 port map(entrada=>hdec0,s=>dspH0);
	displayH1: seg7 port map(entrada=>hdec1,s=>dspH1);
	
	sdec1<=conv_std_logic_vector(conv_integer(tmp_segundos)/10,4);
	sdec0<=conv_std_logic_vector(conv_integer(tmp_segundos) mod 10,4);
	mdec1<=conv_std_logic_vector(conv_integer(tmp_minutos)/10,4);
	mdec0<=conv_std_logic_vector(conv_integer(tmp_minutos) mod 10,4);
	hdec1<=conv_std_logic_vector(conv_integer(tmp_horas)/10,4);
	hdec0<=conv_std_logic_vector(conv_integer(tmp_horas) mod 10,4);

		
END arqHMSregressivo;