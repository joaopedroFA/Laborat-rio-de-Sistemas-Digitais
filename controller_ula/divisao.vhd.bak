library ieee;
use ieee.std_logic_1164.all;


entity divisao is
    port(
        num_a, num_b    :   in  std_logic_vector(3 downto 0);
        resultado       :   out std_logic_vector(7 downto 0)
    );
end divisao;

architecture datasheet of divisao is
    begin
        resultado <= num_a / num_b when num_b /= "0000" else "0000";
    end datasheet;