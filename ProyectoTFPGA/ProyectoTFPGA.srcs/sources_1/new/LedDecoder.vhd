----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.01.2025 19:29:25
-- Design Name: 
-- Module Name: LedGestor - Behavioral
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

entity LedDecoder is
    port(
        pos: in std_logic_vector(1 downto 0);
        move: in std_logic_vector(1 downto 0);
        door: in std_logic;
        elev_led: out std_logic_vector(6 downto 0); --display del ascensor
        place_led: out std_logic_vector(6 downto 0); --display de la posicion
        move_led: out std_logic_vector(6 downto 0) -- display del movimiento
        );
end LedDecoder;

architecture dataflow of LedDecoder is
begin
    with move select -- Selección del movimiento indicado en el display
        move_led <= "0001111" when "10", -- 7 indica hacia arriba
                    "1110001" when "01", -- L incia hacia abajo
                    "1111110" when "00", -- - indica parado
                    "0110000" when others; -- E de error
    with door select -- Selección del formato de display del ascensor
        elev_led <= "0000001" when '1', -- 0, un cuadrado abierto
                    "0000000" when '0', -- 8, un cuadrado con una linea en medio
                    "0110000" when others;
    with pos select -- Selección del piso indicado en el display
        place_led <= "0000001" when "00",
                     "1001111" when "01",
                     "0010010" when "10",
                     "0000110" when "11",
                     "0110000" when others;
end dataflow;