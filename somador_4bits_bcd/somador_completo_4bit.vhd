-- ELE0518 - LABORATORIO DE SISTEMAS DIGITAIS - T03 (2025.2)
-- Component carry ripple 4 bits
-- Autores: Emanuel e João Pedro Freire de Albuquerque
-- Data 17/11/2025

-- 
library ieee;
use ieee.std_logic_1164.all;

entity carry_ripple_4bit_adder is
    port(
        A, B        :   in std_logic_vector(3 downto 0);
        carryIn     :   in std_logic;

        sum         :   out std_logic_vector(3 downto 0);
        carryOut    :   out std_logic
    );
end carry_ripple_4bit_adder;

architecture main of carry_ripple_4bit_adder is

    -- Componentes
    component full_adder is
    port(
        -- Entradas
        bit_1, bit_2    :   in std_logic;
        carryIn         :   in std_logic;
        --Saídas
        sum             :   out std_logic;
        carryOut        :   out std_logic
    );
    end component full_adder;
    -- Sinais
    signal carryOut_1, carryOut_2, carryOut_3   :   std_logic;

    begin
        -- Instanciação posicional
        full_adder_1: full_adder port map(A(0), B(0), carryIn, sum(0), carryOut_1);
        full_adder_2: full_adder port map(A(1), B(1), carryOut_1, sum(1), carryOut_2);
        full_adder_3: full_adder port map(A(2), B(2), carryOut_2, sum(2), carryOut_3);
        full_adder_4: full_adder port map(A(3), B(3), carryOut_3, sum(3), carryOut);
    end main;
