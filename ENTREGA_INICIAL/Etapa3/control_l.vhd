LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY control_l IS
    PORT (ir        : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          op        : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		  f			: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
          ldpc      : OUT STD_LOGIC;
          wrd       : OUT STD_LOGIC;
          addr_a    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_b    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_d    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
		  rb_n		: OUT STD_LOGIC;
          immed     : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
          wr_m      : OUT STD_LOGIC;
          in_d      : OUT STD_LOGIC;
          immed_x2  : OUT STD_LOGIC;
          word_byte : OUT STD_LOGIC);
END control_l;


ARCHITECTURE Structure OF control_l IS
SIGNAL code_op : STD_LOGIC_VECTOR (3 DOWNTO 0);
signal immed_tmp_h5 : STD_LOGIC_VECTOR(9 DOWNTO 0);
signal immed_tmp_l5 : STD_LOGIC_VECTOR(5 DOWNTO 0);
signal immed_tmp_h7 : STD_LOGIC_VECTOR(7 DOWNTO 0);
signal immed_tmp_l7 : STD_LOGIC_VECTOR(7 DOWNTO 0);
signal immed5 : STD_LOGIC_VECTOR(15 DOWNTO 0);
signal immed7 : STD_LOGIC_VECTOR(15 DOWNTO 0);


BEGIN

	code_op <= ir(15 DOWNTO 12);

	WITH code_op SELECT op <= 
		"01" WHEN "0001", --comparacions
		"10" WHEN "0101", --moviments
		"11" WHEN "1000", --mult/div
		"00" WHEN OTHERS; --aritmetico-logiques/addi/store/load

	WITH code_op SELECT f <=
		ir(5 DOWNTO 3) WHEN "0000", --aritmetico-logiques
		ir(5 DOWNTO 3) WHEN "0001", --comparacions
		"00" & ir(8) WHEN "0101", --moviments
		ir(5 DOWNTO 3) WHEN "1000", --mult/div
		"100" WHEN OTHERS; --load/store/addi

	
	WITH ir SELECT ldpc <= 
		'0' WHEN x"FFFF", --halt
		'1' WHEN OTHERS;
	
	WITH code_op SELECT wrd <= 
		'0' WHEN "0100", --ST
		'0' WHEN "1110", --STB
		'0' WHEN "1111", --HALT
		'1' WHEN OTHERS;
	
	WITH code_op SELECT addr_a <= 
		ir(11 DOWNTO 9) WHEN "0101", --moviments
		ir(8 DOWNTO 6) WHEN OTHERS; --aritmetico-logiques/comparacions/addi/load/store/mult/div
	
	WITH code_op SELECT addr_b <=
		ir(2 DOWNTO 0) WHEN "0000", --aritmetico-logiques
		ir(2 DOWNTO 0) WHEN "0001", --comparacions
		ir(2 DOWNTO 0) WHEN "1000", --mult/div
		ir(11 DOWNTO 9) WHEN others; --store
	
	addr_d <= ir(11 DOWNTO 9);	
	
	immed_tmp_l5 <= ir(5 DOWNTO 0);
	immed_tmp_h5 <= (others => ir(5));
	immed5 <= immed_tmp_h5 & immed_tmp_l5;
	
	
	immed_tmp_l7 <= ir(7 DOWNTO 0);
	immed_tmp_h7 <= (others => ir(7));
	immed7 <= immed_tmp_h7 & immed_tmp_l7;
	
	WITH ir(15 DOWNTO 12) SELECT immed <=
		immed7 WHEN "0101", --moviments
		immed5 WHEN OTHERS;
		
	WITH ir(15 DOWNTO 12) SELECT wr_m <=
		'1' WHEN "0100", --store
		'1' WHEN "1110", --store byte
		'0' WHEN OTHERS;
		
	WITH ir(15 DOWNTO 12) SELECT in_d <= 
		'1' WHEN "0011", --load
		'1' WHEN "1101", --load byte
		'0' WHEN OTHERS;

	WITH code_op select rb_n <= 
		'1' when "0000", --aritmetico-logiques
		'1' when "0001", --comparacions
		'1' when "1000", --mult/div
		'0' when others;
		
	WITH ir(15 DOWNTO 12) SELECT immed_x2 <= 
		'1' WHEN "0011" , --load
		'1' WHEN "0100" , --store
		'0' WHEN OTHERS;
		
	WITH ir(15 DOWNTO 12) SELECT word_byte <=
		'1' WHEN "1101", --load byte
		'1' WHEN "1110", --store byte
		'0' WHEN OTHERS;
	
END Structure;