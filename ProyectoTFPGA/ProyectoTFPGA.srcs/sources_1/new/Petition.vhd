----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.01.2025 18:21:08
-- Design Name: 
-- Module Name: Petition - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

entity Petition is
    Port ( 
        inpet : in std_logic_vector(3 downto 0); --Entrada sincronizada de las peticiones
        rm : in std_logic; --Señal para eliminar una peticion
        pos : in std_logic_vector (1 downto 0); --Posición donde se elimina la señal
        reset: in std_logic; --Señal de reseteo para reiniciar la entidad
        outpet : out std_logic_vector(3 downto 0) --Salida de las peticiones         
    );
end Petition;

architecture Behavioral of Petition is
    signal outsig: std_logic_vector(3 downto 0) := "0000"; -- Señal intermedia que guarda las peticiones
begin
    p0: process(inpet, rm, reset)
    begin
        if inpet(0) = '1' then -- Guardar peticion en planta 0
            outsig(0) <= '1';
        end if;
        if inpet(1) = '1' then -- Guardar petición en planta 1
            outsig(1) <= '1';
        end if;
        if inpet(2) = '1' then -- Guardar peticion en planta 3
            outsig(2) <= '1';
        end if;
        if inpet(3) = '1' then -- Guardar peticion en planta 4
            outsig(3) <= '1';
        end if;
        if rm = '1' then -- Eliminar la petición en la posición correspondiente
            outsig(to_integer(unsigned(pos))) <= '0';
        end if;
        if reset = '0' then -- Resetear la señal
            outsig <= (others => '0');
        end if;
    end process;
    outpet <= outsig; --Conectar la señal intermedia a la de salida
end Behavioral;

