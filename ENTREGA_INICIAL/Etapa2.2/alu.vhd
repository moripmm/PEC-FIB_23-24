LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.all;

ENTITY alu IS
    PORT (x  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          y  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          op : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
          w  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
END alu;


ARCHITECTURE Structure OF alu IS
BEGIN
	WITH op SELECT w <= 
			y WHEN "00",
			y(7 DOWNTO 0) & x(7 DOWNTO 0) WHEN "01",
			std_logic_vector(signed(x)+signed(y)) WHEN "10",
			x"0000" when others;

END Structure;