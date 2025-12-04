-- ELE0518 - LABORATORIO DE SISTEMAS DIGITAIS - T03 (2025.2)
-- Autor    : João Pedro Freire de Albuquerque
-- Data     : 04/12/2025
-- Projeto  : Máquina de doces (FSM)

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity maquina_de_doces is
    port(
        clk             : in  std_logic;

        -- Entradas
        valorMoeda      : in  std_logic_vector(1 downto 0);
        entradaMoeda    : in  std_logic;
        liberarDoce     : in  std_logic;

        -- Saídas
        valorAcumulado  : out std_logic_vector(7 downto 0);
        ledDoce         : out std_logic;

        -- Debug do estado
        q               : out std_logic
    );
end maquina_de_doces;

architecture top_level of maquina_de_doces is

    -- Sinais
    signal perm          : std_logic;
    signal acum          : std_logic_vector(7 downto 0);
    signal estado        : std_logic := '0';
    signal centenas      : std_logic_vector(3 downto 0);
    signal dezenas       : std_logic_vector(3 downto 0);
    signal unidades      : std_logic_vector(3 downto 0);

    signal segC, segD, segU : std_logic_vector(6 downto 0);

    component valor_total is
        port(
            clk             : in  std_logic;
            valorMoeda      : in  std_logic_vector(1 downto 0);
            entradaMoeda    : in  std_logic;
            valorAcumulado  : out std_logic_vector(7 downto 0);
            permissao       : out std_logic
        );
    end component;

    component bcd is
        port(
            numero_binario  : in  std_logic_vector(3 downto 0);
            numero_7seg     : out std_logic_vector(6 downto 0)
        );
    end component;

begin

    contador_valor : valor_total
        port map(
            clk             => clk,
            valorMoeda      => valorMoeda,
            entradaMoeda    => entradaMoeda,
            valorAcumulado  => acum,
            permissao       => perm
        );

    valorAcumulado <= acum;



    process(clk)
    begin
        if rising_edge(clk) then
            if liberarDoce = '1' and perm = '1' then
                ledDoce <= '1';
                estado  <= '1';
            else
                ledDoce <= '0';
                estado  <= '0';
            end if;
        end if;
    end process;

    q <= estado;



    centenas <= std_logic_vector(unsigned(acum) / 100);
    dezenas  <= std_logic_vector((unsigned(acum) / 10) mod 10);
    unidades <= std_logic_vector(unsigned(acum) mod 10);



    digC : bcd
        port map(numero_binario => centenas, numero_7seg => segC);

    digD : bcd
        port map(numero_binario => dezenas, numero_7seg => segD);

    digU : bcd
        port map(numero_binario => unidades, numero_7seg => segU);

end architecture;
