library ieee;
use ieee.std_logic_1164.all;


entity multiplicacao is
    port(
        num_a, num_b    :   in  std_logic_vector(3 downto 0);
        resultado       :   out std_logic_vector(7 downto 0)
    );
end multiplicacao;

architecture datasheet of multiplicacao is
    begin
        resultado <= num_a * num_b;
    end datasheet;