LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE IEEE.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;
ENTITY driver4Display IS
	PORT( caract : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		  HEX0   : OUT std_logic_vector(6 downto 0);
		  HEX1   : OUT std_logic_vector(6 downto 0);
		  HEX2   : OUT std_logic_vector(6 downto 0);
		  HEX3   : OUT std_logic_vector(6 downto 0);
		  visor  : IN STD_LOGIC_VECTOR(3 DOWNTO 0));
END driver4Display;

ARCHITECTURE Structure OF driver4Display IS
COMPONENT driver7Segmentos
	PORT( codigoCaracter : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		  bitsCaracter : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		  visor : IN STD_LOGIC);
END COMPONENT;
BEGIN
	visor0: driver7Segmentos Port map (caract(3 DOWNTO 0), HEX0, visor(0));
	visor1: driver7Segmentos Port map (caract(7 DOWNTO 4), HEX1, visor(1));
	visor2: driver7Segmentos Port map (caract(11 DOWNTO 8), HEX2, visor(2));
	visor3: driver7Segmentos Port map (caract(15 DOWNTO 12), HEX3, visor(3));
end Structure;
