LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_unsigned.all;

ENTITY interrupt_controller IS
    PORT(clk : IN STD_LOGIC;
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
END interrupt_controller;

ARCHITECTURE Structure OF interrupt_controller IS

    signal interrupt_type: STD_LOGIC_VECTOR(7 DOWNTO 0);
    signal cont: STD_LOGIC_VECTOR(2 downto 0) := "100";

BEGIN

    timer_inta <= '1' when (inta = '1' and interrupt_type = x"00") else
                  '0';

    key_inta <= '1' when (inta = '1' and interrupt_type = x"01") else
                '0';
    
    switch_inta <= '1' when (inta = '1' and interrupt_type = x"02") else
                   '0';
    
    ps2_inta <= '1' when (inta = '1' and interrupt_type = x"03") else
                '0';

    intr <= '1' when ((key_intr = '1' or switch_intr = '1' or timer_intr = '1' or ps2_intr = '1') and boot = '0') else
            '0';

    process(clk)
    begin
        if rising_edge(clk) then
            if boot = '0' then
                if timer_intr = '1' then
                    interrupt_type <= x"00";
                elsif key_intr = '1' then
                    interrupt_type <= x"01";
                elsif switch_intr = '1' then
                    interrupt_type <= x"02";
                elsif ps2_intr = '1' then
                    interrupt_type <= x"03";
                end if;
                cont <= cont + 1;
                if cont = "100" then
					if inta = '1' then
						iid <= interrupt_type;
					end if;
				end if;
            else
                cont <= "100";
            end if;
        end if;
    end process;

END Structure;
