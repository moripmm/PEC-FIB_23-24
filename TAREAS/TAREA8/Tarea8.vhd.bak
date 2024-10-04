LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE IEEE.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;
ENTITY Tarea6 IS
 PORT( KEY : IN std_logic_vector(0 downto 0);
 SW : IN std_logic_vector(0 downto 0);
 HEX0 : OUT std_logic_vector(6 downto 0);
 HEX1 : OUT std_logic_vector(6 downto 0);
 HEX2 : OUT std_logic_vector(6 downto 0);
 HEX3 : OUT std_logic_vector(6 downto 0);
 LEDR : OUT std_logic_vector(2 downto 0));
END Tarea6;

ARCHITECTURE Structure OF Tarea6 IS
COMPONENT driver7Segmentos
	PORT( codigoCaracter : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			bitsCaracter : OUT STD_LOGIC_VECTOR(6 DOWNTO 0));
END COMPONENT;

signal codes : std_logic_vector(11 DOWNTO 0);
signal count : std_logic_vector(2 DOWNTO 0) := "000";
BEGIN
	LEDR <= count;
	with count select
		codes <= "000001010011" when "000",
					"001010011111" when "001",
					"010011111111" when "010",
					"011111111111" when "011",
					"111111111111" when "100",
					"111111111000" when "101",
					"111111000001" when "110",
					"111000001010" when others;
					
	visor1: driver7Segmentos Port Map (codes(2 DOWNTO 0), HEX0);
	visor2: driver7Segmentos Port Map (codes(5 DOWNTO 3), HEX1);
	visor3: driver7Segmentos Port Map (codes(8 DOWNTO 6), HEX2);
	visor4: driver7Segmentos Port Map (codes(11 DOWNTO 9), HEX3);
	
	process(KEY(0))begin
		if falling_edge(KEY(0)) then
			if (SW = "0") then count <= count + 1;
			else count <= count - 1;
			end if;
		end if;
	end process;
	
END Structure; 
