


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

ENTITY controladores_IO IS
    PORT (boot : IN STD_LOGIC;
          CLOCK_50 : IN std_logic;
          addr_io : IN std_logic_vector(7 downto 0);
          wr_io : in std_logic_vector(15 downto 0);
          rd_io : out std_logic_vector(15 downto 0);
          wr_out : in std_logic;
          rd_in : in std_logic;
          led_verdes : OUT STD_LOGIC_VECTOR(7 DOWNTO 0) := x"FF";
          led_rojos : OUT STD_LOGIC_VECTOR(7 DOWNTO 0) := x"FF";
          HEX0 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
          HEX1 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
          HEX2 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
          HEX3 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
          SW : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
          KEY : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
          ps2_clk : INOUT STD_LOGIC;
          ps2_data : INOUT STD_LOGIC);
END controladores_IO;

ARCHITECTURE Structure OF controladores_IO IS
    COMPONENT driver4Display IS
    PORT( caract : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
          HEX0   : OUT std_logic_vector(6 downto 0);
          HEX1   : OUT std_logic_vector(6 downto 0);
          HEX2   : OUT std_logic_vector(6 downto 0);
          HEX3   : OUT std_logic_vector(6 downto 0);
          visor  : IN STD_LOGIC_VECTOR(3 DOWNTO 0));
    END COMPONENT;

    COMPONENT keyboard_controller IS
    PORT (clk        : in    STD_LOGIC;
          reset      : in    STD_LOGIC;
          ps2_clk    : inout STD_LOGIC;
          ps2_data   : inout STD_LOGIC;
          read_char  : out   STD_LOGIC_VECTOR (7 downto 0);
          clear_char : in    STD_LOGIC;
          data_ready : out   STD_LOGIC);
    END COMPONENT;

    type io_reg is array (31 DOWNTO 0) of std_logic_vector(15 DOWNTO 0); --32 ports utils
    --type io_reg is array (255 DOWNTO 0) of std_logic_vector(15 DOWNTO 0); --256 ports reals
    
    signal io_port: io_reg;
    signal pulsadors: STD_LOGIC_VECTOR(15 DOWNTO 0);
    signal interruptors: STD_LOGIC_VECTOR(15 DOWNTO 0);
    signal visor: STD_LOGIC_VECTOR(3 DOWNTO 0);
	signal num: STD_LOGIC_VECTOR(15 DOWNTO 0);
    signal tecla: STD_LOGIC_VECTOR(7 DOWNTO 0);
    signal netejar: STD_LOGIC;
    signal nova_tecla: STD_LOGIC;

    signal contador_ciclos : STD_LOGIC_VECTOR(15 downto 0):=x"0000";
    signal contador_milisegundos : STD_LOGIC_VECTOR(15 downto 0):=x"0000";

BEGIN
    led_verdes <= io_port(5)(7 DOWNTO 0); --PORT 5 SURTEN LED VERDS

    led_rojos <= io_port(6)(7 DOWNTO 0); --PORT 6 SURTEN LED VERMELLS

    pulsadors <= x"000"&KEY; --PORT 7 ENTRA PULSADORS

    interruptors <= x"00"&SW(7 DOWNTO 0); -- PORT 8 ENTRA INTERRUPTORS

    visor <= io_port(9)(3 DOWNTO 0); --PORT 9 ENTRA/SURT MARCA ESTAT DE CADA VISOR 7 SEGMENTS(1 ENCES/0 APAGAT)

    num <= io_port(10); --PORT 10 ENTRA/SURT EL VALOR DEL 16 BITS PEL VISOR

    kb: keyboard_controller PORT MAP(CLOCK_50, boot, ps2_clk, ps2_data, tecla, netejar, nova_tecla);

    driver: driver4Display PORT MAP(num, HEX0, HEX1, HEX2, HEX3, visor); --DRIVER 7 SEGMENTS

    rd_io <= io_port(conv_integer(addr_io(4 DOWNTO 0))); --per 32 ports
    --rd_io <= io_port(conv_integer(addr_io(7 DOWNTO 0))); --per 256 ports

    --snake

    process (CLOCK_50)
    BEGIN
        if (rising_edge(CLOCK_50)) then
            --snake
            if contador_ciclos=0 then
                contador_ciclos<=x"C350"; -- tiempo de ciclo=20ns(50Mhz) 1ms=50000ciclos
            if contador_milisegundos>0 then
                contador_milisegundos <= contador_milisegundos-1;
            end if;
            else
                contador_ciclos <= contador_ciclos-1;
            end if;
            --fins aqui snake
				netejar <= '0';
            if wr_out = '1' then
                if addr_io = 16 then
                    netejar <= '1';
                elsif addr_io = 21 then
                    contador_milisegundos <= wr_io;
                else    
                    io_port(conv_integer(addr_io)) <= wr_io;
                end if;    
            else
                io_port(7) <= pulsadors;
                io_port(8) <= interruptors; 
                io_port(15) <= "00000000"&tecla;
                io_port(16) <= "000000000000000"&nova_tecla;
                io_port(20) <= contador_ciclos;
                io_port(21) <= contador_milisegundos;
            end if;
        end if;
    end process;

END Structure;