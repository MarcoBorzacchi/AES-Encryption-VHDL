library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use WORK.constants.all;

entity mix_columns is 

port(
		state_in : in matrix (15 downto 0);
		enable: in std_logic;
		state_out : out matrix (15 downto 0));

end mix_columns;

architecture bhv of mix_columns is
begin 	
	update_state_in_in_4 : process(enable, state_in)  
	begin
		if (enable = '1')then
			
			state_out(0) <= (mul2(conv_integer(unsigned(state_in(0)))) xor mul3(conv_integer(unsigned(state_in(1)))) xor state_in(2) xor state_in(3));
			state_out(1) <= (state_in(0) xor mul2(conv_integer(unsigned(state_in(1)))) xor mul3(conv_integer(unsigned(state_in(2)))) xor state_in(3));
			state_out(2) <= (state_in(0) xor state_in(1) xor mul2(conv_integer(unsigned(state_in(2)))) xor mul3(conv_integer(unsigned(state_in(3)))));
			state_out(3) <= (mul3(conv_integer(unsigned(state_in(0)))) xor state_in(1) xor state_in(2) xor mul2(conv_integer(unsigned(state_in(3)))));

			state_out(4) <= (mul2(conv_integer(unsigned(state_in(4)))) xor mul3(conv_integer(unsigned(state_in(5)))) xor state_in(6) xor state_in(7));
			state_out(5) <= (state_in(4) xor mul2(conv_integer(unsigned(state_in(5)))) xor mul3(conv_integer(unsigned(state_in(6)))) xor state_in(7));
			state_out(6) <= (state_in(4) xor state_in(5) xor mul2(conv_integer(unsigned(state_in(6)))) xor mul3(conv_integer(unsigned(state_in(7)))));
			state_out(7) <= (mul3(conv_integer(unsigned(state_in(4)))) xor state_in(5) xor state_in(6) xor mul2(conv_integer(unsigned(state_in(7)))));

			state_out(8) <= (mul2(conv_integer(unsigned(state_in(8)))) xor mul3(conv_integer(unsigned(state_in(9)))) xor state_in(10) xor state_in(11));
			state_out(9) <= (state_in(8) xor mul2(conv_integer(unsigned(state_in(9)))) xor mul3(conv_integer(unsigned(state_in(10)))) xor state_in(11));
			state_out(10) <= (state_in(8) xor state_in(9) xor mul2(conv_integer(unsigned(state_in(10)))) xor mul3(conv_integer(unsigned(state_in(11)))));
			state_out(11) <= (mul3(conv_integer(unsigned(state_in(8)))) xor state_in(9) xor state_in(10) xor mul2(conv_integer(unsigned(state_in(11)))));

			state_out(12) <= (mul2(conv_integer(unsigned(state_in(12)))) xor mul3(conv_integer(unsigned(state_in(13)))) xor state_in(14) xor state_in(15));
			state_out(13) <= (state_in(12) xor mul2(conv_integer(unsigned(state_in(13)))) xor mul3(conv_integer(unsigned(state_in(14)))) xor state_in(15));
			state_out(14) <= (state_in(12) xor state_in(13) xor mul2(conv_integer(unsigned(state_in(14)))) xor mul3(conv_integer(unsigned(state_in(15)))));
			state_out(15) <= (mul3(conv_integer(unsigned(state_in(12)))) xor state_in(13) xor state_in(14) xor mul2(conv_integer(unsigned(state_in(15)))));

		else
			state_out <= (others => (others=>'0'));
		end if;
	end process;
end bhv;
