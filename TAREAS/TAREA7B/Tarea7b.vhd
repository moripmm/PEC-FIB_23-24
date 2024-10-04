LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE IEEE.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;
ENTITY Tarea7b IS
 PORT( CLOCK_50 : IN std_logic;
 HEX0 : OUT std_logic_vector(6 downto 0);
 HEX1 : OUT std_logic_vector(6 downto 0);
 HEX2 : OUT std_logic_vector(6 downto 0);
 HEX3 : OUT std_logic_vector(6 downto 0));
END Tarea7b;

ARCHITECTURE Structure OF Tarea7b IS
COMPONENT driver4Display 
	PORT( caract : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			HEX0 : OUT std_logic_vector(6 downto 0);
			HEX1 : OUT std_logic_vector(6 downto 0);
			HEX2 : OUT std_logic_vector(6 downto 0);
			HEX3 : OUT std_logic_vector(6 downto 0));
END COMPONENT;

COMPONENT clock_generator 
	GENERIC(cicles: integer;
				num_bits: integer);
	PORT(CLOCK_50: IN std_logic;
		  SIG: OUT std_logic);
END COMPONENT;
signal SIG: std_logic;
signal num: std_LOGIC_VECTOR(15 DOWNTO 0) := (others => '0');
BEGIN
	process(SIG)
	BEGIN
		if rising_edge(SIG) then
			num <= num + 1;
		end if;
	end process;
	
	--Codi teu
	
	display: driver4Display Port map(num, HEX0, HEX1, HEX2, HEX3);
	clock_gen: clock_generator generic map (cicles => 50000000, num_bits => 26)
											port map (CLOCK_50 => CLOCK_50, SIG => SIG);
END Structure; 