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

begin
    p1: process (pos)
    begin
        case pos is
            when "00" => led_an <= "11001110";
            when "01" => led_an <= "11001101";
            when "10" => led_an <= "11001011";
            when "11" => led_an <= "11000111";
            when others => led_an <= "01001111";
        end case;
    end process;
    
    p2: process (clk)
    variable count: integer := 0;
    begin
    if rising_edge(clk) then
        display_on <= (others => '1');
        display_on(count) <= led_an(count);
        if -1 < count and count < 4 then
            led_on <= elev_led;
        elsif count = 4 then
            led_on <= place_led;
        elsif count = 5 then
            led_on <= move_led;
        elsif count = 7 then
            led_on <= "0110000";
            count := -1;
        end if;
        count := count + 1;
     end if;
     end process;
end Behavioral;
