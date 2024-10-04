LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY proc IS
    PORT (clk       : IN  STD_LOGIC;
          boot      : IN  STD_LOGIC;
          datard_m  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          addr_m    : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
          data_wr   : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
          wr_m      : OUT STD_LOGIC;
          word_byte : OUT STD_LOGIC);
END proc;

ARCHITECTURE Structure OF proc IS
	COMPONENT unidad_control IS
		 PORT (boot      : IN  STD_LOGIC;
				 clk       : IN  STD_LOGIC;
				 datard_m  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
				 op        : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
				 f 		   : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
				 wrd       : OUT STD_LOGIC;
				 addr_a    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
				 addr_b    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
				 addr_d    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
				 rb_n	   : OUT STD_LOGIC;
				 immed     : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
				 pc        : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
				 ins_dad   : OUT STD_LOGIC;
				 in_d      : OUT STD_LOGIC;
				 immed_x2  : OUT STD_LOGIC;
				 wr_m      : OUT STD_LOGIC;
				 word_byte : OUT STD_LOGIC);
	END COMPONENT;

	COMPONENT datapath IS
		 PORT (clk      : IN  STD_LOGIC;
				 op       : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
				 f 		  : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
				 wrd      : IN  STD_LOGIC;
				 addr_a   : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
				 addr_b   : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
				 addr_d   : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
				 rb_n	  : IN STD_LOGIC;
				 immed    : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
				 immed_x2 : IN  STD_LOGIC;
				 datard_m : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
				 ins_dad  : IN  STD_LOGIC;
				 pc       : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
				 in_d     : IN  STD_LOGIC;
				 addr_m   : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
				 data_wr  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
	END COMPONENT;
	
	signal op        : STD_LOGIC_VECTOR(1 DOWNTO 0);
	signal wrd       : STD_LOGIC;
	signal addr_a    : STD_LOGIC_VECTOR(2 DOWNTO 0);
	signal addr_b    : STD_LOGIC_VECTOR(2 DOWNTO 0);
	signal addr_d    : STD_LOGIC_VECTOR(2 DOWNTO 0);
	signal immed     : STD_LOGIC_VECTOR(15 DOWNTO 0);
	signal pc        : STD_LOGIC_VECTOR(15 DOWNTO 0);
	signal ins_dad   : STD_LOGIC;
	signal in_d      : STD_LOGIC;
	signal immed_x2  : STD_LOGIC;
	signal f 		 : STD_LOGIC_VECTOR(2 DOWNTO 0);
	signal rb_n		 : STD_LOGIC;

BEGIN

	c0: unidad_control PORT MAP(boot, clk, datard_m, op, f, wrd, addr_a, addr_b, addr_d, rb_n, immed, pc, ins_dad, in_d, immed_x2, wr_m, word_byte);
	e0: datapath PORT MAP(clk, op, f, wrd, addr_a, addr_b, addr_d, rb_n, immed, immed_x2, datard_m, ins_dad, pc, in_d, addr_m, data_wr);

END Structure;