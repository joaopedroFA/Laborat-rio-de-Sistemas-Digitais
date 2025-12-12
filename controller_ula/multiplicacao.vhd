library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity multiplicacao is
    port(
        num_a, num_b : in  std_logic_vector(3 downto 0);
        resultado    : out std_logic_vector(7 downto 0)
    );
end multiplicacao;

architecture datasheet of multiplicacao is
begin
    resultado <= std_logic_vector(
                    resize(
                        unsigned(num_a) * unsigned(num_b),
                        8
                    )
                 );
end datasheet;
