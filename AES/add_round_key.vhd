library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use WORK.constants.all;

entity add_round_key is 

port(
		state_in : in matrix (15 downto 0);
		key : in matrix (15 downto 0);
		enable: in std_logic;
		state_out : out matrix (15 downto 0));

end add_round_key;

architecture bhv of add_round_key is
begin 	
	update_state_3 : process(enable, state_in, key)
	begin
		if (enable = '1')then
			
			for i in 0 to 15 loop
				state_out(i) <= state_in(i) xor key(i);
			end loop;
		else
			state_out <= (others => (others=>'0'));
		end if;
	end process;
end bhv;
