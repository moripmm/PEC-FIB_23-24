library ieee;
USE ieee.std_logic_1164.all;

entity multi is
    port(clk       : IN  STD_LOGIC;
         boot      : IN  STD_LOGIC;
         ldpc_l    : IN  STD_LOGIC;
         wrd_l     : IN  STD_LOGIC;
         wr_m_l    : IN  STD_LOGIC;
         w_b       : IN  STD_LOGIC;
		 intr	 : IN  STD_LOGIC;
		 int_en	 : IN  STD_LOGIC;
		 inta_l : IN STD_LOGIC;
		 int_out   : OUT STD_LOGIC;
         ldpc      : OUT STD_LOGIC;
         wrd       : OUT STD_LOGIC;
         wr_m      : OUT STD_LOGIC;
         ldir      : OUT STD_LOGIC;
         ins_dad   : OUT STD_LOGIC;
         word_byte : OUT STD_LOGIC;
		 inta : OUT STD_LOGIC);
end entity;

architecture Structure of multi is

	type estat_t is (F, DEMW, SYS);
	signal estat: estat_t;

begin

	process(clk, boot)
	begin
		if boot = '1' then
			estat <= F;
			
		elsif (rising_edge(clk)) then
			if estat = F then
				estat <= DEMW;
				
			elsif estat = DEMW then
				if (intr = '1' and int_en = '1') then
					estat <= SYS;
				else 
					estat <= F;
				end if;
			elsif estat = SYS then
				estat <= F;
			end if;
		end if;
	end process;
	
	int_out <= '1' when estat = SYS else 
		       '0';

	ldpc <= ldpc_l when estat = DEMW or estat = SYS else 
			'0';

	wrd <= wrd_l when (estat = DEMW or estat = SYS) else 
		   '0';

	wr_m <= wr_m_l when estat = DEMW else 
		    '0';

	word_byte <= w_b when estat = DEMW else
				'0';

	ins_dad <= '0' when estat = F else 
		       '1';

	ldir <= '1' when estat = F else 
		    '0';

	inta <= inta_l when estat = DEMW else 
			'0';

end Structure;
