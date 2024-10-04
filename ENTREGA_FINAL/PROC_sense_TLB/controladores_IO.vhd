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
          ps2_data : INOUT STD_LOGIC;
          inta: IN STD_LOGIC;
          intr: OUT STD_LOGIC);
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

    COMPONENT interrupt_controller IS
    PORT( clk : IN STD_LOGIC;
          boot : IN STD_LOGIC;
          inta: IN STD_LOGIC;
          key_intr: IN STD_LOGIC;
          ps2_intr: IN STD_LOGIC;
          switch_intr: IN STD_LOGIC;
          timer_intr: IN STD_LOGIC;
          intr: OUT STD_LOGIC;
          key_inta: OUT STD_LOGIC;
          ps2_inta: OUT STD_LOGIC;
          switch_inta: OUT STD_LOGIC;
          timer_inta: OUT STD_LOGIC;
          iid: OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
    END COMPONENT;

    COMPONENT timer IS
    PORT (CLOCK_50: IN STD_LOGIC;
          boot : IN STD_LOGIC;
          inta : IN STD_LOGIC;
          intr : OUT STD_LOGIC);
    END COMPONENT;

    COMPONENT pulsadores IS
    PORT (clk : IN STD_LOGIC;
          boot : IN STD_LOGIC;
          inta : IN STD_LOGIC;
          keys : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
          intr : OUT STD_LOGIC;
          read_key : OUT STD_LOGIC_VECTOR(3 DOWNTO 0));
    END COMPONENT;

    COMPONENT interruptores IS
    PORT (clk : IN STD_LOGIC;
          boot : IN STD_LOGIC;
          inta : IN STD_LOGIC;
          switches : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
          intr : OUT STD_LOGIC;
          rd_switch : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
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

    signal ps2_inta_sig: STD_LOGIC;
	signal timer_inta_sig: STD_LOGIC;
	signal switch_inta_sig: STD_LOGIC;
	signal key_inta_sig: STD_LOGIC;
	signal ps2_intr_sig: STD_LOGIC;
	signal timer_intr_sig: STD_LOGIC;
	signal switch_intr_sig: STD_LOGIC;
	signal key_intr_sig: STD_LOGIC;
	signal read_key_sig: std_LOGIC_VECTOR(3 DOWNTO 0);
	signal rd_switch_sig: std_LOGIC_VECTOR(7 DOWNTO 0);
	signal iid: std_LOGIC_VECTOR(7 DOWNTO 0);
	signal clear_char_sig : std_logic;

    signal contador_ciclos : STD_LOGIC_VECTOR(15 downto 0):=x"0000";
    signal contador_milisegundos : STD_LOGIC_VECTOR(15 downto 0):=x"0000";

BEGIN
    led_verdes <= io_port(5)(7 DOWNTO 0); --PORT 5 SURTEN LED VERDS

    led_rojos <= io_port(6)(7 DOWNTO 0); --PORT 6 SURTEN LED VERMELLS

    pulsadors <= x"000"&KEY; --PORT 7 ENTRA PULSADORS

    interruptors <= x"00"&SW(7 DOWNTO 0); -- PORT 8 ENTRA INTERRUPTORS

    visor <= io_port(9)(3 DOWNTO 0); --PORT 9 ENTRA/SURT MARCA ESTAT DE CADA VISOR 7 SEGMENTS(1 ENCES/0 APAGAT)

    num <= io_port(10); --PORT 10 ENTRA/SURT EL VALOR DEL 16 BITS PEL VISOR

    driver: driver4Display PORT MAP (caract => num, 
                                     HEX0 => HEX0, 
                                     HEX1 => HEX1, 
                                     HEX2 => HEX2, 
                                     HEX3 => HEX3, 
                                     visor => visor); 

    intctrl0: interrupt_controller PORT MAP (clk => CLOCK_50,
                                             boot => boot,
                                             inta => inta,
                                             key_intr => key_intr_sig,
                                             ps2_intr => nova_tecla,
                                             switch_intr => switch_intr_sig,
                                             timer_intr => timer_intr_sig,
                                             intr => intr,
                                             key_inta => key_inta_sig,
                                             ps2_inta => ps2_inta_sig,
                                             switch_inta => switch_inta_sig,
                                             timer_inta => timer_inta_sig,
                                             iid => iid);

    timer0: timer PORT MAP (CLOCK_50 => CLOCK_50,
                            boot => boot,
                            inta => timer_inta_sig,
                            intr => timer_intr_sig);

    keys0: pulsadores PORT MAP (clk => CLOCK_50,
                                boot => boot,
                                inta => key_inta_sig,
                                keys => KEY,
                                intr => key_intr_sig,
                                read_key => read_key_sig);

    switch0: interruptores PORT MAP (clk => CLOCK_50,
                                     boot => boot,
                                     inta => switch_inta_sig,
                                     switches => SW(7 DOWNTO 0),
                                     intr => switch_intr_sig,
                                     rd_switch => rd_switch_sig);

    kbrd0: keyboard_controller PORT MAP (clk => CLOCK_50,
                                         reset => boot, 
                                         ps2_clk => ps2_clk, 
                                         ps2_data => ps2_data,
                                         read_char => tecla, 
                                         clear_char => clear_char_sig, 
                                         data_ready => nova_tecla);

    clear_char_sig <= ps2_inta_sig or netejar;

    rd_io <= x"00"&iid when inta = '1' else
             io_port(conv_integer(addr_io(4 DOWNTO 0))); --per 32 ports

    --rd_io <= x"00"&iid when inta = '1' else
    --           io_port(conv_integer(addr_io(7 DOWNTO 0))); --per 256 ports

    process (CLOCK_50)
    BEGIN
        if (rising_edge(CLOCK_50)) then
            if contador_ciclos=0 then
                contador_ciclos<=x"C350"; -- tiempo de ciclo=20ns(50Mhz) 1ms=50000ciclos
            if contador_milisegundos>0 then
                contador_milisegundos <= contador_milisegundos-1;
            end if;
            else
                contador_ciclos <= contador_ciclos-1;
            end if;

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
                io_port(15) <= x"00"&tecla;
                io_port(16) <= "000000000000000"&nova_tecla;
                io_port(20) <= contador_ciclos;
                io_port(21) <= contador_milisegundos;
            end if;
        end if;
    end process;

END Structure;