-- ELE0518 - LABORATORIO DE SISTEMAS DIGITAIS - T03 (2025.2)
-- Component full adder
-- Autores: Emanuel e João Pedro Freire de Albuquerque
-- Data 17/11/2025

-- Bibliotecas
library ieee;
use ieee.std_logic_1164.all;

-- Entidade
entity full_adder is
    port(
        -- Entradas
        bit_1, bit_2    :   in std_logic;
        carryIn         :   in std_logic;
        --Saídas
        sum             :   out std_logic;
        carryOut        :   out std_logic
    );
end full_adder;

-- Arquitetura
architecture registerTransferlevel of full_adder is

    -- Sinais
    signal sum_1                        :       std_logic;
    signal carryOut_1, carryOut_2       :       std_logic;

    -- Componentes
    component half_adder is
    port(
        -- Entradas
        bit_A, bit_B    :   in std_logic;
        -- Saídas
        sum                 :   out std_logic;
        carryOut            :   out std_logic
    );
    end component half_adder;

    begin

        -- Expressão Carry
        carryOut        <=  carryOut_2 or carryOut_1;

        -- Instanciando half_adders
        half_adder_1:   half_adder
            
            port map(
                bit_A   =>  bit_A,
                bit_B   =>  bit_B,
                sum     =>  sum_1,
                carryOut=>  carryOut_1
            );

        half_adder_2:   half_adder
            
            port map(
                bit_A   =>  carryIn,
                bit_B   =>  sum_1,
                sum     =>  sum,
                carryOut=>  carryOut_2
            );
    end registerTransferlevel;