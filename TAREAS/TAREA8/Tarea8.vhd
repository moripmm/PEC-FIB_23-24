LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE IEEE.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;
ENTITY Tarea8 IS
	PORT( KEY : IN std_logic_vector(0 downto 0);
			SW : IN std_logic_vector(0 downto 0);
			CLOCK_50: IN std_logic;
			HEX0 : OUT std_logic_vector(6 downto 0);
			HEX1 : OUT std_logic_vector(6 downto 0);
			HEX2 : OUT std_logic_vector(6 downto 0);
			HEX3 : OUT std_logic_vector(6 downto 0));
END Tarea8;

ARCHITECTURE Structure OF Tarea8 IS
COMPONENT driver7Segmentos
	PORT( codigoCaracter : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			bitsCaracter : OUT STD_LOGIC_VECTOR(6 DOWNTO 0));
END COMPONENT;

COMPONENT clock_generator 
	GENERIC(cicles: integer;
				num_bits: integer);
	PORT(CLOCK_50: IN std_logic;
		  SIG: OUT std_logic);
END COMPONENT;

signal SIG: std_logic;
signal count : std_logic_vector(2 DOWNTO 0) := "000";
BEGIN
	visor1: driver7Segmentos Port Map (count, HEX0);
	visor2: driver7Segmentos Port Map (count + 1, HEX1);
	visor3: driver7Segmentos Port Map (count + 2, HEX2);
	visor4: driver7Segmentos Port Map (count + 3, HEX3);
	
	process(SIG)
	begin
		if falling_edge(SIG) then
			if (SW = "0") then count <= count + 1;
			else count <= count - 1;
			end if;
		end if;
	end process;
	
	clock_gen: clock_generator generic map (cicles => 50000000, num_bits => 25)
		port map (CLOCK_50 => CLOCK_50, SIG => SIG);
	
END Structure; 
