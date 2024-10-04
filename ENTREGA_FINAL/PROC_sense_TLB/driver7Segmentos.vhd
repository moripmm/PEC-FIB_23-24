LIBRARY ieee;
USE ieee.std_logic_1164.all;
ENTITY driver7Segmentos IS
	PORT(codigoCaracter : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
  		 bitsCaracter   : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		 visor			: IN STD_LOGIC);
END driver7Segmentos;
ARCHITECTURE Structure OF driver7Segmentos IS
signal codigo: STD_LOGIC_VECTOR(4 DOWNTO 0);
BEGIN
	codigo <= visor&codigoCaracter;
	
	bitsCaracter <= "1000000" when codigo = "10000" else --0
                    "1111001" when codigo = "10001" else --1
                    "0100100" when codigo = "10010" else --2
                    "0110000" when codigo = "10011" else --3
                    "0011001" when codigo = "10100" else --4
                    "0010010" when codigo = "10101" else --5
                    "0000010" when codigo = "10110" else --6
                    "1111000" when codigo = "10111" else --7
                    "0000000" when codigo = "11000" else --8
                    "0011000" when codigo = "11001" else --9
                    "0001000" when codigo = "11010" else --A
                    "0000011" when codigo = "11011" else --B
                    "1000110" when codigo = "11100" else --C
                    "0100001" when codigo = "11101" else --D
                    "0000110" when codigo = "11110" else --E
                    "0001110" when codigo = "11111" else --F
                    "1111111";  
	

									 
END Structure; 
