LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_unsigned.all;

ENTITY interruptores IS
    PORT(clk : IN STD_LOGIC;
         boot : IN STD_LOGIC;
         inta : IN STD_LOGIC;
         switches : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
         intr : OUT STD_LOGIC;
         rd_switch : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
END interruptores;

ARCHITECTURE Structure OF interruptores IS

    signal mem_estado: STD_LOGIC_VECTOR(7 DOWNTO 0);

BEGIN
    rd_switch <= switches;

    process(clk)
    begin
        if rising_edge(clk) then
            if boot = '1' then
                mem_estado <= switches;
            else
                if (mem_estado /= switches) then --ha canviat algun switch 
                    intr <= '1';
                    mem_estado <= switches;
                end if;
                if inta = '1' then
                    intr <= '0';
                end if;
            end if;
        end if;
    end process;

END Structure;