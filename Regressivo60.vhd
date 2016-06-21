LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_arith.all;
USE IEEE.std_logic_unsigned.all;

ENTITY Regressivo60 IS 
	PORT (
		clock, load : IN std_logic;
		carga : IN std_logic_vector(7 downto 0);
		saida : OUT std_logic_vector(7 downto 0)
	); 
END Regressivo60;

ARCHITECTURE arqRegressivo60 OF Regressivo60 IS

signal tmp, tmp_not : std_logic_vector(7 downto 0);
signal clear, preset : std_logic_vector(7 downto 0);

component flipflopjkcp
		port(
			clock, j, k : IN std_logic;
			clear, preset : IN std_logic;
			q, q_not : OUT std_logic
		);
end component;

BEGIN
		
	PROCESS(clock, load)
	BEGIN
		IF load = '1' THEN
			clear <= carga;
			preset <= not carga;
		ELSIF clock'EVENT and clock='0' THEN
			IF tmp_not = "00000000" THEN
				clear <= "00111011";
				preset <= "11000100";
			ELSE
				clear <= "00000000";
				preset <= "00000000";
			END IF;
		END IF;
	END PROCESS;
		
	flip01: flipflopjkcp port map(clock => clock, clear => clear(0), preset => preset(0), j => '1', k => '1', q => tmp(0), q_not => tmp_not(0));
	flip02: flipflopjkcp port map(clock => clock, clear => clear(1), preset => preset(1), j => tmp(0), k => tmp(0), q => tmp(1), q_not => tmp_not(1));
	flip03: flipflopjkcp port map(clock => clock, clear => clear(2), preset => preset(2), j => tmp(0) and tmp(1), k => tmp(0) and tmp(1), q => tmp(2), q_not => tmp_not(2));
	flip04: flipflopjkcp port map(clock => clock, clear => clear(3), preset => preset(3), j => tmp(0) and tmp(1) and tmp(2), k => tmp(0) and tmp(1) and tmp(2), q => tmp(3), q_not => tmp_not(3));
	flip05: flipflopjkcp port map(clock => clock, clear => clear(4), preset => preset(4), j => tmp(0) and tmp(1) and tmp(2) and tmp(3), k => tmp(0) and tmp(1) and tmp(2) and tmp(3), q => tmp(4), q_not => tmp_not(4));
	flip06: flipflopjkcp port map(clock => clock, clear => clear(5), preset => preset(5), j => tmp(0) and tmp(1) and tmp(2) and tmp(3) and tmp(4), k => tmp(0) and tmp(1) and tmp(2) and tmp(3) and tmp(4), q => tmp(5), q_not => tmp_not(5));
	flip07: flipflopjkcp port map(clock => clock, clear => clear(6), preset => preset(6), j => tmp(0) and tmp(1) and tmp(2) and tmp(3) and tmp(4) and tmp(5), k => tmp(0) and tmp(1) and tmp(2) and tmp(3) and tmp(4) and tmp(5), q => tmp(6), q_not => tmp_not(6));
	flip08: flipflopjkcp port map(clock => clock, clear => clear(7), preset => preset(7), j => tmp(0) and tmp(1) and tmp(2) and tmp(3) and tmp(4) and tmp(5) and tmp(6), k => tmp(0) and tmp(1) and tmp(2) and tmp(3) and tmp(4) and tmp(5) and tmp(6), q => tmp(7), q_not => tmp_not(7));
	
	saida <= tmp_not;
	
END arqRegressivo60;