LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY control_l IS
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
		  st_ld : OUT STD_LOGIC;
		  call : OUT STD_LOGIC;
		  inst_prot : OUT STD_LOGIC); 
END control_l;


ARCHITECTURE Structure OF control_l IS
SIGNAL code_op : STD_LOGIC_VECTOR (3 DOWNTO 0);
signal immed_tmp_h5 : STD_LOGIC_VECTOR(9 DOWNTO 0);
signal immed_tmp_l5 : STD_LOGIC_VECTOR(5 DOWNTO 0);
signal immed_tmp_h7 : STD_LOGIC_VECTOR(7 DOWNTO 0);
signal immed_tmp_l7 : STD_LOGIC_VECTOR(7 DOWNTO 0);
signal immed5 : STD_LOGIC_VECTOR(15 DOWNTO 0);
signal immed7 : STD_LOGIC_VECTOR(15 DOWNTO 0);
signal f_s : STD_LOGIC_VECTOR(2 DOWNTO 0);

BEGIN

	code_op <= ir(15 DOWNTO 12);
	
	op <= "001" when code_op = "0001" else --comparacions
       	  "010" when code_op = "0101" else --moviments
          "011" when code_op = "1000" else  --mult/div
          "100" when code_op = "0110" else --branch
          "101" when code_op = "1010" else --salts
          "110" when code_op = "0111" else --IO
		  "111" when (code_op = "1111" and ir(5 DOWNTO 0) = "100100") else --RETI
          "000"; --aritmetico-logiques/addi/store/load

	
	f_s <= ir(5 DOWNTO 3) when code_op = "0000" else -- aritmetico-logiques
		 ir(5 DOWNTO 3) when code_op = "0001" else -- comparacions
		 "00" & ir(8) when code_op = "0101" else -- moviments
		 ir(5 DOWNTO 3) when code_op = "1000" else -- mult/div
		 "00" & ir(8) when code_op = "0110" else -- branch
		 ir(2 DOWNTO 0) when code_op = "1010" else -- salts
		 "00" & ir(8) when code_op = "0111" else -- IO
		 "100"; -- load/store/addi

	f <= f_s;

	
	WITH ir SELECT ldpc <= 
		'0' WHEN (OTHERS => '1'), --halt
		'1' WHEN OTHERS;
	
	wrd <= '0' WHEN code_op = "0100" else --ST
		   '0' WHEN code_op = "1110" else --STB
		   '0' WHEN code_op = "0110" else --branch
		   '0' WHEN (code_op = "1010" AND ir(2 DOWNTO 0) < "100") else --salts
		   '0' WHEN ir = x"FFFF" else --HALT
		   '0' WHEN (code_op = "0111" and ir(8) = '1') else --OUT
		   '0' WHEN (code_op = "1111" and (ir(5 DOWNTO 0) = "110000" or ir(5 DOWNTO 0) = "100000" or ir(5 DOWNTO 0) = "100001" or ir(5 DOWNTO 0) = "100100") ) else -- WRS/EI/DI/RETI
		   '1' ; --RDS/GETTID
	
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
		immed7 WHEN "0110", --branch
		immed7 WHEN "0111", --IN/OUT
		x"0000" WHEN "1111", --WRS/RDS
		immed5 WHEN OTHERS;
		
	WITH ir(15 DOWNTO 12) SELECT wr_m <=
		'1' WHEN "0100", --store
		'1' WHEN "1110", --store byte
		'0' WHEN OTHERS;
		
	in_d <=  "01" WHEN ir(15 DOWNTO 12) = "0011" else --load
			 "01" WHEN ir(15 DOWNTO 12) = "1101" else  --load byte
			 "10" WHEN ir(15 DOWNTO 12) = "0111" else --IO
			 "10" WHEN  ir(15 DOWNTO 12) = "1111" and ir(5 DOWNTO 0) = "101000" else --GETTID
			 "00";

	rb_n <= '1' when code_op = "0000" else -- aritmetico-logiques
        	'1' when code_op = "0001" else -- comparacions
        	'1' when code_op = "1000" else -- mult/div
        	'1' when code_op = "0110" else -- branch
        	'1' when code_op = "1010" else -- salts
        	'0'; 
		
	WITH ir(15 DOWNTO 12) SELECT immed_x2 <= 
		'1' WHEN "0011" , --load
		'1' WHEN "0100" , --store
		'1' WHEN "0110" , --branch
		'0' WHEN OTHERS;
	
	wr_out <= '1' WHEN (code_op = "0111" AND ir(8) = '1')  -- OUT
						ELSE '0';
	
	rd_in <= '1' WHEN (code_op = "0111" AND ir(8) = '0')  -- IN
						ELSE '0';
		
	WITH ir(15 DOWNTO 12) SELECT word_byte <= 
		'1' WHEN "1101", --load byte
		'1' WHEN "1110", --store byte
		'0' WHEN OTHERS;
		
	i_sys <= "01" WHEN (ir(15 DOWNTO 12) = "1111" AND ir(5 DOWNTO 0) = "100000") ELSE -- EI
			 "10" WHEN (ir(15 DOWNTO 12) = "1111" AND ir(5 DOWNTO 0) = "100001") ELSE -- DI
			 "11" WHEN (ir(15 DOWNTO 12) = "1111" AND ir(5 DOWNTO 0) = "100100") ELSE -- RETI
			 "00";
					  
	d_sys <= '1'  WHEN (ir(15 DOWNTO 12) = "1111" and ir(5 DOWNTO 0) = "110000") else -- WRS
			 '0';																			 				 -- altres
	
	a_sys <= '1' WHEN (ir(15 DOWNTO 12) = "1111" and ir(5 DOWNTO 0) = "101100") else -- RDS
			 '0';	
	
	inta <= '1' WHEN ir(15 DOWNTO 12) = "1111" and ir(5 DOWNTO 0) = "101000" else --GETTID
			'0';

	ill_inst <= '1' when (code_op = "0001" and (f_s = "010" or f_s = "110" or f_s = "111")) or --comparaciones no usadas
						 (code_op = "1000" and (f_s = "011" or f_s = "110" or f_s = "111")) or --mult/div no usadas
						 (code_op = "1001") or --aritmeticologicas/comparaciones de float
						 (code_op = "1010" and (f_s = "010" or  f_s = "101" or f_s = "110" or ir(5 downto 0) > "000111")) or --saltos no usados
						 (code_op = "1011") or --LDF
						 (code_op = "1100") or --STF
						 (code_op = "1111" and ir(5 downto 0) /= "111111" and (ir(5)='0' or ((ir(0) = '1' or ir(1) = '1') and ir(5 downto 0) /= "100001") or (ir(5 downto 0) > "110000"))) --instrucciones especiales
						 else '0';
	
	-- ill_inst <= '0' WHEN ir(15 downto 12) = "0000" else --artimetico-logiques
	-- 			'0' WHEN ir(15 downto 12) = "0001" and ir(5 DOWNTO 3) = "000" else --CMPLT
	-- 			'0' WHEN ir(15 downto 12) = "0001" and ir(5 DOWNTO 3) = "001" else --CMPLE
	-- 			'0' WHEN ir(15 downto 12) = "0001" and ir(5 DOWNTO 3) = "011" else --CMPEQ
	-- 			'0' WHEN ir(15 downto 12) = "0001" and ir(5 DOWNTO 3) = "100" else --CMPLTU
	-- 			'0' WHEN ir(15 downto 12) = "0001" and ir(5 DOWNTO 3) = "101" else --CMPLEU
	-- 			'0' WHEN ir(15 downto 12) = "0010" else --ADDI
	-- 			'0' WHEN ir(15 downto 12) = "0011" else --LD
	-- 			'0' WHEN ir(15 downto 12) = "0100" else --ST
	-- 			'0' WHEN ir(15 downto 12) = "0101" else --MOVI/MOVHI
	-- 			'0' WHEN ir(15 downto 12) = "0110" else --BZ/BNZ
	-- 			'0' WHEN ir(15 downto 12) = "0111" else --IN/OUT
	-- 			'0' WHEN ir(15 downto 12) = "1000" and ir(5 DOWNTO 3) = "000" else --MUL
	-- 			'0' WHEN ir(15 downto 12) = "1000" and ir(5 DOWNTO 3) = "001" else --MULH
	-- 			'0' WHEN ir(15 downto 12) = "1000" and ir(5 DOWNTO 3) = "010" else --MULHU
	-- 			'0' WHEN ir(15 downto 12) = "1000" and ir(5 DOWNTO 3) = "100" else --DIV
	-- 			'0' WHEN ir(15 downto 12) = "1000" and ir(5 DOWNTO 3) = "101" else --DIVU
	-- 			'0' WHEN ir(15 downto 12) = "1010" and ir(5 DOWNTO 0) = "000000" else --JZ
	-- 			'0' WHEN ir(15 downto 12) = "1010" and ir(5 DOWNTO 0) = "000001" else --JNZ
	-- 			'0' WHEN ir(15 downto 12) = "1010" and ir(5 DOWNTO 0) = "000011" else --JMP
	-- 			'0' WHEN ir(15 downto 12) = "1010" and ir(5 DOWNTO 0) = "000100" else --JAL
	-- 			'0' WHEN ir(15 downto 12) = "1010" and ir(5 DOWNTO 0) = "000111" else --CALLS
	-- 			'0' WHEN ir(15 downto 12) = "1101" else --LDB
	-- 			'0' WHEN ir(15 downto 12) = "1110" else --STB
	-- 			'0' WHEN ir(15 downto 12) = "1111" and ir(5 DOWNTO 0) = "100000" else --EI
	-- 			'0' WHEN ir(15 downto 12) = "1111" and ir(5 DOWNTO 0) = "100001" else --DI
	-- 			'0' WHEN ir(15 downto 12) = "1111" and ir(5 DOWNTO 0) = "100100" else --RETI
	-- 			'0' WHEN ir(15 downto 12) = "1111" and ir(5 DOWNTO 0) = "101000" else --GETIID
	-- 			'0' WHEN ir(15 downto 12) = "1111" and ir(5 DOWNTO 0) = "101100" else --RDS
	-- 			'0' WHEN ir(15 downto 12) = "1111" and ir(5 DOWNTO 0) = "110000" else --WRS
	-- 			'0' WHEN ir(15 downto 12) = "1111" and ir(5 DOWNTO 0) = "111111" else --HALT
	-- 			'1';

	st_ld <= '1' WHEN (code_op = "0011" or code_op = "0100") else --LD/ST
			 '0';

	call <= '1' WHEN code_op = "1010" and ir(2 DOWNTO 0) = "111" else
			'0';

	inst_prot <= '1' WHEN code_op = "1111" and ir(5 DOWNTO 0) = "100000" else --EI
				 '1' WHEN code_op = "1111" and ir(5 DOWNTO 0) = "100001" else --DI
				 '1' WHEN code_op = "1111" and ir(5 DOWNTO 0) = "100100" else --RETI
				 '1' WHEN code_op = "1111" and ir(5 DOWNTO 0) = "101000" else --GETIID
				 '1' WHEN code_op = "1111" and ir(5 DOWNTO 0) = "101100" else --RDS
				 '1' WHEN code_op = "1111" and ir(5 DOWNTO 0) = "110000" else --WRS
				 '0';

END Structure;