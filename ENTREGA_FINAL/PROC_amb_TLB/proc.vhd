LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY proc IS
    PORT (clk       : IN  STD_LOGIC;
          boot      : IN  STD_LOGIC;
          datard_m  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          addr_m    : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		  addr_io   : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
          data_wr   : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		  rd_in	  : OUT STD_LOGIC;
		  wr_out	  : OUT STD_LOGIC;
		  wr_io 	  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		  rd_io	  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          wr_m      : OUT STD_LOGIC;
          word_byte : OUT STD_LOGIC;
		  intr       : IN  STD_LOGIC;
		  inta : OUT STD_LOGIC);
END proc;

ARCHITECTURE Structure OF proc IS
	COMPONENT unidad_control IS
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
		  st_ld : OUT STD_LOGIC;
		  call : OUT STD_LOGIC;
		  inst_prot : OUT STD_LOGIC;
		  -- senyals tlb
		  we_tlb : OUT STD_LOGIC; 
		  inst_dad : OUT STD_LOGIC;
		  phy_vir : OUT STD_LOGIC;
		  flush : OUT STD_LOGIC);
END COMPONENT;

	COMPONENT datapath IS
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
		  mode_sys : OUT STD_LOGIC;
		  -- senyals tlb
		  we_tlb : IN STD_LOGIC; 
		  inst_dad : IN STD_LOGIC;
		  phy_vir : IN STD_LOGIC;
		  flush : IN STD_LOGIC;
		  vpagei   : OUT STD_LOGIC; -- pagina tlb instruccions valida (excepcio en cas de que no sigui valida - val 0 -)
		  rpagei   : OUT STD_LOGIC; -- pagina tlb instruccions de lectura (excepcio en cas de que es volgues escriure - val 1 -)
		  foundi   : OUT STD_LOGIC; -- pagina virtual tlb instruccions trobada (excepcio en cas de que no es trobi - val 0 -)	
		  vpaged   : OUT STD_LOGIC; -- pagina tlb dades valida (excepcio en cas de que no sigui valida - val 0 -)
		  rpaged   : OUT STD_LOGIC; -- pagina tlb dades de lectura (excepcio en cas de que es volgues escriure - val 1 -)
		  foundd   : OUT STD_LOGIC); -- pagina virtual tlb dades trobada (excepcio en cas de que no es trobi - val 0 -)
	END COMPONENT;

	COMPONENT exception_controller IS
		PORT (intr : IN STD_LOGIC;
			ill_inst : IN STD_LOGIC;
			mem_allign : IN STD_LOGIC;
			div_zero : IN STD_LOGIC;
			exception : OUT STD_LOGIC;
			code_excep : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			mem_prot : IN STD_LOGIC;
			inst_prot : IN STD_LOGIC;
			call : IN STD_LOGIC);
	END COMPONENT;
	
	signal op        : STD_LOGIC_VECTOR(2 DOWNTO 0);
	signal wrd       : STD_LOGIC;
	signal addr_a    : STD_LOGIC_VECTOR(2 DOWNTO 0);
	signal addr_b    : STD_LOGIC_VECTOR(2 DOWNTO 0);
	signal addr_d    : STD_LOGIC_VECTOR(2 DOWNTO 0);
	signal immed     : STD_LOGIC_VECTOR(15 DOWNTO 0);
	signal pc        : STD_LOGIC_VECTOR(15 DOWNTO 0);
	signal ins_dad   : STD_LOGIC;
	signal in_d      : STD_LOGIC_VECTOR(1 DOWNTO 0);
	signal immed_x2  : STD_LOGIC;
	signal f 		  : STD_LOGIC_VECTOR(2 DOWNTO 0);
	signal rb_n		  : STD_LOGIC;
	signal rd_io_s	  : std_logic_vector( 15 downto 0);			 
	signal wr_io_s	  : std_logic_vector(15 downto 0);
	signal tknbr 	  : STD_LOGIC_VECTOR(1 DOWNTO 0);
	signal pc_alu 	  : STD_LOGIC_VECTOR(15 DOWNTO 0);
	signal int_en_s  : STD_LOGIC;
	signal int_out_s : STD_LOGIC;
	signal i_sys_s   : STD_LOGIC_VECTOR(1 DOWNTO 0);
	signal a_sys_s   : STD_LOGIC;
	signal d_sys_s   : STD_LOGIC;
	signal PC_up_s : STD_LOGIC_VECTOR(15 DOWNTO 0);

	signal mem_allign_s : STD_LOGIC;
	signal ill_inst_s : STD_LOGIC;
	signal div_zero_s : STD_LOGIC;
	signal exception_s : STD_LOGIC;
	signal code_excep_s : STD_LOGIC_VECTOR(3 DOWNTO 0);
	signal word_byte_s : STD_LOGIC;
	signal addr_m_s : STD_LOGIC_VECTOR(15 DOWNTO 0);
	signal st_ld_s : STD_LOGIC;
	signal mem_prot_s : STD_LOGIC;
	signal call_s : STD_LOGIC;
	signal inst_prot_s : STD_LOGIC;
	signal inst_prot_s2 : STD_LOGIC;
	signal mode_sys_s : STD_LOGIC;
	signal ill_inst_s2 : STD_LOGIC;
	
	signal we_tlb_s :  STD_LOGIC; 
	signal inst_dad_s :  STD_LOGIC;
	signal phy_vir_s :  STD_LOGIC;
	signal flush_s: STD_LOGIC;
BEGIN
	rd_io_s <= rd_io;
	wr_io <= wr_io_s;
	word_byte <= word_byte_s;
	addr_m <= addr_m_s;

	mem_allign_s <= '1' WHEN (word_byte_s = '0' and addr_m_s(0) = '1' and st_ld_s = '1') else -- nose si hace falta: "and mode_sys_s = '0'"
					'0'; --acceso word en direccion de memoria impar en store/load y no estamos en modo sistema

	mem_prot_s <= '1' WHEN (addr_m_s >= x"8000" and mode_sys_s = '0' and st_ld_s = '1') else
				  '0'; --load/store a una posicio de memoria de sistema en mode usuari

	inst_prot_s2 <= '1' WHEN (inst_prot_s = '1' and mode_sys_s = '0') else
					'0'; --modo usuario y executa una instruccion de modo sistema

	ill_inst_s2 <= '1' WHEN (ill_inst_s = '1' or (mode_sys_s = '1' and call_s = '1')) else
				   '0'; --tambien es instruccion ilegal en caso de hacer call en modo sistema

	c0: unidad_control PORT MAP(boot, clk, datard_m, tknbr, pc_alu, intr, int_en_s, int_out_s, op, f, 
										wrd, addr_a, addr_b, addr_d, addr_io, rb_n, immed, pc, ins_dad, in_d, 
										wr_out, rd_in, immed_x2, wr_m, word_byte_s, i_sys_s, d_sys_s, a_sys_s, 
										PC_up_s, inta, ill_inst_s, exception_s, st_ld_s, call_s, inst_prot_s, 
										we_tlb_s, inst_dad_s, phy_vir_s, flush_s);
	e0: datapath PORT MAP(clk, boot, op, f, wrd, addr_a, addr_b, addr_d, rb_n, immed, immed_x2, datard_m, 
								ins_dad, pc, in_d, rd_io_s, d_sys_s, a_sys_s, int_out_s, i_sys_s, int_en_s, 
								wr_io_s, tknbr, pc_alu, addr_m_s, data_wr, PC_up_s, div_zero_s, exception_s, 
								code_excep_s, mode_sys_s, we_tlb_s,inst_dad_s, phy_vir_s, flush_s);

	excepctrl0: exception_controller PORT MAP (intr => intr,
											   ill_inst => ill_inst_s2,
											   mem_allign => mem_allign_s,
											   div_zero => div_zero_s,
											   exception => exception_s,
											   code_excep => code_excep_s,
											   mem_prot => mem_prot_s,
											   inst_prot => inst_prot_s2,
											   call => call_s);

END Structure;