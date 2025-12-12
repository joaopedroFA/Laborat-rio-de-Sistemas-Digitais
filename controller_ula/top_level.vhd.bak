library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_level is
    port(
        clk50       : in  std_logic;
        reset       : in  std_logic;

        -- Entradas do Usuario
        numero_1_sw : in std_logic_vector(3 downto 0);
        numero_2_sw : in std_logic_vector(3 downto 0);
        sel_op_sw   : in std_logic_vector(2 downto 0);
        confirm_sw  : in std_logic; -- Botao de avanco

        -- Displays de 7 segmentos
        disp_A_un   : out std_logic_vector(6 downto 0); -- Unidade de A
        disp_A_dez  : out std_logic_vector(6 downto 0); -- Dezena de A
        disp_B_un   : out std_logic_vector(6 downto 0); -- Unidade de B
        disp_B_dez  : out std_logic_vector(6 downto 0); -- Dezena de B
        disp_R_cen  : out std_logic_vector(6 downto 0); -- Centena Resultado
        disp_R_dez  : out std_logic_vector(6 downto 0); -- Dezena Resultado
        disp_R_uni  : out std_logic_vector(6 downto 0); -- Unidade Resultado

        -- LEDs debug
        LED_estados    : out std_logic_vector(2 downto 0);
        LED_confirma   : out std_logic;

        -- LCD
        LCD_DATA  : out std_logic_vector(7 downto 0);
        LCD_RW    : out std_logic;
        LCD_EN    : out std_logic;
        LCD_RS    : out std_logic;
        LCD_ON    : out std_logic;
        LCD_BLON  : out std_logic
    );
end top_level;

architecture structural of top_level is

    -- Sinais de interconexao
    signal s_num1, s_num2 : std_logic_vector(3 downto 0);
    signal s_op           : std_logic_vector(2 downto 0);
    signal s_result_ula   : std_logic_vector(7 downto 0); -- 8 bits

    -- Sinais para BCD
    signal A_dez, A_uni : std_logic_vector(3 downto 0);
    signal B_dez, B_uni : std_logic_vector(3 downto 0);
    signal R_cen, R_dez, R_uni : std_logic_vector(3 downto 0);

begin

    -- 1) CONTROLADOR
    U_CTRL : entity work.controlador
        port map(
            clk            => clk50,
            numero_1       => numero_1_sw,
            numero_2       => numero_2_sw,
            confirmacao    => confirm_sw,
            sel_op         => sel_op_sw,
            resultado_ula  => s_result_ula, 
            
            numero_1_out   => s_num1, 
            numero_2_out   => s_num2,
            resultado      => open, 
            sel_op_out     => s_op,
            LED_estados    => LED_estados,
            LED_confirmacao => LED_confirma
        );

    -- 2) ULA
    U_ALU : entity work.ula
        port map(
            a      => s_num1,
            b      => s_num2,
            sel_op => s_op,
            result => s_result_ula
        );

    

   
    U_CONV_A : entity work.bin4_to_bcd
        port map (bin_in => s_num1, bcd_dez => A_dez, bcd_uni => A_uni);

    
    U_CONV_B : entity work.bin4_to_bcd
        port map (bin_in => s_num2, bcd_dez => B_dez, bcd_uni => B_uni);


    U_CONV_R : entity work.bin8_to_bcd
        port map (bin_in => s_result_ula, bcd_cen => R_cen, bcd_dez => R_dez, bcd_uni => R_uni);


    
    
    -- Displays A
    DISP_A_D : entity work.bcd port map(numero_binario => A_dez, numero_7seg => disp_A_dez);
    DISP_A_U : entity work.bcd port map(numero_binario => A_uni, numero_7seg => disp_A_un);

    -- Displays B
    DISP_B_D : entity work.bcd port map(numero_binario => B_dez, numero_7seg => disp_B_dez);
    DISP_B_U : entity work.bcd port map(numero_binario => B_uni, numero_7seg => disp_B_un);

    -- Displays Resultado
    DISP_R_C : entity work.bcd port map(numero_binario => R_cen, numero_7seg => disp_R_cen);
    DISP_R_D : entity work.bcd port map(numero_binario => R_dez, numero_7seg => disp_R_dez);
    DISP_R_U : entity work.bcd port map(numero_binario => R_uni, numero_7seg => disp_R_uni);

    -- 5) LCD
    U_LCD : entity work.lcd_controller
        port map(
            Clk50Mhz => clk50,
            reset    => reset,
            sel_op   => s_op(2 downto 0), 
            LCD_DATA => LCD_DATA,
            LCD_RW   => LCD_RW,
            LCD_EN   => LCD_EN,
            LCD_RS   => LCD_RS,
            LCD_ON   => LCD_ON,
            LCD_BLON => LCD_BLON
        );

end structural;