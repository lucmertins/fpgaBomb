LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_arith.all;
USE IEEE.std_logic_unsigned.all;


entity registrador8bit is
	port(
		in8 : in std_logic_vector (7 downto 0);
		rst,clk,load : in std_logic;
		out8,notout8: out std_logic_vector (7 downto 0)
);
end registrador8bit;

architecture arch of registrador8bit is
	signal saida : std_logic_vector(7 downto 0);
begin
	
	process(rst,clk)
	begin
		if rst='1' then 
			saida<="00000000";
		elsif clk'EVENT and clk='1' and load='1' then
			saida<=in8;
		end if;	
	end process;
	
	out8<=saida;
	notout8<=not saida;

end arch;