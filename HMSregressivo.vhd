LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_arith.all;
USE IEEE.std_logic_unsigned.all;

ENTITY HMSregressivo IS 
	PORT (
		enable_minutos_out : OUT std_logic;
	
		clock, load : IN std_logic;
		carga_segundos, carga_minutos, carga_horas : IN std_logic_vector(7 downto 0);
		saida_segundos, saida_minutos, saida_horas : OUT std_logic_vector(7 downto 0)
	); 
END HMSregressivo;

ARCHITECTURE arqHMSregressivo OF HMSregressivo IS

signal tmp_segundos, tmp_minutos, tmp_horas : std_logic_vector(7 downto 0);
signal enable_minutos : std_logic;
signal clock_minutos, clock_horas : std_logic;

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

BEGIN
	
	PROCESS(clock, load)
	BEGIN
		IF load='1' THEN
			clock_minutos <= clock;
			clock_horas <= clock;
		ELSIF clock'EVENT and clock='0' THEN
			IF tmp_segundos = "00000000" THEN
				enable_minutos <= '1';
				clock_minutos <= clock;
			ELSE
				enable_minutos <= '0';
				clock_minutos <= '0';
			END IF;
			IF tmp_minutos = "00000000" THEN
				clock_horas <= clock;
			ELSE
				clock_horas <= '0';
			END IF;
		END IF;
	END PROCESS;
	
	segundos: Regressivo60 port map(clock => clock, load => load, carga => carga_segundos, saida => tmp_segundos);
	minutos: Regressivo60 port map(clock => clock_minutos, load => load, carga => carga_minutos, saida => tmp_minutos);
	horas: Regressivo24 port map(clock => clock_horas, load => load, carga => carga_horas, saida => tmp_horas);
	
	saida_segundos <= tmp_segundos;
	saida_minutos <= tmp_minutos;
	saida_horas <= tmp_horas;
	
	enable_minutos_out <= enable_minutos;
	
END arqHMSregressivo;