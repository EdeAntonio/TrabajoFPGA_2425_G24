----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 22.01.2025 23:13:38
-- Design Name: 
-- Module Name: StableDeci - Behavioral
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

entity StableDeci is
    port(
        Decision: in std_logic_vector(1 downto 0);
        clk: in std_logic;
        StDeciOut: out std_logic_vector (1 downto 0)
        );
end StableDeci;

architecture dataflow of StableDeci is

begin
    P1: process(clk)
    begin 
        if rising_edge(clk) then
            case Decision is 
                when "11" => StDeciOut <= "10";
                when "10" => StDeciOut <= "01";
                when "00" => StDeciOut <= "00";
                when others => null;
            end case;
        end if;
    end process;
end dataflow;
