LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_unsigned.all;

ENTITY unidad_control IS
    PORT (boot      : IN  STD_LOGIC;
          clk       : IN  STD_LOGIC;
          datard_m  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		  tknbr	  : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
		  pc_alu	  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		  intr	  : IN  STD_LOGIC;
		  int_en	  : IN  STD_LOGIC;
		  int_out   : OUT STD_LOGIC;
          op        : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
		  f			  : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
          wrd       : OUT STD_LOGIC;
          addr_a    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_b    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_d    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
		  addr_io   : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		  rb_n	     : OUT STD_LOGIC;
          immed     : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
          pc        : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
          ins_dad   : OUT STD_LOGIC;
          in_d      : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		  wr_out	  : OUT STD_LOGIC;
		  rd_in 	  : OUT STD_LOGIC;
          immed_x2  : OUT STD_LOGIC;
          wr_m      : OUT STD_LOGIC;
          word_byte : OUT STD_LOGIC;
		  i_sys 	  : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		  d_sys  	  : OUT STD_LOGIC; 
		  a_sys  	  : OUT STD_LOGIC;
		  PC_up : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		  inta : OUT STD_LOGIC;
		  ill_inst : OUT STD_LOGIC;
		  exception : IN STD_LOGIC;
		  st_ld : OUT STD_LOGIC);
END unidad_control;


ARCHITECTURE Structure OF unidad_control IS
	COMPONENT control_l IS
		PORT (ir        : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
			  op        : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			  f			  : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			  ldpc      : OUT STD_LOGIC;
			  wrd       : OUT STD_LOGIC;
		      addr_a    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			  addr_b    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			  addr_d    : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			  rb_n		  : OUT STD_LOGIC;
			  immed     : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			  wr_m      : OUT STD_LOGIC;
			  in_d      : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
			  wr_out	  : OUT STD_LOGIC;
			  rd_in 	  : OUT STD_LOGIC;
			  immed_x2  : OUT STD_LOGIC;
			  word_byte : OUT STD_LOGIC;
			  i_sys 	  : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
			  d_sys  	  : OUT STD_LOGIC; 
			  a_sys  	  : OUT STD_LOGIC; 
			  inta	  	  : OUT STD_LOGIC;
			  ill_inst : OUT STD_LOGIC;
			  st_ld : OUT STD_LOGIC);
	END COMPONENT;
	
	COMPONENT multi is
		PORT (clk       : IN  STD_LOGIC;
			  boot      : IN  STD_LOGIC;
		      ldpc_l    : IN  STD_LOGIC;
			  wrd_l     : IN  STD_LOGIC;
		      wr_m_l    : IN  STD_LOGIC;
			  w_b       : IN  STD_LOGIC;
			  intr	 : IN  STD_LOGIC;
			  int_en	 : IN  STD_LOGIC;
			  inta_l : IN STD_LOGIC;
			  int_out 	 : OUT STD_LOGIC;
			  ldpc      : OUT STD_LOGIC;
			  wrd       : OUT STD_LOGIC;
			  wr_m      : OUT STD_LOGIC;
			  ldir      : OUT STD_LOGIC;
			  ins_dad   : OUT STD_LOGIC;
			  word_byte : OUT STD_LOGIC;
			  inta : OUT STD_LOGIC;
			  exception : IN STD_LOGIC);
	end COMPONENT;
	
	SIGNAL ldpc_s : STD_LOGIC; --senyal que surt de multi i utilitzada en el process
	SIGNAL ldpc_s0 : STD_LOGIC; --senyal "intermedia" entre control_l i multi
	SIGNAL new_pc : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL new_ir : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL immed_s : std_LOGIC_VECTOR (15 downto 0); --senyal inmediata intermitja
	SIGNAL ldir_s : STD_LOGIC;
	SIGNAL ir_s : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL wrd_s : STD_LOGIC;
	SIGNAL word_byte_s : STD_LOGIC;
	SIGNAL wr_m_s : STD_LOGIC;
	SIGNAL inta_s : STD_LOGIC;

BEGIN
	c0 : control_l PORT MAP(ir_s, op, f, ldpc_s0, wrd_s, addr_a, addr_b, addr_d, rb_n, immed_s, wr_m_s, 
									in_d, wr_out, rd_in, immed_x2, word_byte_s, i_sys, d_sys, a_sys, inta_s, ill_inst, st_ld);
	m0 : multi PORT MAP(clk, boot, ldpc_s0, wrd_s, wr_m_s, word_byte_s, intr, int_en, inta_s, int_out, ldpc_s, wrd, wr_m, ldir_s, ins_dad, word_byte, inta, exception);

	process(clk)
	begin
		if(rising_edge(clk)) then
			if (boot = '1') then
				new_pc <= x"C000";
				new_ir <= x"0000" ;
			else
				if(ldpc_s = '1') then
					case tknbr is
							  when "00" => new_pc <= new_pc + 2; -- seq. implicit
							  when "01" => new_pc <= new_pc + 2 + (immed_s(14 downto 0) & "0"); -- salts relatius
							  when "10" => new_pc <= pc_alu; -- salts absoluts
							  when others => new_pc <= x"0000"; -- TLB
					end case;						
				end if;
				if(ldir_s = '1') then
					new_ir <= datard_m;
				end if;
			end if;
		end if;
	end process;			
		
	immed <= immed_s;
	addr_io <= immed_s(7 DOWNTO 0); 
	pc <= new_pc;
	ir_s <= new_ir;
	PC_up <= new_pc;

END Structure;
