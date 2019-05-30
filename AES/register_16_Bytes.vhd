library ieee; 
use ieee.std_logic_1164.all;
use work.constants.all;

entity register_16_Bytes is 

port(
		D : in matrix (15 downto 0);
		clk : in std_logic;
		rst : in std_logic;
		Q : out matrix (15 downto 0));

end register_16_Bytes;

architecture bhv of register_16_Bytes is
begin 	

	update_state : process(clk)
	begin
		if rising_edge(clk)then
			if (rst = '0') then 
				Q <= (others => (others => '0'));
			else 				
				Q <= D;
				
			end if;
		end if;
	end process;
end bhv;