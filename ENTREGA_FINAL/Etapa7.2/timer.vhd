LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_unsigned.all;

ENTITY timer IS
    PORT(CLOCK_50: IN STD_LOGIC;
         boot : IN STD_LOGIC;
         inta : IN STD_LOGIC;
         intr : OUT STD_LOGIC);
END timer;

ARCHITECTURE Structure OF timer IS

    constant ms_50: STD_LOGIC_VECTOR(31 downto 0) := STD_LOGIC_VECTOR(to_unsigned(50000*50,32));
    signal cont: STD_LOGIC_VECTOR(31 downto 0);

BEGIN

    process(CLOCK_50)
    begin
        if rising_edge(CLOCK_50) then
            if boot = '1' then
                intr <= '0';
                cont <= ms_50;
            else
                if cont = 0 then 
                    intr <= '1';
                    cont <= ms_50;
                else
                    cont <= cont - 1;
                end if;
                if inta = '1' then
                    intr <= '0';
                end if;
            end if;
        end if;
    end process;

END Structure;
                    
                


