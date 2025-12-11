library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- CONVERSOR PARA ENTRADAS (4 bits -> 00 a 15)
entity bin4_to_bcd is
    port(
        bin_in  : in  std_logic_vector(3 downto 0);
        bcd_dez : out std_logic_vector(3 downto 0);
        bcd_uni : out std_logic_vector(3 downto 0)
    );
end bin4_to_bcd;

architecture behavior of bin4_to_bcd is
    signal val_int : integer range 0 to 15;
begin
    val_int <= to_integer(unsigned(bin_in));
    
    process(val_int)
    begin
        if val_int >= 10 then
            bcd_dez <= "0001"; -- Dezena é 1
            bcd_uni <= std_logic_vector(to_unsigned(val_int - 10, 4));
        else
            bcd_dez <= "0000"; -- Dezena é 0
            bcd_uni <= std_logic_vector(to_unsigned(val_int, 4));
        end if;
    end process;
end behavior;

-----------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity bin8_to_bcd is
    port(
        bin_in  : in  std_logic_vector(7 downto 0);
        bcd_cen : out std_logic_vector(3 downto 0);
        bcd_dez : out std_logic_vector(3 downto 0);
        bcd_uni : out std_logic_vector(3 downto 0)
    );
end bin8_to_bcd;

architecture behavior of bin8_to_bcd is
begin
    process(bin_in)
        variable i : integer;
        variable bcd : unsigned(11 downto 0); -- 3 digitos x 4 bits
        variable bin : unsigned(7 downto 0);
    begin
        bcd := (others => '0');
        bin := unsigned(bin_in);

        
        
        bcd_cen <= std_logic_vector(to_unsigned((to_integer(bin) / 100) mod 10, 4));
        bcd_dez <= std_logic_vector(to_unsigned((to_integer(bin) / 10) mod 10, 4));
        bcd_uni <= std_logic_vector(to_unsigned(to_integer(bin) mod 10, 4));
    end process;
end behavior;