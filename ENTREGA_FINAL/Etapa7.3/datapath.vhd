LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_unsigned.all;

ENTITY datapath IS
    PORT (clk      : IN  STD_LOGIC;
		  boot     : IN STD_LOGIC;
          op       : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
		  f		    : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
          wrd      : IN  STD_LOGIC;
          addr_a   : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_b   : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_d   : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
		  rb_n	    : IN STD_LOGIC;
          immed    : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          immed_x2 : IN  STD_LOGIC;
          datard_m : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          ins_dad  : IN  STD_LOGIC;
          pc       : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          in_d     : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
		  rd_io 	 : IN  STD_LOGIC_VECTOR(15 downto 0);		
		  d_sys    : IN  STD_LOGIC; -- indica si 'd' s'escriu als sys_reg
		  a_sys    : IN  STD_LOGIC; -- indica si 'a' prové de sys_reg o de reg
		  int_out	    : IN  STD_LOGIC; -- indica que s'ha invocat una interrupcio
		  i_sys    : IN  STD_LOGIC_VECTOR(1 DOWNTO 0); -- indica instrucció que accedeix a sys_reg:
																		-- 00: -
																		-- 01: EI
																		-- 10: DI
																		-- 11: RETI
		  int_en   : OUT STD_LOGIC; 
		  wr_io 	 : OUT STD_LOGIC_VECTOR(15 downto 0);
		  tknbr	 : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		  pc_alu   : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
          addr_m   : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
          data_wr  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		  PC_up : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		  div_zero : OUT STD_LOGIC;
		  exception : IN STD_LOGIC;
		  code_excep : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		  mode_sys : OUT STD_LOGIC);
END datapath;


ARCHITECTURE Structure OF datapath IS
	COMPONENT alu IS
		PORT (x  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
			  y  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
			  op : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
			  f	 : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
			  w  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			  z  : OUT STD_LOGIC;
			  div_zero : OUT STD_LOGIC);
	END COMPONENT;
	
	COMPONENT regfile IS
    PORT (clk    : IN  STD_LOGIC;
		  boot   : IN  STD_LOGIC;
          wrd    : IN  STD_LOGIC;
          d      : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          addr_a : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_b : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_d : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
		  d_sys  : IN  STD_LOGIC; -- indica si 'd' s'escriu als sys_reg
		  a_sys  : IN  STD_LOGIC; -- indica si 'a' prové de sys_reg o de reg
		  int_out  : IN  STD_LOGIC; -- indica que s'ha invocat una interrupcio
		  i_sys  : IN  STD_LOGIC_VECTOR(1 DOWNTO 0); -- indica instrucció que accedeix a sys_reg:
																		-- 00: -
																		-- 01: EI
																		-- 10: DI
																		-- 11: RETI
		  int_en : OUT STD_LOGIC; 
          a      : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
          b      : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		  exception : IN STD_LOGIC;
		  code_excep : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		  addr_m : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		  mode_sys : OUT STD_LOGIC);
	END COMPONENT;
	
	SIGNAL a : STD_LOGIC_VECTOR(15 DOWNTO 0); 
	SIGNAL b : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL reg_b : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL alu_result : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL d : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL reg_d : STD_LOGIC_VECTOR(15 DOWNTO 0);
	signal immediat: STD_LOGIC_VECTOR(15 DOWNTO 0);
	signal zero: STD_LOGIC;
	signal tknbr_b: STD_LOGIC;
	signal tknbr_j: STD_LOGIC;
	signal reg_d_s: STD_LOGIC_VECTOR(15 DOWNTO 0);
	signal addr_a_s: STD_LOGIC_VECTOR(2 DOWNTO 0);
	signal addr_m_s : STD_LOGIC_VECTOR(15 DOWNTO 0);

BEGIN	
	WITH immed_x2 SELECT  immediat <= 
			immed WHEN '0',
			immed(14 DOWNTO 0) & '0' WHEN '1', --LD/ST
			x"0000" when others;
			
	WITH in_d SELECT d <= 
			rd_io WHEN "10",
			datard_m WHEN "01",
			alu_result WHEN OTHERS;
			
	WITH ins_dad SELECT addr_m_s <=
			alu_result WHEN '1',
			pc when '0',
			x"0000" when others;

	addr_m <= addr_m_s;
	
	-- TODO: determinar com fer arribar PC_up a regfile quan hi ha una interrupcio
	WITH op SELECT reg_d_s <=
			pc + 2 WHEN "101",
			d WHEN OTHERS;
	
	WITH int_out SELECT reg_d <=
		reg_d_s WHEN '0',
		PC_up WHEN OTHERS;

	WITH int_out SELECT addr_a_s <=
			addr_a WHEN '0',
			"101" WHEN OTHERS; --S5

	reg0: regfile PORT MAP (clk, boot, wrd, reg_d, addr_a, addr_b, addr_d, d_sys, a_sys, int_out, i_sys, int_en, a, reg_b, exception, code_excep, addr_m_s, mode_sys);

	WITH rb_n SELECT b <=
			immediat WHEN '0',
			reg_b WHEN '1',
			x"0000" WHEN others;
				
	alu0: alu PORT MAP (a, b, op, f, alu_result, zero,  div_zero);
	
	tknbr_b <= '1' WHEN (f = "000" and zero = '1') else --BZ
			   '1' WHEN (f = "001" and zero = '0') else --BNZ
			   '0';

	tknbr_j <= '1' WHEN (f = "000" and zero = '1') else --JZ
			   '1' WHEN (f = "001" and zero = '0') else --JNZ
			   '1' WHEN (f = "011") else --JMP
			   '1' WHEN (f = "100") else --JAL
			   '0'; 
	
	tknbr <= "10" WHEN ((op = "101" and tknbr_j = '1') or (op = "111") or (int_out = '1') ) else -- jump/RETI/sistema
			 "01" WHEN (op = "100" and tknbr_b = '1') else --branch
 			 "00";

	data_wr <= reg_b;
	pc_alu <= a;
	wr_io <= reg_b;
	
END Structure;