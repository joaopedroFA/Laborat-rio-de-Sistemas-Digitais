-- ELE0518 - LABORATORIO DE SISTEMAS DIGITAIS - T03 (2025.2)
-- Arquivo: projeto_vending_machine.vhd (Top Level Entity)
-- REVISÃO FINAL DE DEBUG: Clock rápido + Visualização de C1/C0 nos LEDs.

library ieee;
use ieee.std_logic_1164.all;

entity projeto_vending_machine is
    port (
        CLOCK_50 : in std_logic;
        KEY      : in std_logic_vector(3 downto 0);  -- Botões
        SW       : in std_logic_vector(3 downto 0);  -- Chaves (C1 e C0)
        
        -- Saídas
        -- Agora usamos 6 LEDs (0 a 5) para debug completo
        LEDR     : out std_logic_vector(5 downto 0); 
        
        HEX0     : out std_logic_vector(6 downto 0); 
        HEX1     : out std_logic_vector(6 downto 0); 
        HEX2     : out std_logic_vector(6 downto 0)
    );
end projeto_vending_machine;

architecture Structural of projeto_vending_machine is

    component divisor_clock is
        generic (FATOR_DIVISAO : integer);
        port (clk_fpga : in std_logic; rst : in std_logic; clk_lento : out std_logic);
    end component;

    component maquina_doces is
        port (clk : in std_logic; rst : in std_logic; C1 : in std_logic; C0 : in std_logic;
              Cin : in std_logic; S : in std_logic; D : out std_logic_vector(7 downto 0); R : out std_logic);
    end component;

    component binario_para_bcd_8bits is
        port (entrada_8b : in std_logic_vector(7 downto 0);
              centena_bcd, dezena_bcd, unidade_bcd : out std_logic_vector(3 downto 0));
    end component;

    component bcd is
        port(numero_binario : in std_logic_vector(3 downto 0); numero_7seg : out std_logic_vector(6 downto 0));
    end component;

    signal s_clk_lento, s_rst : std_logic;
    signal s_C1, s_C0, s_Cin, s_S : std_logic;
    signal s_saldo : std_logic_vector(7 downto 0);
    signal s_uni, s_dez, s_cen : std_logic_vector(3 downto 0);

begin
    -- ========================================================================
    -- TRATAMENTO DE ENTRADAS
    -- ========================================================================
    s_rst <= not KEY(0); 
    s_S   <= not KEY(1);
    s_Cin <= not KEY(2);
    
    s_C1  <= SW(1); -- Chave 1 é o Bit mais significativo da moeda
    s_C0  <= SW(0); -- Chave 0 é o Bit menos significativo da moeda

    -- ========================================================================
    -- INSTANCIAÇÕES
    -- ========================================================================

    -- Divisor ajustado para 250.000 (aprox 100Hz) para resposta rápida dos botões
    U1_DIVISOR: divisor_clock
        generic map (FATOR_DIVISAO => 250000) 
        port map (
            clk_fpga  => CLOCK_50,
            rst       => s_rst,
            clk_lento => s_clk_lento
        );

    U2_FSM: maquina_doces
        port map (
            clk => s_clk_lento,
            rst => s_rst,
            C1  => s_C1,
            C0  => s_C0,
            Cin => s_Cin,
            S   => s_S,
            D   => s_saldo,
            R   => LEDR(0) -- LED 0: Indica LIBERAÇÃO DO DOCE (Saída R)
        );

    -- ========================================================================
    -- PAINEL DE DEBUG (LEDS)
    -- ========================================================================
    
    -- LED 0 está conectado à saída R da máquina (acima)
    
    -- LED 1: Monitora se o botão de inserir moeda (Cin) está sendo detectado
    LEDR(1) <= s_Cin;       
    
    -- LED 2: Monitora o Clock ("batimento cardíaco" do sistema)
    LEDR(2) <= s_clk_lento; 
    
    -- LED 3: Monitora o Reset
    LEDR(3) <= s_rst;       

    -- NOVOS LEDS DE MONITORAMENTO DAS CHAVES:
    LEDR(4) <= s_C0; -- Acende se a Chave 0 (SW0) estiver levantada/ligada
    LEDR(5) <= s_C1; -- Acende se a Chave 1 (SW1) estiver levantada/ligada

    -- ========================================================================
    -- DISPLAYS
    -- ========================================================================
    U3: binario_para_bcd_8bits port map(s_saldo, s_cen, s_dez, s_uni);
    U4: bcd port map(s_uni, HEX0);
    U5: bcd port map(s_dez, HEX1);
    U6: bcd port map(s_cen, HEX2);

end Structural;