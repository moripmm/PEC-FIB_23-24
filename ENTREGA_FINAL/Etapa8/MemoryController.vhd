library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity MemoryController is
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
          SRAM_WE_N : out   std_logic := '1';
          --señales vga
          vga_addr : out std_logic_vector(12 downto 0);
          vga_we : out std_logic;
          vga_wr_data : out std_logic_vector(15 downto 0);
          vga_rd_data : in std_logic_vector(15 downto 0);
          vga_byte_m : out std_logic);
end MemoryController;

architecture comportament of MemoryController is
  COMPONENT SRAMController is
    port (clk         : in    std_logic;
          -- se�ales para la placa de desarrollo
          SRAM_ADDR   : out   std_logic_vector(17 downto 0);
          SRAM_DQ     : inout std_logic_vector(15 downto 0);
          SRAM_UB_N   : out   std_logic;
          SRAM_LB_N   : out   std_logic;
          SRAM_CE_N   : out   std_logic := '1';
          SRAM_OE_N   : out   std_logic := '1';
          SRAM_WE_N   : out   std_logic := '1';
          -- se�ales internas del procesador
          address     : in    std_logic_vector(15 downto 0) := "0000000000000000";
          dataReaded  : out   std_logic_vector(15 downto 0);
          dataToWrite : in    std_logic_vector(15 downto 0);
          WR          : in    std_logic;
          byte_m      : in    std_logic := '0');
  end COMPONENT;

  signal we2: std_logic;
  signal vga_mem: std_logic;
  signal rd_data2: std_logic_vector(15 downto 0); 
  
begin
  we2 <= we when addr < x"C000" else
         '0';
  
  sram: SRAMController port map (CLOCK_50, SRAM_ADDR, SRAM_DQ, SRAM_UB_N, SRAM_LB_N, SRAM_CE_N, SRAM_OE_N, SRAM_WE_N, addr, rd_data2, wr_data, we2, byte_m); 

  vga_mem <= '1' WHEN (addr >= x"A000" and addr <= x"BFFE") else
             '0';
  
  vga_addr <= addr(12 DOWNTO 0) WHEN (vga_mem = '1') else
              "0000000000000";

  vga_we <= we and vga_mem;

  vga_wr_data <= wr_data WHEN vga_mem = '1' else
                 x"0000";

  rd_data <= vga_rd_data WHEN vga_mem = '1' else
             rd_data2;

  vga_byte_m <= byte_m;

end comportament;
