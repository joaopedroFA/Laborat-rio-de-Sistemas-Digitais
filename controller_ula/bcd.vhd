-- ELE0518 - LABORATORIO DE SISTEMAS DIGITAIS - T03 (2025.2)
-- Component Decodificador para display de 7 segmentos
-- Autores: Emanoel Ferreira dos Santos e João Pedro Freire de Albuquerque
-- Data 18/11/2025

-- Bibliotecas
library ieee;
use ieee.std_logic_1164.all;

-- Entidade
entity bcd is
    port(
        -- Entrada do decoder
        numero_binario  :   in  std_logic_vector(3 downto 0);

        -- Saída do decoder
        numero_7seg     :   out std_logic_vector(6 downto 0)
    );
end bcd;

-- Arquitetura
architecture dataflow of bcd is
    begin
        numero_7seg <=  not "1111110"   when    numero_binario  =   "0000"  else
                        not "0110000"   when    numero_binario  =   "0001"  else
                        not "1101101"   when    numero_binario  =   "0010"  else
                        not "1111001"   when    numero_binario  =   "0011"  else
                        not "0110011"   when    numero_binario  =   "0100"  else
                        not "1011011"   when    numero_binario  =   "0101"  else
                        not "0011111"   when    numero_binario  =   "0110"  else
                        not "1110000"   when    numero_binario  =   "0111"  else
                        not "1111111"   when    numero_binario  =   "1000"  else
                        not "1110011"   when    numero_binario  =   "1001"  else
                        not "0000000";
    end dataflow;
