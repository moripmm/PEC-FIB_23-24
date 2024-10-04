LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.all;

ENTITY alu IS
    PORT (x  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          y  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          op : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
		  f	 : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
          w  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		  z  : OUT STD_LOGIC;
		  div_zero: OUT STD_LOGIC);
END alu;


ARCHITECTURE Structure OF alu IS
signal calc: std_logic_vector(15 DOWNTO 0);
signal cmp_b: boolean;
signal cmp: std_logic_vector(15 DOWNTO 0);
signal multdiv: std_logic_vector(15 DOWNTO 0);
signal mov: std_logic_vector(15 DOWNTO 0);
signal salt: std_logic_vector(15 DOWNTO 0);

signal shift_s: std_logic_vector(15 DOWNTO 0);
signal shift_u: std_logic_vector(15 DOWNTO 0);

signal mul_s: std_logic_vector(31 DOWNTO 0);
signal mul_u: std_logic_vector(31 DOWNTO 0);

signal w2: std_logic_vector(15 DOWNTO 0);
BEGIN
	shift_s <= std_logic_vector(shift_left(signed(x), to_integer(unsigned(y(4 DOWNTO 0))))) when y(4) = '0' else
			   std_logic_vector(shift_right(signed(x), to_integer(unsigned((not y(4 DOWNTO 0)) + 1))));
	
	shift_u <= std_logic_vector(shift_left(unsigned(x), to_integer(unsigned(y(4 DOWNTO 0))))) when y(4) = '0' else
				std_logic_vector(shift_right(unsigned(x), to_integer(unsigned((not y(4 DOWNTO 0)) + 1))));	

	mul_s <= std_logic_vector(signed(x)*signed(y));
	mul_u <= std_logic_vector(unsigned(x)*unsigned(y));

	WITH f SELECT calc <= 
			x and y WHEN "000", --AND
			x or y WHEN "001", --OR
			x xor y WHEN "010", --XOR
			not x WHEN "011", --NOT
			std_logic_vector(unsigned(x) - unsigned(y)) WHEN "101", --SUB
			shift_s WHEN "110", --SHA
			shift_u WHEN "111", --SHL
			std_logic_vector(unsigned(x) +  unsigned(y)) WHEN OTHERS; --ADD/ADDI/STORE/LOAD

	WITH f select cmp_b <=
			signed(x) < signed(y) WHEN "000", --CMPLT
			signed(x) <= signed(y) WHEN "001", --CMPLE
			x = y WHEN "011", --CMPEQ
			unsigned(x) < unsigned(y) WHEN "100", --CMPLTU
			unsigned(x) <= unsigned(y) WHEN "101", --CMPLEU
			false WHEN others;

	WITH f select mov <=
			y WHEN "000", --MOVI
			y(7 DOWNTO 0) & x(7 DOWNTO 0) WHEN "001", --MOVHI
			x"0000" WHEN others;

	WITH f select multdiv <=
			std_logic_vector(mul_s(15 DOWNTO 0)) WHEN "000", --MUL
			std_logic_vector(mul_s(31 DOWNTO 16)) WHEN "001", --MULH
			std_logic_vector(mul_u(31 DOWNTO 16)) WHEN "010", --MULHU
			std_logic_vector(signed(x)/signed(y)) WHEN "100", --DIV
			std_logic_vector(unsigned(x)/unsigned(y)) WHEN "101", --DIVU
			x"0000" WHEN others;
	
	cmp <= x"0001" when cmp_b else
		   x"0000";
			
	salt <= y when (op = "100" or (op = "101" and f < "010")) 
					else x;

	WITH op select w2 <=
			calc WHEN "000", --aritmetico-logiques
			cmp WHEN "001", --comparacions
			mov WHEN "010", --moviments
			multdiv WHEN "011", --multiplicacio-divisio
			salt WHEN "100", --salt
			salt WHEN "101", --branch
			x"0000" WHEN others;
			
	w <= w2;		

	z <= '1' WHEN w2 = x"0000" else
		 '0';

	div_zero <= '1' WHEN ((op = "011" and (f = "100" or f = "101")) and y =  x"0000") else
				'0';

END Structure;