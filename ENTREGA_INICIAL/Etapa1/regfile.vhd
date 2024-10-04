LIBRARY ieee;
USE ieee.std_logic_1164.all;
--USE ieee.numeric_std.all;        --Esta libreria sera necesaria si usais conversiones TO_INTEGER
USE ieee.std_logic_unsigned.all; --Esta libreria sera necesaria si usais conversiones CONV_INTEGER

ENTITY regfile IS
    PORT (clk    : IN  STD_LOGIC;
          wrd    : IN  STD_LOGIC;
          d      : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          addr_a : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_d : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
          a      : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
END regfile;


ARCHITECTURE Structure OF regfile IS
	type reg is array (7 DOWNTO 0) of std_logic_vector(15 DOWNTO 0);
	signal registre: reg;
	--signal addra: integer;
	--signal addrd: integer;
	 
BEGIN
	--addra <= to_integer(unsigned(addr_a));
	--addrd <= to_integer(unsigned(addr_d));
	
	process(clk)
	begin
		if(rising_edge(clk)) then
			if (wrd = '1') then 
				registre(conv_integer(addr_d)) <= d;
			end if;
		end if;
	end process;
			
    -- Aqui iria la definicion del comportamiento del banco de registros
    -- Os puede ser util usar la funcion "conv_integer" o "to_integer"
    -- Una buena (y limpia) implementacion no deberia ocupar m�s de 7 o 8 lineas

	 a <= registre(conv_integer(addr_a));
	 
END Structure;