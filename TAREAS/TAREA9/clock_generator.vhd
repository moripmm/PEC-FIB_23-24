LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE IEEE.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;
USE ieee.Numeric_Std.all;
ENTITY clock_generator IS
 generic (cicles : integer; --(cicles / 50MHz) segons
				num_bits : integer);
 PORT( CLOCK_50 : IN std_logic;	
 SIG : OUT std_logic);
 
END clock_generator;

ARCHITECTURE Structure OF clock_generator IS
signal cont : std_logic_vector(num_bits-1 downto 0) := std_logic_vector(to_unsigned(cicles/2,num_bits)); 
-- (num_bits - 3) per que comptem el bit 0 i perque dividim per 2
signal clock_out: std_logic :='0';

BEGIN
	process(CLOCK_50) begin
		if rising_edge(CLOCK_50) then
			cont <= cont - 1;
			if (cont = std_logic_vector(to_unsigned(0,num_bits))) then
				clock_out <= not (clock_out);
				cont <= std_logic_vector(to_unsigned(cicles/2,num_bits));
			end if;
		end if;
	end process;	
 
	sig <= clock_out;		
END Structure; 