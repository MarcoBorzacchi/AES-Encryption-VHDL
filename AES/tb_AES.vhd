--simple testbench for quickly testing the AES

library ieee; 
use ieee.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use WORK.functions.all;
use work.constants.all;




entity tb_AES is
end tb_AES;

architecture test of tb_AES is 
	component AES is
		port(
				message : in matrix (15 downto 0);
				input_key : in matrix(15 downto 0);	
				enable : in std_logic;
				clk : in std_logic;
				rst : in std_logic;
				encrypted_message : out matrix(15 downto 0)
				);
	end component;


    function to_std_logic_vector( s : string )
    	return matrix 
    	is
    		variable r : matrix( s'length - 1 downto 0) ;
    	begin
    		for i in 0 to s'high - 1 loop
    			r(i) := conv_std_logic_vector(character'pos((s(i+1))),8);
    		end loop ;
    		return r ;
    	end function ;


signal message 					: matrix (15 downto 0) := (others=>(others=>'0'));
signal key	 					: matrix (15 downto 0) := (others=>(others=>'0'));
signal enable 					: std_logic := '0';
signal clk 						: std_logic := '0';
signal rst 						: std_logic := '0';
signal encrypted_message 		: matrix (15 downto 0);


constant clk_period : time := 100 ns;
constant Message1 : String(1 to 16) := "Does it work????";    
constant Message2 : String(1 to 16) := "I'm an AES test!";
constant Message3 : String(1 to 16) := "It seems working";

begin 

	DUT : AES port map(message, key, enable, clk, rst, encrypted_message);

	clk_proc : process
	begin
		clk <= '1';
		wait for clk_period /2;
		clk <= '0';
		wait for clk_period /2;
	end process clk_proc;
	
	stimuli : process
	begin
		rst <= '0';			-- active low
		enable <= '0';
		message <= to_std_logic_vector(Message1);
		key <= my_key1;	-- 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F 10
		
		wait for clk_period;
		rst <= '1';
		
		wait for clk_period*2;
		enable <= '1';
		
		wait for clk_period*5;
		message <= to_std_logic_vector(Message2);
		key <= my_key2;	-- 11 22 33 44 55 66 77 88 99 AA BB CC DD EE FF FF
		
		wait for clk_period*5;
		message <= to_std_logic_vector(Message3);
		key <= my_key3; -- A1 A2 A3 A4 A5 A6 A7 A8 A9 AA AB AC AD AE AF B0
		
		wait for clk_period*5;
		enable <= '0';
		
		wait for clk_period*5;
		rst <= '0';
		
		wait for 1000*clk_period;
	
	end process stimuli;
	

end test;