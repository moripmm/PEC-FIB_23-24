LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_unsigned.all;

ENTITY unidad_control IS
    PORT (boot   : IN  STD_LOGIC;
          clk    : IN  STD_LOGIC;
          ir     : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          op     : OUT STD_LOGIC;
          wrd    : OUT STD_LOGIC;
          addr_a : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_d : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
          immed  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
          pc     : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
END unidad_control;

ARCHITECTURE Structure OF unidad_control IS
COMPONENT control_l IS
    PORT (ir     : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          op     : OUT STD_LOGIC;
          ldpc   : OUT STD_LOGIC;
          wrd    : OUT STD_LOGIC;
          addr_a : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
          addr_d : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
          immed  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
END COMPONENT;

signal new_pc: STD_LOGIC_VECTOR(15 DOWNTO 0);
signal lpcd: STD_LOGIC;

    -- Aqui iria la declaracion de las entidades que vamos a usar
    -- Usaremos la palabra reservada COMPONENT ...
    -- Tambien crearemos los cables/buses (signals) necesarios para unir las entidades
    -- Aqui iria la definicion del program counter

BEGIN
	c0: control_l PORT MAP(ir, op, lpcd, wrd, addr_a, addr_d, immed);
	
	process(clk)
	begin
		if(rising_edge(clk)) then
			if (boot = '1') then
				new_pc <= x"C000";
			else
				if(lpcd = '1') then
					new_pc <= new_pc + x"0002";
				end if;
			end if;
		end if;
	end process;	
			
	--new_pc <= new_pc + x"0002" when rising_edge(clk) and boot = '0' and lpcd = '1'
				 --else new_pc when rising_edge(clk) and boot = '0' and lpcd = '0'
				 --else x"C000" when rising_edge(clk) and boot = '1'; 
	
	pc <= new_pc;
	
    -- Aqui iria la declaracion del "mapeo" (PORT MAP) de los nombres de las entradas/salidas de los componentes
    -- En los esquemas de la documentacion a la instancia de la logica de control le hemos llamado c0
    -- Aqui iria la definicion del comportamiento de la unidad de control y la gestion del PC

END Structure;