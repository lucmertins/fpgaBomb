LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_arith.all;
USE IEEE.std_logic_unsigned.all;

ENTITY regressivo8bits IS 
	PORT (
		clk,rst,ld,enbl : in std_logic;
		input: in std_logic_vector(7 downto 0);
		zero: out std_logic;
		result: out std_logic_vector(7 downto 0)
	); 
END regressivo8bits;

architecture arq of regressivo8bits is 
 
 component flipflopjkcp IS 
	PORT (
		clock, j, k : IN std_logic;
		clear, preset : IN std_logic;
		q, q_not : OUT std_logic
	); 
	end component;

	signal sout,snout,sprs,srst : std_logic_vector (7 downto 0);
	signal sclk,senbl,srstenbl: std_logic;
	
	begin
		ffenbl: flipflopjkcp port map(clock=>clk,j=>enbl,k=>not enbl,clear=>srstenbl,preset=>'0',q=>senbl);
	
		ff0: flipflopjkcp port map(clock=>sclk   ,j=>'1',k=>'1',clear=>srst(0),preset=>sprs(0),q=>sout(0));
		ff1: flipflopjkcp port map(clock=>sout(0),j=>'1',k=>'1',clear=>srst(1),preset=>sprs(1),q=>sout(1));
		ff2: flipflopjkcp port map(clock=>sout(1),j=>'1',k=>'1',clear=>srst(2),preset=>sprs(2),q=>sout(2));
		ff3: flipflopjkcp port map(clock=>sout(2),j=>'1',k=>'1',clear=>srst(3),preset=>sprs(3),q=>sout(3));
		ff4: flipflopjkcp port map(clock=>sout(3),j=>'1',k=>'1',clear=>srst(4),preset=>sprs(4),q=>sout(4));
		ff5: flipflopjkcp port map(clock=>sout(4),j=>'1',k=>'1',clear=>srst(5),preset=>sprs(5),q=>sout(5));
		ff6: flipflopjkcp port map(clock=>sout(5),j=>'1',k=>'1',clear=>srst(6),preset=>sprs(6),q=>sout(6));
		ff7: flipflopjkcp port map(clock=>sout(6),j=>'1',k=>'1',clear=>srst(7),preset=>sprs(7),q=>sout(7));

		srstenbl<=rst or not enbl;
		sclk<=clk and senbl; 
		result<=sout;

		-- reset ou load ou virou 
		
		--00111011     59d
		--11111111
		--00000000
		
		srst(0)<=rst or (ld and not input(0));
		srst(1)<=rst or (ld and not input(1)); 
		srst(2)<=rst or (ld and not input(2)) or ((sout(0) and sout(1) and sout(2) and sout(3) and sout(4) and sout(5) and sout(6) and sout(7))and clk);
		srst(3)<=rst or (ld and not input(3));
		srst(4)<=rst or (ld and not input(4));
		srst(5)<=rst or (ld and not input(5));
		srst(6)<=rst or (ld and not input(6)) or ((sout(0) and sout(1) and sout(2) and sout(3) and sout(4) and sout(5) and sout(6) and sout(7))and clk);
		srst(7)<=rst or (ld and not input(7)) or ((sout(0) and sout(1) and sout(2) and sout(3) and sout(4) and sout(5) and sout(6) and sout(7))and clk);

		sprs(0)<=(ld and input(0)) or ((sout(0) and sout(1) and sout(2) and sout(3) and sout(4) and sout(5) and sout(6) and sout(7))and clk);
		sprs(1)<=(ld and input(1)) or ((sout(0) and sout(1) and sout(2) and sout(3) and sout(4) and sout(5) and sout(6) and sout(7))and clk);
		sprs(2)<=(ld and input(2));
		sprs(3)<=(ld and input(3)) or ((sout(0) and sout(1) and sout(2) and sout(3) and sout(4) and sout(5) and sout(6) and sout(7))and clk);
		sprs(4)<=(ld and input(4)) or ((sout(0) and sout(1) and sout(2) and sout(3) and sout(4) and sout(5) and sout(6) and sout(7))and clk);
		sprs(5)<=(ld and input(5)) or ((sout(0) and sout(1) and sout(2) and sout(3) and sout(4) and sout(5) and sout(6) and sout(7))and clk);
		sprs(6)<=(ld and input(6));
		sprs(7)<=(ld and input(7));
		
		process (clk,rst,ld)
		begin
			if rst='1' then 
				zero<='1';
			elsif ld='1' and sprs="00000000" then
					zero<='1';
			elsif ld='1' then
					zero<='0';
			elsif clk'event and clk = '0' then
				if sout="00000000" then 
					zero<='1';
				else
					zero<='0';
				end if;
			end if;
		end process;
	end arq;