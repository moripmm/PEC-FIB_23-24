LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all; --Esta libreria sera necesaria si usais conversiones CONV_INTEGER
--USE ieee.numeric_std.all;        --Esta libreria sera necesaria si usais conversiones TO_INTEGER

ENTITY regfile IS
    PORT (clk    : IN  STD_LOGIC;
		  boot   : IN  STD_LOGIC;
          wrd    : IN  STD_LOGIC;
          d      : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          addr_a : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_b : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_d : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
		  d_sys  : IN  STD_LOGIC; -- indica si 'd' s'escriu als sys_reg
		  a_sys  : IN  STD_LOGIC; -- indica si 'a' prové de sys_reg o de reg
		  int_out	  : IN  STD_LOGIC; -- indica que s'ha invocat una interrupcio
		  i_sys  : IN  STD_LOGIC_VECTOR(1 DOWNTO 0); -- indica instrucció que accedeix a sys_reg:
																		-- 00: -
																		-- 01: EI
																		-- 10: DI
																		-- 11: RETI
		  int_en : OUT STD_LOGIC; 
          a      : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
          b      : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
END regfile;

ARCHITECTURE Structure OF regfile IS
	type reg is array (7 DOWNTO 0) of std_logic_vector(15 DOWNTO 0); 
	signal registre: reg; --registres normals
	signal sregistre: reg; --registres sistema

BEGIN
	
	process(clk)
	begin
		if (rising_edge(clk)) then
			if boot='1' then --inizialització
				sregistre(7) <= x"0000";

			elsif (int_out = '1' and sregistre(7)(1) = '1') then 
				sregistre(0) <= sregistre(7);
				sregistre(1) <= d; -- pc_up  prove del bus d
				sregistre(2) <= x"000F"; --interrupcio
				sregistre(7)(1) <= '0'; -- inhibim interrupcions	

			elsif wrd = '1' then
				registre(conv_integer(addr_d)) <= d;
				
			elsif d_sys = '1' then 
				sregistre(conv_integer(addr_d)) <= d; --escr. sys_regfile

			else			
				case i_sys is 
					when "01" => sregistre(7)(1) <= '1'; -- EI
					when "10" => sregistre(7)(1) <= '0'; -- DI
					when "11" => sregistre(7) <= sregistre(0); --RETI
					when others => null;
				end case;
			end if;
		end if;
	end process;	
	
	int_en <= sregistre(7)(1); --bit interruption enable
	
	a <= sregistre(5) when int_out = '1' else -- quan hi hagi interrupcio
		 sregistre(1) when i_sys = "11" else -- quan hi hagi una instruccio RETI, enviem pc_new per "a"
		 sregistre(conv_integer(addr_a)) when a_sys='1' else 
		 registre(conv_integer(addr_a));
			
	b <= registre(conv_integer(addr_b));

END Structure;