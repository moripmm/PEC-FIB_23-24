LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_unsigned.all;

ENTITY tlb IS
    PORT(clk     : IN STD_LOGIC;
         boot    : IN STD_LOGIC;
		 we_tlb  : IN STD_LOGIC; -- senyal de permis d'escriptura en tlb
		 phy_vir : IN STD_LOGIC; -- multiplexor virtual/physiques
		 flush   : IN STD_LOGIC; -- senyal de flush del tlb
         vtag    : IN STD_LOGIC_VECTOR(3 DOWNTO 0);  -- virtual tag
		 new_tag : IN STD_LOGIC_VECTOR(3 DOWNTO 0);  -- new tag a escriure si we_tlb = 1
		 wr_pos  : IN STD_LOGIC_VECTOR(4 DOWNTO 0);  -- posicio on escriure el new tag si wr = 1 (POSICIO : bits 2 DOWNTO 0 \\ LECTURA : bit 3 \\ VALID : bit 4)  
		 vpage   : OUT STD_LOGIC; -- pagina tlb valida (excepcio en cas de que no sigui valida - val 0 -)
		 rpage   : OUT STD_LOGIC; -- pagina tlb de lectura (excepcio en cas de que es volgues escriure - val 1 -)
		 miss   : OUT STD_LOGIC; -- pagina virtual tlb trobada (excepcio en cas de que no es trobi - val 0 -)
         ptag    : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)); -- physical tag
END tlb;

ARCHITECTURE Structure OF tlb IS
	TYPE vectag IS ARRAY (7 DOWNTO 0) of STD_LOGIC_VECTOR(3 DOWNTO 0); 
	SIGNAL vvectag: vectag; -- vector de tags virtuals
	SIGNAL pvectag: vectag; -- vector de tags fisics
	
	SIGNAL valvec: STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL rdvec: STD_LOGIC_VECTOR(7 DOWNTO 0);

	signal found: STD_LOGIC;
	signal num: STD_LOGIC_VECTOR(2 DOWNTO 0);

BEGIN
	PROCESS(clk, boot)
	BEGIN
		if rising_edge(clk) THEN
			if boot = '1' THEN -- inicialitzacio de la tlb
				-- 3 pag usuari
				vvectag(0) <= x"0"; -- escribible 
				pvectag(0) <= x"0";
				vvectag(1) <= x"1"; -- escribible
				pvectag(1) <= x"1";
				vvectag(2) <= x"2"; -- escribible
				pvectag(2) <= x"2";
				-- 5 pag sistema
				vvectag(3) <= x"8"; -- escribible
				pvectag(3) <= x"8";
				vvectag(4) <= x"C"; -- no escribible
				pvectag(4) <= x"C";
				vvectag(5) <= x"D"; -- no escribible
				pvectag(5) <= x"D";
				vvectag(6) <= x"E"; -- no escribible
				pvectag(6) <= x"E";
				vvectag(7) <= x"F"; -- no escribible
				pvectag(7) <= x"F";	
	
				-- init digits de control (validesa i read)
				valvec(7 DOWNTO 0) <= x"FF";
				rdvec(7 DOWNTO 0) <= x"00";
			
			elsif flush = '1' then
				valvec(7 DOWNTO 0) <= x"00";

			elsif we_tlb = '1' then
				if phy_vir = '1' then
					pvectag(conv_integer(wr_pos(2 DOWNTO 0))) <= new_tag;
					rdvec(conv_integer(wr_pos(2 DOWNTO 0))) <= wr_pos(3);
					valvec(conv_integer(wr_pos(2 DOWNTO 0))) <= wr_pos(4);
				else
					vvectag(conv_integer(wr_pos(2 DOWNTO 0))) <= new_tag;
				end if;
			end if;			
		end if;
	end process;

	found <= '1' WHEN (vtag = vvectag(0) or vtag = vvectag(1) or vtag = vvectag(2) or vtag = vvectag(3) or vtag = vvectag(4) or vtag = vvectag(5) or vtag = vvectag(6) or vtag = vvectag(7)) else
			 '0';

	num <= "000" WHEN vtag = vvectag(0) and found = '1' else
		   "001" WHEN vtag = vvectag(1) and found = '1'  else
		   "010" WHEN vtag = vvectag(2) and found = '1' else
		   "011" WHEN vtag = vvectag(3) and found = '1' else
		   "100" WHEN vtag = vvectag(4) and found = '1' else
		   "101" WHEN vtag = vvectag(5) and found = '1' else
		   "110" WHEN vtag = vvectag(6) and found = '1' else
		   "111" WHEN vtag = vvectag(7) and found = '1';
	
	miss <= '1' WHEN found = '0' else
			'0';

	ptag <= pvectag(conv_integer(num)) WHEN found = '1' else
			"0000";
	
	vpage <= valvec(conv_integer(num));
	rpage <= rdvec(conv_integer(num));


END Structure;