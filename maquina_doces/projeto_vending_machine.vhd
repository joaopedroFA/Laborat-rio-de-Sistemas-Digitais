-- ELE0518 - LABORATORIO DE SISTEMAS DIGITAIS - T03 (2025.2)
-- Arquivo: projeto_vending_machine.vhd (Top Level Entity)
-- Autores: Emanoel Ferreira dos Santos e João Pedro Freire de Albuquerque
-- Data: 18/11/2025
-- Descrição: Entidade de topo que integra todos os subsistemas: Divisor de Clock,
--            FSM (Controladora), Conversor de Display e Decodificadores.
--            Responsável por conectar os sinais lógicos aos pinos físicos da FPGA.

library ieee;
use ieee.std_logic_1164.all;

entity projeto_vending_machine is
    port (
        -- Entradas Físicas (Hardware da Placa)
        CLOCK_50 : in std_logic;                     -- Clock mestre da placa (50 MHz)
        KEY      : in std_logic_vector(3 downto 0);  -- Botões de pressão (Push-buttons)
        SW       : in std_logic_vector(3 downto 0);  -- Chaves seletoras (Switches)
        
        -- Saídas Físicas (Hardware da Placa)
        LEDR     : out std_logic_vector(0 downto 0); -- LED Vermelho (Indica liberação do produto)
        HEX0     : out std_logic_vector(6 downto 0); -- Display 7 Seg: Unidade
        HEX1     : out std_logic_vector(6 downto 0); -- Display 7 Seg: Dezena
        HEX2     : out std_logic_vector(6 downto 0)  -- Display 7 Seg: Centena
    );
end projeto_vending_machine;

architecture Structural of projeto_vending_machine is

    -- Declaração do Componente: Divisor de Frequência
    component divisor_clock is
        generic (FATOR_DIVISAO : integer := 25000000);
        port (
            clk_fpga  : in std_logic;
            rst       : in std_logic;
            clk_lento : out std_logic
        );
    end component;

    -- Declaração do Componente: Máquina de Estados (FSM)
    component maquina_doces is
        port (
            clk : in std_logic;
            rst : in std_logic;
            C1  : in std_logic;
            C0  : in std_logic;
            Cin : in std_logic;
            S   : in std_logic;
            D   : out std_logic_vector(7 downto 0);
            R   : out std_logic
        );
    end component;

    -- Declaração do Componente: Conversor Binário para BCD (8 bits -> 3 digitos)
    component binario_para_bcd_8bits is
        port (
            entrada_8b  : in std_logic_vector(7 downto 0);
            centena_bcd : out std_logic_vector(3 downto 0);
            dezena_bcd  : out std_logic_vector(3 downto 0);
            unidade_bcd : out std_logic_vector(3 downto 0)
        );
    end component;

    -- Declaração do Componente: Decodificador BCD para 7 Segmentos
    component bcd is
        port(
            numero_binario : in std_logic_vector(3 downto 0);
            numero_7seg    : out std_logic_vector(6 downto 0)
        );
    end component;

    -- Sinais Internos (Fios virtuais para interconectar os blocos)
    signal s_clk_lento      : std_logic; -- Clock reduzido para a FSM
    signal s_rst            : std_logic; -- Sinal de Reset global tratado
    
    -- Sinais de Controle mapeados dos botões
    signal s_C1, s_C0       : std_logic; -- Valor da moeda
    signal s_Cin, s_S       : std_logic; -- Sinais de inserção e compra
    
    -- Sinais de Dados para o Display
    signal s_saldo_8bits    : std_logic_vector(7 downto 0); -- Saldo total (binário)
    signal s_unidade        : std_logic_vector(3 downto 0); -- Digito Unidade (4 bits)
    signal s_dezena         : std_logic_vector(3 downto 0); -- Digito Dezena (4 bits)
    signal s_centena        : std_logic_vector(3 downto 0); -- Digito Centena (4 bits)

begin

    -- ========================================================================
    -- BLOCO 1: Tratamento das Entradas Físicas
    -- ========================================================================
    -- Nota: Nas placas Altera/Intel (como DE2, DE1), os botões (KEY) são "Active Low".
    -- Isso significa que soltos valem '1' e pressionados valem '0'.
    -- Para a lógica interna funcionar positivamente, invertemos os sinais com 'not'.
    
    s_rst <= not KEY(0); -- Reset conectado ao Botão 0
    s_S   <= not KEY(1); -- Botão de Compra conectado ao Botão 1
    s_Cin <= not KEY(2); -- Sensor de Moeda simulado no Botão 2
    
    s_C1  <= SW(1);      -- Bit mais significativo da moeda na Chave 1
    s_C0  <= SW(0);      -- Bit menos significativo da moeda na Chave 0

    -- ========================================================================
    -- BLOCO 2: Instanciação e Conexão dos Componentes
    -- ========================================================================

    -- Instância U1: Gera um clock lento visível ao olho humano (aprox. 1Hz)
    U1_DIVISOR: divisor_clock
        generic map (FATOR_DIVISAO => 25000000) -- Divide 50MHz para 1Hz (troque na contagem)
        port map (
            clk_fpga  => CLOCK_50,
            rst       => s_rst,
            clk_lento => s_clk_lento
        );

    -- Instância U2: A lógica principal da Máquina de Vendas
    U2_FSM: maquina_doces
        port map (
            clk => s_clk_lento,   -- Usa o clock lento
            rst => s_rst,
            C1  => s_C1,
            C0  => s_C0,
            Cin => s_Cin,
            S   => s_S,
            D   => s_saldo_8bits, -- Sai o valor acumulado
            R   => LEDR(0)        -- Conecta a saída R diretamente ao LED 0
        );

    -- Instância U3: Prepara os dados para visualização (Binário -> Cent/Dez/Uni)
    -- Nota: Aqui não usamos o clock lento, pois a conversão deve ser instantânea visualmente.
    -- O código desse bloco é combinacional ou usa o clock rápido apenas para atualização.
    U3_SEPARADOR: binario_para_bcd_8bits
        port map (
            entrada_8b  => s_saldo_8bits,
            centena_bcd => s_centena,
            dezena_bcd  => s_dezena,
            unidade_bcd => s_unidade
        );
    
    -- Instâncias U4, U5, U6: Decodificadores para cada display físico
    U4_DISP_UNI: bcd port map (numero_binario => s_unidade, numero_7seg => HEX0);
    U5_DISP_DEZ: bcd port map (numero_binario => s_dezena,  numero_7seg => HEX1);
    U6_DISP_CEN: bcd port map (numero_binario => s_centena, numero_7seg => HEX2);

end Structural;