LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_unsigned.all;

ENTITY pulsadores IS
    PORT(clk : IN STD_LOGIC;
         boot : IN STD_LOGIC;
         inta : IN STD_LOGIC;
         keys : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
         intr : OUT STD_LOGIC;
         read_key : OUT STD_LOGIC_VECTOR(3 DOWNTO 0));
END pulsadores;

ARCHITECTURE Structure OF pulsadores IS

    signal mem_estado: STD_LOGIC_VECTOR(3 DOWNTO 0);

BEGIN

    read_key <= keys;

    process(clk)
    begin
        if rising_edge(clk) then
            if boot = '1' then
                mem_estado <= keys;
            else
                if (mem_estado /= keys) then --ha canviat algun key
                    intr <= '1';
                    mem_estado <= keys;
                end if;
                if inta = '1' then
                    intr <= '0';
                end if;
            end if;
        end if;
    end process;

END Structure;
                    
                


