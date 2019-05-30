library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_arith.all;
use WORK.constants.all;

package functions is
	procedure key_expansion_core (input: in matrix(3 downto 0); n: integer; output: out matrix);

end functions;

package body functions is
	
	procedure key_expansion_core (input: in matrix(3 downto 0); n:integer; output: out matrix) is
	variable tmp_in : matrix (3 downto 0);
	begin

		-- Rotate Left 
		tmp_in(0) := input(1);
		tmp_in(1) := input(2);
		tmp_in(2) := input(3);
		tmp_in(3) := input(0);
		
		-- S-Box four bytes:
		tmp_in(0) := rijndael_box(conv_integer(unsigned(tmp_in(0))));
		tmp_in(1) := rijndael_box(conv_integer(unsigned(tmp_in(1))));
		tmp_in(2) := rijndael_box(conv_integer(unsigned(tmp_in(2))));
		tmp_in(3) := rijndael_box(conv_integer(unsigned(tmp_in(3))));
		
		-- RCon :
		tmp_in(0) := tmp_in(0) xor rcon(n);
		
		--return tmp_in;
		
		output := tmp_in;
	
	end key_expansion_core;

	
end functions;