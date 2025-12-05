-- ELE0518 - LABORATORIO DE SISTEMAS DIGITAIS - T03 (2025.2)
-- Arquivo: binario_para_bcd_8bits.vhd
-- Autores: Emanoel Ferreira dos Santos e João Pedro Freire de Albuquerque
-- Data: 18/11/2025
-- Descrição: Converte um vetor binário de 8 bits (0 a 255) em três dígitos
--            separados de 4 bits (Centena, Dezena, Unidade) para exibição.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; -- Biblioteca essencial para operações aritméticas

entity binario_para_bcd_8bits is
    port (
        entrada_8b  : in  std_logic_vector(7 downto 0); -- Número Binário (Ex: "10001001" = 137)
        
        -- Saídas separadas
        centena_bcd : out std_logic_vector(3 downto 0); -- Digito Centena (Ex: 1)
        dezena_bcd  : out std_logic_vector(3 downto 0); -- Digito Dezena  (Ex: 3)
        unidade_bcd : out std_logic_vector(3 downto 0)  -- Digito Unidade (Ex: 7)
    );
end binario_para_bcd_8bits;

architecture Behavioral of binario_para_bcd_8bits is
begin
    -- Processo combinacional: sensível a qualquer mudança na entrada
    process(entrada_8b)
        variable valor_int : integer range 0 to 255;
    begin
        -- Converte o vetor de bits para inteiro para facilitar a matemática
        valor_int := to_integer(unsigned(entrada_8b));
        
        -- Extração da Centena: Divisão inteira por 100
        -- Ex: 137 / 100 = 1
        centena_bcd <= std_logic_vector(to_unsigned(valor_int / 100, 4));
        
        -- Extração da Dezena: Resto de 100, depois divide por 10
        -- Ex: 137 rem 100 = 37 -> 37 / 10 = 3
        dezena_bcd  <= std_logic_vector(to_unsigned((valor_int rem 100) / 10, 4));
        
        -- Extração da Unidade: Resto da divisão por 10
        -- Ex: 137 rem 10 = 7
        unidade_bcd <= std_logic_vector(to_unsigned(valor_int rem 10, 4));
    end process;
end Behavioral;
