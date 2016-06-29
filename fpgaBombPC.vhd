Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

 entity fpgaBombPC is
	 port (
		 clk,ativar,offtime: in std_logic;
		 rst: out std_logic;
		 senha: in std_logic_vector(7 downto 0);
		 oSenha: out std_logic_vector(7 downto 0);  -- temporario para avaliacao
		 enabledStatus: out std_logic_vector(2 downto 0)
		 );
 end fpgaBombPC; 
 
architecture arq of fpgaBombPC is
	type STATE_TYPE is (estado_0, estado_1,estado_2,estado_3,estado_4,estado_5,estado_6); 
	signal estado_atual, proximo_estado: STATE_TYPE;
	signal btAtivar: std_logic := '1';
	signal lastBtAtivar:  std_logic := '1';
	signal senabledRegSenha: std_logic:='0';
	signal soSenha: std_logic_vector(7 downto 0);
	signal srstRegSenha: std_logic:='0'; 
	signal srstCST2:std_logic:='0';
	signal senableCST2:std_logic:='0';
	signal sCount: std_logic_vector(7 downto 0);
	signal sCountST2: std_logic_vector(7 downto 0);
	signal senableCount: std_logic:='0'; 
	
	component registrador8bit is
	port(
		in8 : in std_logic_vector (7 downto 0);
		rst,clk, load: in std_logic;
		out8,notout8: out std_logic_vector (7 downto 0)
		);
   end component;
 
   component parcialTimer 
		port(
		 clk,rst,enabled: in std_logic;
		 hora_min_coddec: in std_logic_vector(1 downto 0); 
		 result: out std_logic_vector(7 downto 0)
		 );
	end component;
 
begin

	saveSenha:registrador8bit port map(clk=>clk,rst=>srstRegSenha,load=>senabledRegSenha,in8=>senha,out8=>soSenha);
	contadorsenha: parcialTimer port map(clk=>clk,rst=>srstRegSenha,enabled=>senableCount,hora_min_coddec=>"11",result=>sCount);
	contadorST2: parcialTimer port map(clk=>clk,rst=>srstCST2,enabled=>senableCST2,hora_min_coddec=>"11",result=>sCountST2);
	oSenha<=scount;
	
	process (clk)  
	begin
		if clk'EVENT and clk = '1' then    
			estado_atual <= proximo_estado;  
			if ativar='0' and lastBtAtivar='1' then	
				btAtivar<='0';
			else	
				btAtivar<='1';
			end if;
			lastBtAtivar<=ativar;
		end if;  
	end process;
	
	process (estado_atual,btAtivar)  
	begin   
		rst<='0';
		case estado_atual is      
			when estado_0  =>
				enabledStatus<="000";
				senabledRegSenha<='0';
				senableCount<='0';
				srstRegSenha<='1';
				if btAtivar='0' then
					proximo_estado <= estado_1;
				else
					proximo_estado <= estado_0;
				end if;
			when estado_1  =>
				enabledStatus<="001";
				senabledRegSenha<='1';
				senableCount<='0';
				srstRegSenha<='0';
				srstCST2<='1';
				if btAtivar='0' then
					proximo_estado <= estado_2;
				else
					proximo_estado <= estado_1;
				end if;
			when estado_2  =>
				enabledStatus<="010";
				senabledRegSenha<='0';
				senableCount<='0';
				srstRegSenha<='0';
				senableCST2<='1';
				srstCST2<='0';
				if sCountST2="00000100" then
					proximo_estado <= estado_3;
				else
					proximo_estado <= estado_2;
				end if;
				
			when estado_3  =>
				enabledStatus<="011";
				srstRegSenha<='0';
				senabledRegSenha<='0';
				if offtime='1' then
					proximo_estado <= estado_5;
				elsif  btAtivar='0' then 
					if senha=soSenha then
						proximo_estado<=estado_4;
					else
						if sCount="00000011" then
							proximo_estado <= estado_5;
						else
							proximo_estado <= estado_3;
						end if;
						senableCount<='1';
					end if;
				else
					proximo_estado <= estado_3;
					senableCount<='0';
				end if;
			when estado_4 =>
				srstRegSenha<='0';
				enabledStatus<="100";
				senabledRegSenha<='0';
				if  btAtivar='0' then
					proximo_estado<=estado_0;
				else
					proximo_estado <= estado_4;
				end if;
			when estado_5 =>
				enabledStatus<="101";
				srstRegSenha<='0';
				senabledRegSenha<='0';
				if  btAtivar='0' then    -- reset fake
					proximo_estado<=estado_0;
				else
					proximo_estado <= estado_5;
				end if;
			when estado_6 =>
				enabledStatus<="110";
				srstRegSenha<='0';
				senabledRegSenha<='0';
				proximo_estado <= estado_3;
		end case;  
	end process;
end arq;
