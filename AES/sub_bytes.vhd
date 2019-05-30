library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use WORK.constants.all;

entity sub_bytes is 

port(
		state_in : in matrix (15 downto 0);
		enable: in std_logic;
		state_out : out matrix (15 downto 0));

end sub_bytes;

architecture bhv of sub_bytes is
begin 	

	update_state : process(enable, state_in)
	begin
		if (enable = '1')then			
			for i in 0 to 15 loop
				state_out(i) <= rijndael_box(conv_integer(unsigned(state_in(i))));
			end loop;
		else
			state_out <= (others => (others=>'0'));
		end if;
	end process;
end bhv;
