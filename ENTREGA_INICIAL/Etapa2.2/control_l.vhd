LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY control_l IS
    PORT (ir        : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          op        : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
          ldpc      : OUT STD_LOGIC;
          wrd       : OUT STD_LOGIC;
          addr_a    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_b    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_d    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
          immed     : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
          wr_m      : OUT STD_LOGIC;
          in_d      : OUT STD_LOGIC;
          immed_x2  : OUT STD_LOGIC;
          word_byte : OUT STD_LOGIC);
END control_l;


ARCHITECTURE Structure OF control_l IS
SIGNAL code_op : STD_LOGIC_VECTOR (4 DOWNTO 0);
signal immed_tmp_h5 : STD_LOGIC_VECTOR(9 DOWNTO 0);
signal immed_tmp_l5 : STD_LOGIC_VECTOR(5 DOWNTO 0);
signal immed_tmp_h7 : STD_LOGIC_VECTOR(7 DOWNTO 0);
signal immed_tmp_l7 : STD_LOGIC_VECTOR(7 DOWNTO 0);
signal immed5 : STD_LOGIC_VECTOR(15 DOWNTO 0);
signal immed7 : STD_LOGIC_VECTOR(15 DOWNTO 0);


BEGIN

	 -- Aqui iria la generacion de las senales de control del datapath
	code_op <= ir(15 DOWNTO 12) & ir(8);
	WITH code_op SELECT op <= 
		"00" WHEN "01010",
		"01" WHEN "01011",
		"10" WHEN OTHERS;
	
	WITH ir SELECT ldpc <= 
		'0' WHEN (OTHERS => '1'),
		'1' WHEN OTHERS;
	
	WITH ir(15 DOWNTO 12) SELECT wrd <= 
		'1' WHEN "0101", --movhi i movi
		'1' WHEN "0011", --load
		'1' WHEN "1101", --loadbyte
		'0' WHEN OTHERS;
	
	WITH code_op SELECT addr_a <= 
		ir(11 DOWNTO 9) WHEN "01011",
		ir(8 DOWNTO 6) WHEN OTHERS;
	
	addr_b <= ir(11 DOWNTO 9);
	addr_d <= ir(11 DOWNTO 9);	
	
	
	immed_tmp_l5 <= ir(5 DOWNTO 0);
	immed_tmp_h5 <= (others => ir(5));
	immed5 <= immed_tmp_h5 & immed_tmp_l5;
	
	
	immed_tmp_l7 <= ir(7 DOWNTO 0);
	immed_tmp_h7 <= (others => ir(7));
	immed7 <= immed_tmp_h7 & immed_tmp_l7;
	
	WITH ir(15 DOWNTO 12) SELECT immed <=
		immed7 WHEN "0101",
		immed5 WHEN OTHERS;
		
	WITH ir(15 DOWNTO 12) SELECT wr_m <=
		'1' WHEN "0100",
		'1' WHEN "1110",
		'0' WHEN OTHERS;
		
	WITH ir(15 DOWNTO 12) SELECT in_d <= 
		'1' WHEN "0011",
		'1' WHEN "1101",
		'0' WHEN OTHERS;
		
	WITH ir(15 DOWNTO 12) SELECT immed_x2 <= 
		'1' WHEN "0011" ,
		'1' WHEN "0100" ,
		'0' WHEN OTHERS;
		
	WITH ir(15 DOWNTO 12) SELECT word_byte <= 
		'1' WHEN "1101",
		'1' WHEN "1110",
		'0' WHEN OTHERS;
		
	
		

END Structure;