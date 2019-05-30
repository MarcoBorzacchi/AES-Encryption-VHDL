library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use WORK.constants.all;
use WORK.functions.all;

entity key_expansion is 

port	(
		input_key : in matrix(15 downto 0);
		enable: in std_logic;
		expanded_key : out matrix (175 downto 0)
		);

end key_expansion;

architecture bhv of key_expansion is


begin

	key_exp : process(enable, input_key)  
		-- Variables
	variable bytes_generated : integer range 16 to 176; -- We have generated 16 bytes so far
	variable rcon_iteration : integer range 1 to 11;	-- Rcon iteration begins at 1
	variable tmp_cores : matrix (3 downto 0); -- temporary storage for cores
	variable expanded_key_temp : matrix (175 downto 0);
	
	begin
		bytes_generated := 16;
		rcon_iteration := 1;
		if (enable = '1')then
					
			expanded_key_temp(15 downto 0) := input_key;
			
			-- KEY EXPANSION
			while (bytes_generated < 176) loop
				-- Read 4 bytes for the core
				for i in 0 to 3 loop
					tmp_cores(i) := expanded_key_temp(i + bytes_generated - 4);
				end loop;
				
				-- Perform the core once of each 16 byte key_exp
				if ((bytes_generated mod 16)=0) then
					key_expansion_core(tmp_cores, rcon_iteration, tmp_cores);
					rcon_iteration := rcon_iteration + 1;
				end if;
				
				-- Xor and Store Diagram : Add (Xor) 
				for j in 0 to 3 loop
					expanded_key_temp(bytes_generated) := expanded_key_temp(bytes_generated - 16) xor tmp_cores(j);
					bytes_generated := bytes_generated + 1;
 				end loop;
			end loop;
			
		else
			expanded_key_temp := (others => (others=>'0'));
		end if;
		expanded_key <= expanded_key_temp;
	end process;
end bhv;