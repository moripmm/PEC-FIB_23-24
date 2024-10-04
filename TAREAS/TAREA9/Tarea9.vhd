LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.numeric_std.all;

ENTITY Tarea9 IS
PORT( SW: IN std_logic_vector(2 DOWNTO 0);
	   KEY: IN std_logic_vector(1 DOWNTO 0);
		HEX0: OUT std_logic_vector(6 DOWNTO 0);
		LEDR: OUT std_logic_vector(0 DOWNTO 0);
		LEDG: OUT std_logic_vector(0 DOWNTO 0);
		CLOCK_50: IN std_logic);
END Tarea9;

ARCHITECTURE Structure OF Tarea9 IS
COMPONENT clock_generator
	GENERIC(cicles: integer;
				num_bits: integer);
	PORT(CLOCK_50: IN std_logic;
		  SIG: OUT std_logic);
END COMPONENT;

COMPONENT Traductor IS
	PORT (SW: IN std_logic_vector(2 DOWNTO 0);
			tam: OUT integer;
			puls: OUT std_logic_vector(10 DOWNTO 0));
END COMPONENT;

COMPONENT driver7Segmentos IS
	PORT (codigoCaracter: IN std_logic_vector(2 DOWNTO 0);
			bitsCaracter: OUT std_logic_vector(6 DOWNTO 0));
END COMPONENT;

COMPONENT Morse IS
	PORT (puls: IN std_logic_vector(10 DOWNTO 0);
			tam: IN integer;
			clock: IN std_logic;
			exe: IN std_logic;
			LEDR: OUT std_logic;
			fin: OUT std_logic);
END COMPONENT;

COMPONENT Monitoreo IS
	PORT (clock: IN std_logic;
			KEY: IN std_logic_vector(1 DOWNTO 0);
			fin: IN std_logic;
			exe: OUT std_logic;
			LEDG: OUT std_logic);
END COMPONENT;			

signal tic_05: std_logic;
signal tam: integer; -- el tamany l'utilitzarem com un comptador per pasar els 0 i 1 de la lletra en morse
signal puls: std_logic_vector(10 DOWNTO 0);
signal fin: std_logic;
signal exe: std_logic;

BEGIN

	monit: Monitoreo PORT MAP(tic_05, KEY, fin, exe, LEDG(0));
	
	clock_05: clock_generator GENERIC MAP (25000000, 25)
									  PORT MAP (CLOCK_50, tic_05);
									  
	visor0: driver7Segmentos PORT MAP(SW, HEX0);
									  	
	t: Traductor PORT MAP(SW, tam, puls);	
	
	m: Morse PORT MAP (puls, tam, tic_05, exe, LEDR(0), fin);
									  
END Structure;