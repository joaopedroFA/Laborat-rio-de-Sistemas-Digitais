library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula is
    port(
        a, b   : in  std_logic_vector(3 downto 0);
        sel_op : in  std_logic_vector(2 downto 0);
        result : out std_logic_vector(7 downto 0)
    );
end ula;

architecture structural of ula is
    signal res_soma, res_sub, res_mult, res_div : std_logic_vector(7 downto 0);
begin
    -- Instancia as operacoes
    U_SOMA : entity work.soma 
        port map (num_a => a, num_b => b, resultado => res_soma);

    U_SUB : entity work.subtracao 
        port map (num_a => a, num_b => b, resultado => res_sub);

    U_MULT : entity work.multiplicacao 
        port map (num_a => a, num_b => b, resultado => res_mult);

    U_DIV : entity work.divisao 
        port map (num_a => a, num_b => b, resultado => res_div);

    -- Multiplexador de saida
    process(sel_op, res_soma, res_sub, res_mult, res_div)
    begin
        case sel_op is
            when "001" => result <= res_soma;
            when "010" => result <= res_sub;
            when "011" => result <= res_div;
            when "100" => result <= res_mult;
            when others => result <= (others => '0');
        end case;
    end process;

end structural;