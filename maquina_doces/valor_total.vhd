-- ELE0518 - LABORATORIO DE SISTEMAS DIGITAIS - T03 (2025.2)
-- Autor    :   João Pedro Freire de Albuquerque
-- Data     :   04/12/2025
-- Projeto  :   Maquina de doces (FSM)

-- Bloco: ValorTotal

library ieee;
use ieee.std_logic_1164.all

entity valor_total is
    
    port(
        -- Sinal de clock
        clk             :   in  std_logic;
        -- Entradas
        valorMoeda      :   in  std_logic_vector(1 downto 0);
        entradaMoeda    :   in  std_logic
        -- Saidas
        valorAcumulado  :   out std_logic_vector(7 downto 0);
        permissao       :   out std_logic
    );
end valor_total;

architecture datapath of valor_total is
    
    signal acumulado : unsigned(7 downto 0) := (others => '0');
    signal moeda     : unsigned(7 downto 0);

begin


    moeda <= to_unsigned(0, 8)  when valorMoeda = "00" else
             to_unsigned(5, 8)  when valorMoeda = "01" else
             to_unsigned(10, 8) when valorMoeda = "10" else
             to_unsigned(25, 8);


    process(clk)
    begin
        if rising_edge(clk) then
            
            
            if entradaMoeda = '1' then
                acumulado <= acumulado + moeda;
            end if;

        end if;
    end process;


    valorAcumulado <= std_logic_vector(acumulado);
    permissao <= '1' when acumulado >= 80 else '0';

end datapath;
    
