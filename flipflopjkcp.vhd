LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_arith.all;
USE IEEE.std_logic_unsigned.all;

ENTITY flipflopjkcp IS 
	PORT (
		clock, j, k : IN std_logic;
		clear, preset : IN std_logic;
		q, q_not : OUT std_logic
	); 
END flipflopjkcp;

ARCHITECTURE arqflipflopjkcp OF flipflopjkcp IS

	signal tmp: std_logic;
	
BEGIN
	PROCESS(clock, clear, preset)
	BEGIN 
		IF clear = '1' THEN
			tmp <= '0';
		ELSIF preset = '1' THEN
			tmp <= '1';
		ELSIF clock'EVENT and clock='1' THEN   
			IF (j = '0' and k = '0') THEN
				tmp <= tmp;
			ELSIF (j = '0' and k = '1') THEN
				tmp <= '0';
			ELSIF (j = '1' and k = '0') THEN
				tmp <= '1';
			ELSIF (j = '1' and k = '1') THEN
				tmp <= not tmp;
			END IF;
		END IF;
		q <= tmp;
		q_not <= not tmp;
	END PROCESS;
END arqflipflopjkcp;