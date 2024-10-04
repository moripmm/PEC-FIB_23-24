LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY proc IS
    PORT (boot     : IN  STD_LOGIC;
          clk      : IN  STD_LOGIC;
          datard_m : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          addr_m   : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
END proc;


ARCHITECTURE Structure OF proc IS
	COMPONENT unidad_control IS
		 PORT (boot   : IN  STD_LOGIC;
				 clk    : IN  STD_LOGIC;
				 ir     : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
				 op     : OUT STD_LOGIC;
				 wrd    : OUT STD_LOGIC;
				 addr_a : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
				 addr_d : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
				 immed  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
				 pc     : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
	END COMPONENT;
	
	COMPONENT datapath IS
		PORT (clk    : IN STD_LOGIC;
				 op     : IN STD_LOGIC;
				 wrd    : IN STD_LOGIC;
				 addr_a : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
				 addr_d : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
				 immed  : IN STD_LOGIC_VECTOR(15 DOWNTO 0));
	END COMPONENT;
	signal op: STD_LOGIC;
	signal wrd: STD_LOGIC;
	signal addr_a : STD_LOGIC_VECTOR(2 DOWNTO 0);
	signal addr_d : STD_LOGIC_VECTOR(2 DOWNTO 0);
	signal immed: STD_LOGIC_VECTOR(15 DOWNTO 0);
    -- Aqui iria la declaracion de las entidades que vamos a usar
    -- Usaremos la palabra reservada COMPONENT ...
    -- Tambien crearemos los cables/buses (signals) necesarios para unir las entidades

BEGIN
	c0: unidad_control PORT MAP (boot, clk, datard_m, op, wrd, addr_a, addr_d, immed, addr_m);
	e0: datapath PORT MAP(clk, op, wrd, addr_a, addr_d, immed);
	
    -- Aqui iria la declaracion del "mapeo" (PORT MAP) de los nombres de las entradas/salidas de los componentes
    -- En los esquemas de la documentacion a la instancia del DATAPATH le hemos llamado e0 y a la de la unidad de control le hemos llamado c0

END Structure;