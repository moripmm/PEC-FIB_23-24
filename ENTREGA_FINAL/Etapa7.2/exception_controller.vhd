LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_unsigned.all;

ENTITY exception_controller IS
    PORT (intr : IN STD_LOGIC;
          ill_inst : IN STD_LOGIC;
          mem_allign : IN STD_LOGIC;
          div_zero : IN STD_LOGIC;
          exception : OUT STD_LOGIC;
          code_excep : OUT STD_LOGIC_VECTOR(3 DOWNTO 0));
END exception_controller;

ARCHITECTURE Structure OF exception_controller IS
BEGIN
    exception <= '1' WHEN (ill_inst = '1' or mem_allign = '1' or div_zero = '1') else
                 '0';

    code_excep <= x"0" WHEN ill_inst = '1' else --intsruccio il·legal
                  x"1" WHEN mem_allign = '1' else --alineacio impar
                  x"4" WHEN div_zero = '1' else --divisio entre zero
                  x"2";

END Structure;