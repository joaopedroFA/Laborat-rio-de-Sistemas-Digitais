-- ELE0518 - LABORATORIO DE SISTEMAS DIGITAIS - T03 (2025.2)
-- Atividade bonus: Circuito somador que mostra o resultado completo (Unidade e Dezena) Em dois displays de 7 segmentos.
-- Autores: Emanoel Ferreira dos Santos e joao Pedro Freire de Albuquerque
-- Data 18/11/2025

-- Biblioteca
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Entidade
entity somador_e_bcd is

    port(
        -- Entradas
        num_1, num_2    :   in  std_logic_vector(3 downto 0);

        -- SaÃƒÂ­da
        hex_dezena, hex_unidade    :   out std_logic_vector(6 downto 0)
    );
end somador_e_bcd;

-- Arquitetura
architecture top_level of somador_e_bcd is
    -- Sinais
    signal  sum             :   std_logic_vector(3 downto 0);
    signal  cout            :   std_logic;
    -- Merge de sum e cout
    signal  cout_sum        :   unsigned(4 downto 0);
    signal  dezena, unidade :   std_logic_vector(3 downto 0);

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

        -- Saida do decoder
        numero_7seg     :   out std_logic_vector(6 downto 0)
    );
    end component bcd;
	 
	 begin
    -- Instanciando somador
    somador: carry_ripple_4bit_adder port map(num_1, num_2, '0', sum, cout);
    
    -- Concatenando o bit cout com o vetor da soma
    cout_sum <= unsigned(cout & sum);

    dezena <= std_logic_vector(to_unsigned(to_integer(cout_sum) / 10, 4));
	 unidade <= std_logic_vector(to_unsigned(to_integer(cout_sum) mod 10, 4));

    -- Instanciando BCDs
    bcd_dezena: bcd port map(dezena, hex_dezena);
    bcd_unidade: bcd port map(unidade, hex_unidade);


end top_level;
