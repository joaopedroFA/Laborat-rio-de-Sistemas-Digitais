-- ELE0518 - LABORATORIO DE SISTEMAS DIGITAIS - T03 (2025.2)
-- Component half adder
-- Autores: Emanuel e João Pedro Freire de Albuquerque
-- Data 17/11/2025

--Bibliotecas
library ieee;
use ieee.std_logic_1164.all;

--Entidade
entity half_adder is
    port(
        -- Entradas
        bit_A, bit_B    :   in std_logic;
        -- Saídas
        sum             :   out std_logic;
        carryOut        :   out std_logic
    );
end half_adder;

-- Arquitetura
architecture dataflow of half_adder is
    begin
        sum         <=      bit_A xor bit_B;
        carryOut    <=      bit_A and bit_B;
    end dataflow;