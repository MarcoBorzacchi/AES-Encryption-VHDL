library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use WORK.constants.all;

entity round is 

port(
		state_in : in matrix (15 downto 0);
		key : in matrix(15 downto 0);	
		enable: in std_logic;
		state_out : out matrix(15 downto 0)
		);

end round;

architecture struct of round is


component add_round_key is 
port(
		state_in : in matrix (15 downto 0);
		key : in matrix (15 downto 0);
		enable: in std_logic;
		state_out : out matrix (15 downto 0));
end component;

component sub_bytes is 
port(
		state_in : in matrix (15 downto 0);
		enable: in std_logic;
		state_out : out matrix (15 downto 0));
end component;

component shift_rows is 
port(
		state_in : in matrix (15 downto 0);
		enable: in std_logic;
		state_out : out matrix (15 downto 0));
end component;

component mix_columns is 
port(
		state_in : in matrix (15 downto 0);
		enable: in std_logic;
		state_out : out matrix (15 downto 0));
end component;


signal sub_bytes_out, shift_rows_out, mix_columns_out : matrix (15 downto 0);

begin

			SubBytes : sub_bytes port map 	(  
												state_in 	 =>	state_in,					-- (1+(i-1)*4)*16 - 1
												enable 		 => enable,
												state_out 	 => sub_bytes_out
											);
											
			ShiftRows : shift_rows port map (  
												state_in 	 =>	sub_bytes_out,
												enable 		 => enable,
												state_out 	 => shift_rows_out
											);
								
			MixColums: mix_columns port map (  
												state_in 	 =>	shift_rows_out,
												enable 		 => enable,
												state_out    => mix_columns_out
											);
											
			AddRoundKey: add_round_key port map (  
												state_in 	 =>	mix_columns_out,
												key 		 => key,                    -- ATTENTION POTREBBE ESSERE ERRATO
												enable 		 => enable,
												state_out 	 => state_out
											);
end struct;