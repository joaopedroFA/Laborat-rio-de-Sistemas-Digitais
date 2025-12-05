-- ELE0518 - LABORATORIO DE SISTEMAS DIGITAIS - T03 (2025.2)
-- Arquivo: divisor_clock.vhd
-- Autores: Emanoel Ferreira dos Santos e João Pedro Freire de Albuquerque
-- Data: 18/11/2025
-- Descrição: Modulo prescaler para reduzir a frequência do clock da FPGA.
--            Útil para visualizar transições de estado a olho nu.

library ieee;
use ieee.std_logic_1164.all;

entity divisor_clock is
    -- Generic permite configurar o módulo na instanciação sem mexer no código
    -- Frequência de Saída = Freq Entrada / (2 * FATOR_DIVISAO)
    -- Para 50MHz de entrada e alvo de 1Hz: FATOR = 25.000.000
    generic (
        FATOR_DIVISAO : integer := 25000000 
    );
    port (
        clk_fpga  : in std_logic;  -- Clock rápido (Input)
        rst       : in std_logic;  -- Reset
        clk_lento : out std_logic  -- Clock reduzido (Output)
    );
end divisor_clock;

architecture Behavioral of divisor_clock is
    -- Contador para medir o tempo
    signal contador : integer range 0 to FATOR_DIVISAO := 0;
    -- Registrador para o estado atual do clock de saída (Toggle)
    signal estado_clk : std_logic := '0';
begin
    
    process(clk_fpga, rst)
    begin
        if rst = '1' then
            contador <= 0;
            estado_clk <= '0';
        elsif rising_edge(clk_fpga) then
            -- Se o contador atingiu o limite definido
            if contador = FATOR_DIVISAO then
                contador <= 0;                -- Reinicia contagem
                estado_clk <= not estado_clk; -- Inverte o sinal de saída (0->1 ou 1->0)
            else
                contador <= contador + 1;     -- Incrementa
            end if;
        end if;
    end process;

    -- Atribui o sinal interno à porta de saída
    clk_lento <= estado_clk;

end Behavioral;
