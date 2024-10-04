LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY Traductor IS
	PORT( SW: IN std_logic_vector(2 DOWNTO 0);
			tam: OUT integer; -- com el tamany de cada lletra es variable afegim una varible de sortida per agafar els "tam" bits de menys pes
			puls: OUT std_logic_vector(10 DOWNTO 0)); -- 0 és led apagat i 1 és led ences, 3 encesos consecutius representen un guió i 1 ences aillat és un punt
END Traductor;

ARCHITECTURE Structure OF Traductor IS
BEGIN
	with SW select puls <= "00000010111" when "000", -- 5 ultims bits importants
								  "00111010101" when "001", -- 9 ultims bits importants
								  "11101011101" when "010", -- 11 ultims bits importants
								  "00001110101" when "011", -- 7 ultims bits importants
								  "00000000001" when "100", -- ultim bit important
								  "00101011101" when "101", -- 9 ultims bits importants
								  "00111011101" when "110", -- 9 ultims bits importants
								  "00001010101" when "111"; -- 7 ultims bits importants
								  
								  
	with SW select tam <=  5 when "000", 
								  9 when "001",
								  11 when "010",
								  7 when "011",
								  1 when "100",
								  9 when "101",
								  9 when "110",
								  7 when "111";
END Structure;