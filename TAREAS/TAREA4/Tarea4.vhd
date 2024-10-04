LIBRARY ieee;
USE ieee.std_logic_1164.all;
ENTITY Tarea4 IS
	PORT( SW : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
	HEX0 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0));
END Tarea4;
ARCHITECTURE Structure OF Tarea4 IS
BEGIN
	with SW select
	HEX0 <= "0011111" when "000",
			"0000011" when "001",
			"1011011" when "010",
			"1001111" when "011",
			"1100110" when "100",
			"1101101" when "101",
			"1111101" when "110",
			"1101111" when others;
			
END Structure;