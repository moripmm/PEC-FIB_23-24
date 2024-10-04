LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY datapath IS
    PORT (clk      : IN  STD_LOGIC;
          op       : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
          wrd      : IN  STD_LOGIC;
          addr_a   : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_b   : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_d   : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
          immed    : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          immed_x2 : IN  STD_LOGIC;
          datard_m : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          ins_dad  : IN  STD_LOGIC;
          pc       : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          in_d     : IN  STD_LOGIC;
          addr_m   : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
          data_wr  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
END datapath;


ARCHITECTURE Structure OF datapath IS
	COMPONENT alu IS
		PORT (x  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
				y  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
				op : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
				w  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
	END COMPONENT;
	
	COMPONENT regfile IS
		PORT (clk    : IN  STD_LOGIC;
				wrd    : IN  STD_LOGIC;
				d      : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
				addr_a : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
				addr_b : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
				addr_d : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
				a      : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
				b      : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
	END COMPONENT;
	
	SIGNAL a : STD_LOGIC_VECTOR(15 DOWNTO 0); 
	SIGNAL b : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL alu_result : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL d : STD_LOGIC_VECTOR(15 DOWNTO 0);

BEGIN
			
	reg0: regfile PORT MAP (clk, wrd, d, addr_a, addr_b, addr_d, a, data_wr);
	alu0: alu PORT MAP (a, b, op, alu_result);
	
	WITH immed_x2 SELECT b <= 
			immed WHEN '0',
			immed(14 DOWNTO 0) & '0' WHEN '1',
			x"0000" when others;
			
	WITH in_d SELECT d <= 
			alu_result WHEN '0',
			datard_m WHEN '1',
			x"0000" when others;
			
	WITH ins_dad SELECT addr_m <=
			alu_result WHEN '1',
			pc when '0',
			x"0000" when others;
	
END Structure;