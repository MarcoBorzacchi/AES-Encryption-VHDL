library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use WORK.constants.all;

entity shift_rows is 

port(
		state_in : in matrix (15 downto 0);
		enable: in std_logic;
		state_out : out matrix (15 downto 0));

end shift_rows;

architecture bhv of shift_rows is
begin 	
	update_state_2 : process(enable, state_in)
	begin
		if (enable = '1')then
			
			state_out(0) <= state_in(0);
			state_out(1) <= state_in(5);
			state_out(2) <= state_in(10);
			state_out(3) <= state_in(15);
			
			state_out(4) <= state_in(4);
			state_out(5) <= state_in(9);
			state_out(6) <= state_in(14);
			state_out(7) <= state_in(3);
			
			state_out(8) <= state_in(8);
			state_out(9) <= state_in(13);
			state_out(10) <= state_in(2);
			state_out(11) <= state_in(7);
			
			state_out(12) <= state_in(12);
			state_out(13) <= state_in(1);
			state_out(14) <= state_in(6);
			state_out(15) <= state_in(11);
			
		else
			state_out <= (others => (others=>'0'));
		end if;
	end process;
end bhv;
