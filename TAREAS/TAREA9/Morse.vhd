LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY Morse IS
	PORT (puls: IN std_logic_vector(10 DOWNTO 0);
			tam: IN integer;
			clock: IN std_logic;
			exe: IN std_logic;
			LEDR: OUT std_logic;
			fin: OUT std_logic);
END Morse;

ARCHITECTURE Structure OF Morse IS
signal i: integer := tam;

BEGIN
	LEDR <= puls(i) when exe = '1'
			  else '0' when exe = '0';
			  
	fin <= '1' when i = 0 
			  else '0';
			  
	i <= (i-1) when rising_edge(clock) and exe = '1'
		  else tam when rising_edge(clock) and exe = '0';	
END Structure;