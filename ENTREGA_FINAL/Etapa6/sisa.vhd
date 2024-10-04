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
		  LEDG 	  : OUT STD_LOGIC_VECTOR(7 DOWNTO 0); 
		  LEDR 	  : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		  HEX0 	  : OUT STD_LOGIC_VECTOR(6 DOWNTO 0); 
		  HEX1 	  : OUT STD_LOGIC_VECTOR(6 DOWNTO 0); 
		  HEX2 	  : OUT STD_LOGIC_VECTOR(6 DOWNTO 0); 
		  HEX3 	  : OUT STD_LOGIC_VECTOR(6 DOWNTO 0); 
          SW        : in std_logic_vector(9 DOWNTO 0);
		  KEY		  : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
          ps2_clk   : inout std_logic; 
		  ps2_dat	  : inout std_logic;
		  VGA_R     : OUT std_logic_vector(3 downto 0);
		  VGA_G     : OUT std_logic_vector(3 downto 0);
		  VGA_B     : OUT std_logic_vector(3 downto 0);
		  VGA_HS : OUT std_logic;
		  VGA_VS : OUT std_logic); 

END sisa;

ARCHITECTURE Structure OF sisa IS

COMPONENT proc IS
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
          word_byte : OUT STD_LOGIC);
END COMPONENT;

COMPONENT MemoryController is
    port (CLOCK_50  : in  std_logic;
			 addr      : in  std_logic_vector(15 downto 0);
          wr_data   : in  std_logic_vector(15 downto 0);
          rd_data   : out std_logic_vector(15 downto 0);
          we        : in  std_logic;
          byte_m    : in  std_logic;
          -- seÃ±ales para la placa de desarrollo
          SRAM_ADDR : out   std_logic_vector(17 downto 0);
          SRAM_DQ   : inout std_logic_vector(15 downto 0);
          SRAM_UB_N : out   std_logic;
          SRAM_LB_N : out   std_logic;
          SRAM_CE_N : out   std_logic := '1';
          SRAM_OE_N : out   std_logic := '1';
          SRAM_WE_N : out   std_logic := '1';
          vga_addr : out std_logic_vector(12 downto 0);
		  vga_we : out std_logic;
		  vga_wr_data : out std_logic_vector(15 downto 0);
		  vga_rd_data : in std_logic_vector(15 downto 0);
		  vga_byte_m : out std_logic );
END COMPONENT;

COMPONENT controladores_IO IS
    PORT (boot : IN STD_LOGIC;
          CLOCK_50 : IN std_logic;
          addr_io : IN std_logic_vector(7 downto 0);
          wr_io : in std_logic_vector(15 downto 0);
          rd_io : out std_logic_vector(15 downto 0);
          wr_out : in std_logic;
          rd_in : in std_logic;
          led_verdes : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
          led_rojos : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
          HEX0 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
          HEX1 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
          HEX2 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
          HEX3 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
          SW : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
          KEY : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
          ps2_clk : INOUT STD_LOGIC;
          ps2_data : INOUT STD_LOGIC);
END COMPONENT;

COMPONENT vga_controller is
    port(clk_50mhz      : in  std_logic; -- system clock signal
         reset          : in  std_logic; -- system reset
         blank_out      : out std_logic; -- vga control signal
         csync_out      : out std_logic; -- vga control signal
         red_out        : out std_logic_vector(7 downto 0); -- vga red pixel value
         green_out      : out std_logic_vector(7 downto 0); -- vga green pixel value
         blue_out       : out std_logic_vector(7 downto 0); -- vga blue pixel value
         horiz_sync_out : out std_logic; -- vga control signal
         vert_sync_out  : out std_logic; -- vga control signal
         --
         addr_vga          : in std_logic_vector(12 downto 0);
         we                : in std_logic;
         wr_data           : in std_logic_vector(15 downto 0);
         rd_data           : out std_logic_vector(15 downto 0);
         byte_m            : in std_logic;
         vga_cursor        : in std_logic_vector(15 downto 0);  -- simplemente lo ignoramos, este controlador no lo tiene implementado
         vga_cursor_enable : in std_logic);                     -- simplemente lo ignoramos, este controlador no lo tiene implementado
END COMPONENT;


--signals de entradas al proc
SIGNAL boot_sig : STD_LOGIC;
SIGNAL rd_data_sig : STD_LOGIC_VECTOR(15 DOWNTO 0); --tambien signal de salida del memoryController
SIGNAL rd_io_sig : STD_LOGIC_VECTOR(15 DOWNTO 0);
--signals de salida del proc
SIGNAL word_byte_sig : STD_LOGIC;
SIGNAL wr_m_sig : STD_LOGIC;
SIGNAL addr_m_sig : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL data_wr_sig : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL addr_io_sig : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL wr_io_sig : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL wr_out_sig : STD_LOGIC;
SIGNAL rd_in_sig : STD_LOGIC;
--signals de salida del IO_controller
SIGNAL hex0_sig: STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL key_sig : STD_LOGIC_VECTOR(3 DOWNTO 0);
--clock divisor
SIGNAL clock_div : STD_LOGIC_VECTOR(2 DOWNTO 0):="000";
--signals temporals vga_controller
SIGNAL VGA_R_sig, VGA_B_sig, VGA_G_sig : STD_LOGIC_VECTOR(7 DOWNTO 0);
--signals sortida mem_controller
SIGNAL vga_addr_sig : std_logic_vector(12 downto 0);
SIGNAL vga_we_sig, vga_byte_m_sig: std_logic;
SIGNAL vga_wr_data_sig, vga_rd_data_sig: std_logic_vector(15 downto 0);

BEGIN
	process (CLOCK_50) begin
		if rising_edge(CLOCK_50) then
			clock_div<=clock_div+1;
		end if;
	end process;


	boot_sig <= SW(9);
	key_sig <= KEY;
	proc0: proc PORT MAP (clk => clock_div(2),
                          boot => boot_sig,
                          datard_m => rd_data_sig,
                          addr_m => addr_m_sig,
                          addr_io => addr_io_sig,
                          data_wr => data_wr_sig,
                          rd_in => rd_in_sig,
                          wr_out => wr_out_sig,
                          wr_io => wr_io_sig,
                          rd_io => rd_io_sig,
                          wr_m => wr_m_sig,
                          word_byte => word_byte_sig);

	mem_controller0: MemoryController PORT MAP (CLOCK_50 => CLOCK_50, 
                                                addr => addr_m_sig, 
                                                wr_data => data_wr_sig, 
                                                rd_data => rd_data_sig, 
                                                we => wr_m_sig, 
                                                byte_m =>word_byte_sig, 
                                                SRAM_ADDR => SRAM_ADDR, 
                                                SRAM_DQ => SRAM_DQ, 
                                                SRAM_UB_N => SRAM_UB_N, 
                                                SRAM_LB_N => SRAM_LB_N, 
                                                SRAM_CE_N => SRAM_CE_N, 
                                                SRAM_OE_N => SRAM_OE_N, 
                                                SRAM_WE_N => SRAM_WE_N, 
                                                vga_addr => vga_addr_sig, 
                                                vga_we => vga_we_sig, 
                                                vga_wr_data => vga_wr_data_sig, 
                                                vga_rd_data => vga_rd_data_sig, 
                                                vga_byte_m => vga_byte_m_sig);

	IO_controller0: controladores_IO PORT MAP (boot => boot_sig, 
                                               CLOCK_50 => CLOCK_50, 
                                               addr_io => addr_io_sig, 
                                               wr_io => wr_io_sig, 
                                               rd_io => rd_io_sig, 
                                               wr_out => wr_out_sig, 
                                               rd_in => rd_in_sig, 
                                               led_verdes => LEDG, 
                                               led_rojos => LEDR, 
                                               HEX0 => HEX0, 
                                               HEX1 => HEX1, 
                                               HEX2 => HEX2, 
                                               HEX3 => HEX3, 
                                               SW => SW, 
                                               KEY => key_sig, 
                                               ps2_clk => ps2_clk, 
                                               ps2_data =>ps2_dat);

    vga_controller0: vga_controller PORT MAP (clk_50mhz => CLOCK_50, 
                                              reset => boot_sig, 
                                              red_out => VGA_R_sig, 
                                              green_out => VGA_G_sig, 
                                              blue_out => VGA_B_sig, 
                                              horiz_sync_out => VGA_HS, 
                                              vert_sync_out => VGA_VS, 
                                              addr_vga => vga_addr_sig, 
                                              we => vga_we_sig, 
                                              wr_data => vga_wr_data_sig, 
                                              rd_data => vga_rd_data_sig, 
                                              byte_m =>vga_byte_m_sig, 
                                              vga_cursor => x"0000", 
                                              vga_cursor_enable => '0');

    VGA_R <= VGA_R_sig(3 DOWNTO 0);
    VGA_B <= VGA_B_sig(3 DOWNTO 0);
    VGA_G <= VGA_G_sig(3 DOWNTO 0);


END Structure;