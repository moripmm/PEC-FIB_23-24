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
          code_excep : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
          mem_prot : IN STD_LOGIC;
          inst_prot : IN STD_LOGIC;
          call : IN STD_LOGIC);
END exception_controller;

ARCHITECTURE Structure OF exception_controller IS
BEGIN
    exception <= '1' WHEN (ill_inst = '1' or mem_allign = '1' or div_zero = '1' or mem_prot = '1' or inst_prot = '1' or call = '1') else
                 '0';

    code_excep <= x"0" WHEN ill_inst = '1' else --intsruccio il·legal
                  x"1" WHEN mem_allign = '1' else --alineacio impar
                  x"4" WHEN div_zero = '1' else --divisio entre zero
                  x"B" WHEN mem_prot = '1' else --acceso a memoria protegida
                  x"D" WHEN inst_prot = '1' else --ejecutar instr privilegiada en modo usuario
                  x"E" WHEN call = '1' else --llamada al sistema
                  x"2";

END Structure;