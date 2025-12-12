library ieee;
use ieee.std_logic_1164.all;

entity controlador is
    port(
        clk           : in  std_logic;
        numero_1      : in  std_logic_vector(3 downto 0);
        numero_2      : in  std_logic_vector(3 downto 0);
        confirmacao   : in  std_logic;
        sel_op        : in  std_logic_vector(2 downto 0);
        resultado_ula : in  std_logic_vector(7 downto 0);

        numero_1_out  : out std_logic_vector(3 downto 0);
        numero_2_out  : out std_logic_vector(3 downto 0);
        resultado     : out std_logic_vector(7 downto 0);
        sel_op_out    : out std_logic_vector(2 downto 0);
        LED_estados   : out std_logic_vector(2 downto 0);
        LED_confirmacao : out std_logic
    );
end controlador;

architecture behavioral of controlador is 
    type estado is (inicio, espera, valor_a, valor_b, mostra_resultado);
    signal estado_atual : estado := inicio;

    signal A_reg, B_reg : std_logic_vector(3 downto 0);
    signal op_reg       : std_logic_vector(2 downto 0);
    
begin

    process(clk)
    begin
        if rising_edge(clk) then
            -- Logica de mudanca de estado e registradores
            LED_confirmacao <= '0'; -- Padrao

            case estado_atual is
                when inicio =>
                    LED_estados <= "000";
                    A_reg <= (others => '0');
                    B_reg <= (others => '0');
                    op_reg <= (others => '0');
                    resultado <= (others => '0'); -- Zera saida
                    estado_atual <= espera;
                
                when espera =>
                    LED_estados <= "001";
                    if confirmacao = '1' then
                        op_reg <= sel_op;     
                        estado_atual <= valor_a;
                    end if;

                when valor_a =>
                    LED_estados <= "010";
                    if confirmacao = '1' then
                        A_reg <= numero_1;    
                        estado_atual <= valor_b;
                    end if;

                when valor_b =>
                    LED_estados <= "011";
                    if confirmacao = '1' then
                        B_reg <= numero_2;    
                        estado_atual <= mostra_resultado;
                    end if;

                when mostra_resultado =>
                    LED_estados <= "100";
                    
                    resultado <= resultado_ula;

                    if confirmacao = '1' then
                        resultado <= (others => '0'); -- Zera ao sair
                        estado_atual <= espera;
                    end if;
            end case;
        end if;
    end process;

   
    numero_1_out <= A_reg;
    numero_2_out <= B_reg;
    sel_op_out   <= op_reg;

end behavioral;