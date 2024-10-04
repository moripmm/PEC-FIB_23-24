LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE IEEE.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;
ENTITY Tarea7a IS
 PORT( CLOCK_50 : IN std_logic;
 HEX0 : OUT std_logic_vector(6 downto 0));
END Tarea7a;

ARCHITECTURE Structure OF Tarea7a IS
COMPONENT driver7Segmentos
	PORT( codigoCaracter : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			bitsCaracter : OUT STD_LOGIC_VECTOR(6 DOWNTO 0));
END COMPONENT;
signal clock_1hz : std_LOGIC;
signal cont : std_logic_vector(24 DOWNTO 0);
signal num : std_logic_vector(3 DOWNTO 0) := "0000";
BEGIN
	process(CLOCK_50) begin
		if rising_edge(CLOCK_50) then
			cont <= cont + 1;
		end if;
	end process;
	clock_1hz <= cont(24);
	process(clock_1hz) begin
		if rising_edge(clock_1hz) then
			num <= num + 1;
		end if;
	end process;
	
	visor1: driver7Segmentos Port map (num, HEX0);
	
END Structure;