library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity subtracao is
    port(
        num_a, num_b : in  std_logic_vector(3 downto 0);
        resultado    : out std_logic_vector(7 downto 0)
    );
end subtracao;

architecture datasheet of subtracao is
begin
    resultado <= std_logic_vector(
                    resize(unsigned(num_a), 8) -
                    resize(unsigned(num_b), 8)
                 );
end datasheet;
