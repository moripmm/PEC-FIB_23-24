LIBRARY ieee;
USE ieee.std_logic_1164.all; 

entity Tarea1 is

	PORT( SW : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
		LEDR : OUT STD_LOGIC_VECTOR(9 DOWNTO 0));
end Tarea1;

ARCHITECTURE Structure OF Tarea1 IS
BEGIN
	LEDR <= SW;
END Structure;