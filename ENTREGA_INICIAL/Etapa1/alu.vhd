LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY alu IS
    PORT (x  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          y  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          op : IN  STD_LOGIC;
          w  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
END alu;


ARCHITECTURE Structure OF alu IS
	signal x1 : STD_LOGIC_VECTOR(7 DOWNTO 0);
	signal y1 : STD_LOGIC_VECTOR(7 DOWNTO 0);
BEGIN

	x1 <= x(7 DOWNTO 0);
	y1 <= y(7 DOWNTO 0);

    -- Aqui iria la definicion del comportamiento de la ALU
	WITH op SELECT w <= 
		y WHEN '0',
		y1 & x1 WHEN '1',
		x"0000" when others;
		
END Structure;