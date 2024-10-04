LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY sisa IS
    PORT (CLOCK_50  : IN    STD_LOGIC;
          SRAM_ADDR : out   std_logic_vector(17 downto 0);
          SRAM_DQ   : inout std_logic_vector(15 downto 0);
          SRAM_UB_N : out   std_logic;
          SRAM_LB_N : out   std_logic;
          SRAM_CE_N : out   std_logic := '1';
          SRAM_OE_N : out   std_logic := '1';
          SRAM_WE_N : out   std_logic := '1';
          SW        : in std_logic_vector(9 downto 9));
END sisa;

ARCHITECTURE Structure OF sisa IS

COMPONENT proc IS
    PORT (clk       : IN  STD_LOGIC;
          boot      : IN  STD_LOGIC;
          datard_m  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
          addr_m    : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
          data_wr   : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
          wr_m      : OUT STD_LOGIC;
          word_byte : OUT STD_LOGIC);
END COMPONENT;

COMPONENT MemoryController is
    port (CLOCK_50  : in  std_logic;
			 addr      : in  std_logic_vector(15 downto 0);
          wr_data   : in  std_logic_vector(15 downto 0);
          rd_data   : out std_logic_vector(15 downto 0);
          we        : in  std_logic;
          byte_m    : in  std_logic;
          -- señales para la placa de desarrollo
          SRAM_ADDR : out   std_logic_vector(17 downto 0);
          SRAM_DQ   : inout std_logic_vector(15 downto 0);
          SRAM_UB_N : out   std_logic;
          SRAM_LB_N : out   std_logic;
          SRAM_CE_N : out   std_logic := '1';
          SRAM_OE_N : out   std_logic := '1';
          SRAM_WE_N : out   std_logic := '1');
END COMPONENT;


--signals de entradas al proc
SIGNAL boot_sig : STD_LOGIC;
SIGNAL rd_data_sig : STD_LOGIC_VECTOR(15 DOWNTO 0); --tambien signal de salida del memoryController
--signals de salida del proc
SIGNAL word_byte_sig : STD_LOGIC;
SIGNAL wr_m_sig : STD_LOGIC;
SIGNAL addr_m_sig : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL data_wr_sig : STD_LOGIC_VECTOR(15 DOWNTO 0);

SIGNAL clock_div : STD_LOGIC_VECTOR(2 DOWNTO 0):="000";


BEGIN
	process (CLOCK_50) begin
		if rising_edge(CLOCK_50) then
			clock_div<=clock_div+1;
		end if;
	end process;


	boot_sig <= SW(9);

	proc0: proc PORT MAP(clock_div(2), boot_sig, rd_data_sig, addr_m_sig,
				data_wr_sig, wr_m_sig, word_byte_sig);
	mem_controller0: MemoryController PORT MAP(CLOCK_50, addr_m_sig, data_wr_sig, 
				rd_data_sig, wr_m_sig, word_byte_sig, SRAM_ADDR, SRAM_DQ, SRAM_UB_N, 
				SRAM_LB_N, SRAM_CE_N, SRAM_OE_N, SRAM_WE_N);
END Structure;