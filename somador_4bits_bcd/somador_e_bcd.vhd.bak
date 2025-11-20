-- ELE0518 - LABORATORIO DE SISTEMAS DIGITAIS - T03 (2025.2)
-- Atividade Bônus: Circuito somador que mostra o resultado completo (Unidade e Dezena) Em dois displays de 7 segmentos.
-- Autores: Emanoel Ferreira dos Santos e João Pedro Freire de Albuquerque
-- Data 18/11/2025

-- Biblioteca
library ieee;
use ieee.std_logic_1164.all;

-- Entidade
entity somador_e_bcd is

    port(
        -- Entradas
        num_1, num_2    :   in  std_logic_vector(3 downto 0);

        -- Saída
        hex_dezena, hex_unidade    :   out std_logic_vector(6 to 0);
    );
end somador_e_bcd;

-- Arquitetura
architecture top_level of somador_e_bcd is
    -- Sinais
    signal  sum             :   std_logic_vector(3 downto 0);
    signal  cout            :   std_logic;
    -- Merge de sum e cout
    signal  cout_sum        :   unsigned(4 downto 0);
    signal  dezena, unidade :   std_logic(3 downto 0);

    -- Componentes
    
    -- Somador completo de 4 bits
    component carry_ripple_4bit_adder is
    port(
        A, B        :   in std_logic_vector(3 downto 0);
        carryIn     :   in std_logic;

        sum         :   out std_logic_vector(3 downto 0);
        carryOut    :   out std_logic
    );
    end component carry_ripple_4bit_adder;
    
    -- Decodificador para display de 7 segmentos
    component bcd is
    port(
        -- Entrada do decoder
        numero_binario  :   in  std_logic_vector(3 downto 0);

        -- Saída do decoder
        numero_7seg     :   out std_logic_vector(6 downto 0)
    );
    end component bcd;

    -- Instanciando somador
    somador: carry_ripple_4bit_adder port map(num_1, num_2, '0', sum, cout);
    
    -- Concatenando o bit cout com o vetor da soma
    cout_sum <= cout & sum;

    -- Calculando a dezena
    dezena <= (cout_sum / 10)(3 downto 0);
    -- Calculando a unidade
    unidade <= (cout_sum mod 10)(3 downto 0);

    -- Instanciando BCDs
    bcd_dezena: bcd port map(dezena, hex_dezena);
    bcd_unidade: bcd port map(unidade, hex_unidade);


end top_level;
