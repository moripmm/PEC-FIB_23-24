LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all; --Esta libreria sera necesaria si usais conversiones CONV_INTEGER
--USE ieee.numeric_std.all;        --Esta libreria sera necesaria si usais conversiones TO_INTEGER

ENTITY regfile IS
    PORT (clk    : IN  STD_LOGIC;
          wrd    : IN  STD_LOGIC;
          d      : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          addr_a : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_b : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_d : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
          a      : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
          b      : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
END regfile;

ARCHITECTURE Structure OF regfile IS
	type reg is array (7 DOWNTO 0) of std_logic_vector(15 DOWNTO 0);
	signal registre: reg;

BEGIN
	
	process(clk)
	begin
		if(rising_edge(clk)) then
			if(wrd = '1') then
				registre(conv_integer(addr_d)) <= d;
			end if;
		end if;
	end process;	
	
	a <= registre(conv_integer(addr_a));
	b <= registre(conv_integer(addr_b));

END Structure;