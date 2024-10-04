LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY Monitoreo IS
	PORT (clock: IN std_logic;
			KEY: IN std_logic_vector(1 DOWNTO 0);
			fin: IN std_logic;
			exe: OUT std_logic;
			LEDG: OUT std_logic);
END Monitoreo;

ARCHITECTURE Structure OF Monitoreo IS
signal estat, estat_pre: std_logic := '0'; --0 representa que esta en repós i 1 que esta mostrant el morse pel LEDR


BEGIN

	estat_pre <= '1' when estat = '0' and KEY(1) = '0' --KEY1 = 0 quan es pulsa KEY1
					 else '0' when estat = '1' and (KEY(0) = '0' or fin = '1') --L'ordre dels elses es important
				    else '1' when estat = '1' and fin = '0'
				    else '0';
	
	LEDG <= '1' when estat = '0' --El led verd esta activat quan està en mode repós
			  else '0' when estat = '1';
	
	exe <= '1' when estat = '1'
			 else '0' when estat = '0';
			 
	estat <= estat_pre when rising_edge(clock);	

END Structure;
