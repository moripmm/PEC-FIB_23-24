LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_unsigned.all;

ENTITY unidad_control IS
    PORT (boot      : IN  STD_LOGIC;
          clk       : IN  STD_LOGIC;
          datard_m  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          op        : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
          wrd       : OUT STD_LOGIC;
          addr_a    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_b    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_d    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
          immed     : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
          pc        : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
          ins_dad   : OUT STD_LOGIC;
          in_d      : OUT STD_LOGIC;
          immed_x2  : OUT STD_LOGIC;
          wr_m      : OUT STD_LOGIC;
          word_byte : OUT STD_LOGIC);
END unidad_control;




ARCHITECTURE Structure OF unidad_control IS
	COMPONENT control_l IS
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
	END COMPONENT;
	
	COMPONENT multi is
		 port(clk       : IN  STD_LOGIC;
				boot      : IN  STD_LOGIC;
				ldpc_l    : IN  STD_LOGIC;
				wrd_l     : IN  STD_LOGIC;
				wr_m_l    : IN  STD_LOGIC;
				w_b       : IN  STD_LOGIC;
				ldpc      : OUT STD_LOGIC;
				wrd       : OUT STD_LOGIC;
				wr_m      : OUT STD_LOGIC;
				ldir      : OUT STD_LOGIC;
				ins_dad   : OUT STD_LOGIC;
				word_byte : OUT STD_LOGIC);
	end COMPONENT;
	
SIGNAL ldpc_s : STD_LOGIC; --senyal que surt de multi i utilitzada en el process
SIGNAL ldpc_s0 : STD_LOGIC; --senyal "intermedia" entre control_l i multi
SIGNAL new_pc : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL new_ir : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL ldir_s : STD_LOGIC;
SIGNAL ir_s : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL wrd_s : STD_LOGIC;
SIGNAL word_byte_s : STD_LOGIC;
SIGNAL wr_m_s : STD_LOGIC;

BEGIN
	c0 : control_l PORT MAP(ir_s, op, ldpc_s0, wrd_s, addr_a, addr_b, addr_d, immed, wr_m_s, in_d, immed_x2, word_byte_s);
	m0: multi PORT MAP(clk, boot, ldpc_s0, wrd_s, wr_m_s, word_byte_s, ldpc_s, wrd, wr_m, ldir_s, ins_dad, word_byte);
	process(clk)
	begin
		if(rising_edge(clk)) then
			if (boot = '1') then
				new_pc <= x"C000";
				new_ir <= x"0000" ;
			else
				if(ldpc_s = '1') then
					new_pc <= new_pc + x"0002";
				end if;
				if(ldir_s = '1') then
					new_ir <= datard_m;
				end if;
			end if;
		end if;
	end process;
	
	pc <= new_pc;
	ir_s <= new_ir;

END Structure;
