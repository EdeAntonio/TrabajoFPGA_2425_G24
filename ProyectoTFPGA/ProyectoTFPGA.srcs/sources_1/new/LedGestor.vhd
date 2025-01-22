----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.01.2025 19:31:58
-- Design Name: 
-- Module Name: LedDecoder - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity LedGestor is
    generic(
        timelimit: integer := 10**8
        );
    port(
        clk: in std_logic;
        elev_led: in std_logic_vector(6 downto 0);
        move_led: in std_logic_vector(6 downto 0);
        place_led: in std_logic_vector(6 downto 0);
        pos: in std_logic_vector(1 downto 0);
        led_on: out std_logic_vector(6 downto 0);
        display_on: out std_logic_vector(7 downto 0)
        );
end LedGestor;

architecture Behavioral of LedGestor is
    signal led_an: std_logic_vector (7 downto 0) := "00110000";
    signal count: integer := 0;
    signal onOut: std_logic_vector(6 downto 0);
    signal tup: std_logic;
begin
    FqAdt: process(clk)
    variable timecount : integer := 0;        -- Variable interna para contar el tiempo
    begin
        if rising_edge(clk) then                -- Se ejecuta en el flanco de subida del reloj
            timecount := timecount + 1;           -- Incrementa el contador de tiempo
            if timecount = (timelimit/(2*10**3)) then        
                tup <= '0';                        -- Señal `tup` en bajo después del primer intervalo
            end if;
            if timecount = (timelimit/10**3) then
                timecount := 0;                    -- Reinicia el contador después de 2 intervalos
                tup <= '1';                        -- Señal `tup` en alto para indicar actualización
                if count >= 7 then
                    count <= 0;
                else
                    count <= count + 1;
                end if;
            end if;
        end if;
    end process;    
    KDis: process (pos)
    begin
        case pos is
            when "00" => led_an <= "11001110";
            when "01" => led_an <= "11001101";
            when "10" => led_an <= "11001011";
            when "11" => led_an <= "11000111";
            when others => led_an <= "01001111";
        end case;
    end process;
    
    SDis: process (count)
    begin
        display_on <= (others => '1');
        display_on(count)<=led_an(count);                           
        case count is
            when 0|1|2|3 =>
                led_on <= elev_led;
            when 4 =>
                led_on <= place_led;
            when 5|6 => 
                led_on <= move_led;
            when 7 =>
                led_on <= "0110000";
            when others =>
                led_on <= "0110000";
        end case;
    end process;
end Behavioral;
