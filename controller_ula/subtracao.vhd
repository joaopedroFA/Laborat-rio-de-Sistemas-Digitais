library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity subtracao is
    port(
        num_a, num_b : in  std_logic_vector(3 downto 0);
        num_negativo : out std_logic;
        resultado    : out std_logic_vector(7 downto 0)
    );
end subtracao;

architecture datasheet of subtracao is
begin

    -- Resultado da subtração (valor absoluto)
    resultado <= std_logic_vector(
                    resize(unsigned(num_a), 8) - 
                    resize(unsigned(num_b), 8)
                 )
        when unsigned(num_a) >= unsigned(num_b)
        else std_logic_vector(
                    resize(unsigned(num_b), 8) -
                    resize(unsigned(num_a), 8)
                 );

    -- Flag indicando se o resultado é negativo
    num_negativo <= '0' when unsigned(num_a) >= unsigned(num_b)
                    else '1';

end datasheet;
