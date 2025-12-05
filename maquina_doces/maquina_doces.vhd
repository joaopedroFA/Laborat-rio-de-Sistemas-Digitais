-- ELE0518 - LABORATORIO DE SISTEMAS DIGITAIS - T03 (2025.2)
-- Arquivo: maquina_doces.vhd
-- Autores: Emanoel Ferreira dos Santos e João Pedro Freire de Albuquerque
-- Data: 18/11/2025
-- Descrição: Implementação da Máquina de Estados Finita (FSM) para controle
--            de uma Vending Machine. Possui 5 estados e lógica de soma/subtração.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; -- Necessário para realizar operações de soma (+) e subtração (-)

entity maquina_doces is
    port (
        -- Entradas
        clk     : in std_logic; -- Clock do sistema (espera-se clock lento)
        rst     : in std_logic; -- Reset assíncrono
        C1, C0  : in std_logic; -- Bits que definem o valor da moeda
        Cin     : in std_logic; -- Pulso que indica que uma moeda foi inserida
        S       : in std_logic; -- Botão de solicitação de compra
        
        -- Saídas
        D       : out std_logic_vector(7 downto 0); -- Valor acumulado (0 a 255)
        R       : out std_logic                     -- Sinal de liberação do produto (LED)
    );
end maquina_doces;

architecture Behavioral of maquina_doces is

    -- Definição enumerada dos estados para facilitar leitura e debug
    type t_estado is (
        ST_INICIAL,      -- Estado de inicialização segura
        ST_ESPERA,       -- Estado ocioso (Idle), aguardando usuário
        ST_SOMAR,        -- Estado de processamento matemático da entrada
        ST_SOLTAR_CIN,   -- Estado de espera para estabilidade do sensor (debounce lógico)
        ST_LIBERAR       -- Estado de entrega do produto e débito
    );

    -- Sinais internos para controle de estado e dados
    signal estado_atual : t_estado := ST_INICIAL;
    signal saldo_reg    : integer range 0 to 255 := 0; -- Registrador do dinheiro

begin

    -- Processo Síncrono: Controla a troca de estados e atualização de registradores
    process(clk, rst)
    begin
        -- Reset Assíncrono (Prioridade máxima)
        if rst = '1' then
            estado_atual <= ST_INICIAL;
            saldo_reg    <= 0;
            R            <= '0';
        
        -- Detecção de borda de subida do clock
        elsif rising_edge(clk) then
            
            case estado_atual is
                
                -- ============================================================
                -- ESTADO 1: INICIALIZAÇÃO
                -- Garante que a máquina comece em um estado conhecido e zerada.
                -- ============================================================
                when ST_INICIAL =>
                    R <= '0';            -- Garante LED apagado
                    saldo_reg <= 0;      -- Zera o contador de dinheiro
                    estado_atual <= ST_ESPERA; -- Transição imediata para espera

                -- ============================================================
                -- ESTADO 2: ESPERA
                -- O "Cérebro" de decisão. Aguarda botão S ou sensor Cin.
                -- ============================================================
                when ST_ESPERA =>
                    R <= '0'; -- Mantém saída desativada
                    
                    -- Verifica se usuário pediu compra (Prioridade 1)
                    if S = '1' then
                        -- Só avança para liberar se tiver saldo suficiente (>= 80)
                        if saldo_reg >= 80 then
                            estado_atual <= ST_LIBERAR;
                        else
                            -- Se não tem saldo, ignora e fica na espera
                            estado_atual <= ST_ESPERA;
                        end if;
                        
                    -- Verifica se inseriu moeda (Prioridade 2)
                    elsif Cin = '1' then
                        estado_atual <= ST_SOMAR;
                        
                    -- Nenhuma ação
                    else
                        estado_atual <= ST_ESPERA;
                    end if;

                -- ============================================================
                -- ESTADO 3: SOMAR
                -- Decodifica C1/C0 e adiciona valor ao registrador.
                -- ============================================================
                when ST_SOMAR =>
                    R <= '0';
                    
                    -- Lógica de Soma com proteção de Saturação (Anti-Overflow)
                    -- Evita que 250 + 10 vire algo pequeno se estourar 8 bits.
                    
                    -- Caso: 01 (5 centavos)
                    if (C1 = '0' and C0 = '1') then
                        if (saldo_reg + 5 <= 255) then 
                            saldo_reg <= saldo_reg + 5; 
                        end if;
                        
                    -- Caso: 10 (10 centavos)
                    elsif (C1 = '1' and C0 = '0') then
                        if (saldo_reg + 10 <= 255) then 
                            saldo_reg <= saldo_reg + 10; 
                        end if;
                        
                    -- Caso: 11 (25 centavos)
                    elsif (C1 = '1' and C0 = '1') then
                        if (saldo_reg + 25 <= 255) then 
                            saldo_reg <= saldo_reg + 25; 
                        end if;
                    end if;
                    
                    -- Transição incondicional: Aguardar sensor desligar
                    estado_atual <= ST_SOLTAR_CIN;

                -- ============================================================
                -- ESTADO 4: SOLTAR CIN
                -- Garante que uma moeda inserida conte apenas uma vez.
                -- ============================================================
                when ST_SOLTAR_CIN =>
                    R <= '0';
                    -- Só sai deste estado quando o sinal de entrada for para '0'
                    if Cin = '0' then
                        estado_atual <= ST_ESPERA;
                    else
                        estado_atual <= ST_SOLTAR_CIN; -- Loop de espera
                    end if;

                -- ============================================================
                -- ESTADO 5: LIBERAR DOCE
                -- Ativa a saída e desconta o valor.
                -- ============================================================
                when ST_LIBERAR =>
                    R <= '1';                    -- Acende o LED Vermelho
                    saldo_reg <= saldo_reg - 80; -- Subtrai o custo do doce
                    
                    -- Retorna para espera. Como R ficou '1' apenas neste ciclo
                    -- e a saída é atualizada pelo clock, teremos um pulso exato.
                    estado_atual <= ST_ESPERA;
                    
            end case;
        end if;
    end process;

    -- Converte o inteiro interno para vetor lógico de saída
    D <= std_logic_vector(to_unsigned(saldo_reg, 8));

end Behavioral;
