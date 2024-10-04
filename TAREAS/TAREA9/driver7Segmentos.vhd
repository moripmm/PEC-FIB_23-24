LIBRARY ieee;
USE ieee.std_logic_1164.all;
ENTITY driver7Segmentos IS
 PORT( codigoCaracter : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		 bitsCaracter : OUT STD_LOGIC_VECTOR(6 DOWNTO 0));
END driver7Segmentos;
ARCHITECTURE Structure OF driver7Segmentos IS
BEGIN
	with codigoCaracter select
	bitsCaracter <= "0001000" when "000", --A
						 "0000011" when "001", --B
						 "1000110" when "010", --C
						 "0100001" when "011", --d
						 "0000110" when "100", --E
						 "0001110" when "101", --F
						 "0010000" when "110", --g
						 "0001001" when "111", --H
						 "0111111" when others;
END Structure; 