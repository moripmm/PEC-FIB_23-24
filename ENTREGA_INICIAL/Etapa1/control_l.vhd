LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY control_l IS
    PORT (ir     : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          op     : OUT STD_LOGIC;
          ldpc   : OUT STD_LOGIC;
          wrd    : OUT STD_LOGIC;
          addr_a : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_d : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
          immed  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
END control_l;


ARCHITECTURE Structure OF control_l IS
	signal immed_tmp_h : STD_LOGIC_VECTOR(7 DOWNTO 0);
	signal immed_tmp_l : STD_LOGIC_VECTOR(7 DOWNTO 0);
BEGIN
	op <= ir(8);
	ldpc <= '0' when ir = "1111111111111111"
			  else '1';
	wrd <= '1' when ir(15 DOWNTO 12) = "0101"
			 else '0';
	addr_a <= ir(11 DOWNTO 9);
	addr_d <= ir(11 DOWNTO 9);

	immed_tmp_h <= (others => ir(7));
	immed_tmp_l <= ir(7 DOWNTO 0);
	immed <= immed_tmp_h & immed_tmp_l;

--	immed<= ((15 downto 8)((others => ir(7))), ((7 downto 0) => ir(7 DOWNTO 0)));
	
    -- Aqui iria la generacion de las senales de control del datapath
	
	 
END Structure;