library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use WORK.constants.all;

entity AES is 
generic(N_rounds : integer := 9);

port(
		message : in matrix (15 downto 0);
		input_key : in matrix(15 downto 0);	
		enable: in std_logic;
		clk : in std_logic;
		rst : in std_logic;
		encrypted_message : out matrix(15 downto 0)
		);

end AES;

architecture struct of AES is

component key_expansion is 
port(
		input_key : in matrix(15 downto 0);
		enable: in std_logic;
		expanded_key : out matrix (175 downto 0)
		);
end component;

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

component register_16_Bytes is
port(
		D : in matrix (15 downto 0);
		clk : in std_logic;
		rst : in std_logic;
		Q : out matrix (15 downto 0));

end component;

signal expanded_key : matrix (175 downto 0);

-- for the transient state signals during the round
signal trans_states_round : matrix (64*N_rounds + 15 downto 0);

-- for the transient state signals in the final round
signal trans_state_subbytes : matrix (15 downto 0);
signal trans_state_shiftrows : matrix (15 downto 0);
signal trans_state_addroundkeys : matrix (15 downto 0);

signal init_message : matrix (15 downto 0);
signal init_key : matrix (11 downto 0);


begin 
	-- Save the message in a register 										
	Reg_init : register_16_Bytes port map   (   
												D		 	 =>	message,
												clk 		 => clk,
												rst			 =>	rst,
												Q 	 		 => init_message
											);	

											
	KeyExpxp : key_expansion port map 		(  -- component    -- signal
												input_key 	 =>	input_key,
												enable 		 => enable,
												expanded_key => expanded_key 
											);
	InitialRound: add_round_key port map 	(  
												state_in 	 =>	init_message,
												key 		 => expanded_key(15 downto 0),
												enable 		 => enable,
												state_out 	 => trans_states_round(15 downto 0) 
											);
		
	rounds : 
		for i in 1 to N_rounds generate 
			SubBytes : sub_bytes port map 	(  
												state_in 	 =>	trans_states_round(64*i-48-1 downto 64*i-48-16),					-- (1+(i-1)*4)*16 - 1
												enable 		 => enable,
												state_out 	 => trans_states_round(64*i-32-1 downto 64*i-32-16)
											);
											
			ShiftRows : shift_rows port map (  
												state_in 	 =>	trans_states_round(64*i-32-1 downto 64*i-32-16),
												enable 		 => enable,
												state_out 	 => trans_states_round(64*i-16-1 downto 64*i-16-16)
											);
								
			MixColums: mix_columns port map (  
												state_in 	 =>	trans_states_round(64*i-16-1 downto 64*i-16-16),
												enable 		 => enable,
												state_out    => trans_states_round(64*i-1 downto 64*i-16)
											);
											
			AddRoundKey: add_round_key port map (  
												state_in 	 =>	trans_states_round(64*i-1 downto 64*i-16),
												key 		 => expanded_key(16 * i + 15 downto 16 *i),
												enable 		 => enable,
												state_out 	 => trans_states_round(64*i + 15 downto 64*i)
											);
																					
		end generate;
	
	--  FinalRound 
	SubBytes_FinalRound : sub_bytes port map(  
												state_in 	 =>	trans_states_round(64*N_rounds + 15 downto 64*N_rounds),			
												enable 		 => enable,
												state_out 	 => trans_state_subbytes
											);
											
	ShiftRows_FinalRound : shift_rows port map (	  
												state_in 	 =>	trans_state_subbytes,
												enable 		 => enable,
												state_out 	 => trans_state_shiftrows
											);
	
	AddRoundKey_FinalRound : add_round_key port map (  
												state_in 	 =>	trans_state_shiftrows,
												key 		 => expanded_key(175 downto 160),                    -- ATTENTION POTREBBE ESSERE ERRATO
												enable 		 => enable,
												state_out 	 => trans_state_addroundkeys
											);
	-- Save the encrypted message in a register 										
	Reg_end : register_16_Bytes port map    (   
												D		 	 =>	trans_state_addroundkeys,
												clk 		 => clk,
												rst			 =>	rst,
												Q 	 		 => encrypted_message
											);
end struct;