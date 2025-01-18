----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.01.2025 19:41:59
-- Design Name: 
-- Module Name: GestorPet - Behavioral
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

entity Gestor is
    Port ( 
        pet : in STD_LOGIC_VECTOR (3 downto 0); --Peticiones activas
        pos : in STD_LOGIC_VECTOR (1 downto 0); --Posición actual
        move : in STD_LOGIC_VECTOR (1 downto 0); --Dirección actual
        decision: out STD_LOGIC_VECTOR (1 downto 0) --Decisión final
        );
end Gestor;
--decision 00 estático 01 puerta 10 abajo 11 arriba
architecture Behavioral of Gestor is
type secuence is array (0 to 6) of integer; -- Vector para registrar el orden de observación en el caso de parada.
constant serieum: secuence := (0,-1,1,-2,2,-3,3); -- Orden de observación
begin
    p1: process (pos, move, pet)
    variable place: integer := 0; -- Posición a observar
    variable flagPet: boolean := false; -- Indicador de petición
    begin
    flagPet := false; -- Reseteamos la entrada cada nuevo proceso
    for i in 0 to 6 loop -- Bucle de observación
        exit when flagPet = true; -- Salida del bucle
        if move="10" then --Tratamiento cuando el ascensor sube
            place := i + TO_INTEGER(unsigned(pos)); --Calculo posicion a observar (empezamos a mirar hacia arriba)
            if place > 3 then --Corrección overflow
                -- Cuando salimos del rango comenzamos a mirar para abajo
                place := to_integer(unsigned(pos)) - (i - 3 + to_integer(unsigned(pos))); 
            end if;
            if pet(place)='1' then -- Detección petición
                flagPet := true; -- Marcamos el indicador
                -- Comparamos si estamos arriba abajo o en la petición
                if i <= (3 - to_integer(unsigned(pos))) then
                    decision <= "11"; -- Esta arriba
                end if;
                if i > (3 - to_integer(unsigned(pos))) then 
                    decision <= "10"; -- Esta abajo
                end if;
                if i = 0 then
                    decision <= "01"; -- Estamos en la petición
                end if;
            end if;
            if i=3 then 
                if flagPet = false then -- Si no hay ninguna petición
                    decision <= "00"; -- Nos detenemos
                    flagPet := true; -- Terminamos el bucle
                end if;
            end if;     
        end if;
        
        if move="01" then --Tratamiento cuando el ascensor baja
            place := TO_INTEGER(unsigned(pos)) - i; -- Calculo posición (comenzamos a mirar hacia abajo)
            if place < 0 then -- Tratamiento overflow
                place := i; -- Comenzamos a mirar desde arriba de la posición
            end if;
            if pet(place)='1' then --Detecta petición
                flagPet := true; -- Marcamos el indicador
                if i > to_integer(unsigned(pos)) then
                    decision <= "11"; -- La petición esta arriba
                end if;
                if i <= to_integer(unsigned(pos)) then 
                    decision <= "10"; -- La petición esta abajo
                end if;
                if i = 0 then
                    decision <= "01"; -- Estamos en la petción
                end if;
            end if;
            if i=3 then -- Final del bucle
                if flagPet = false then
                    decision <= "00"; -- No hay petición
                    flagPet := true; -- Terminamos bucle
                end if;
            end if;     
        end if;
        
        if move="00" then --Tratamiento cuando esta parado.
            place := TO_INTEGER(unsigned(pos)) + serieum(i); -- Alternamos por cercanía empezando por abajo.
            if place > 3 or place < 0 then -- Si nos hemos salido del vector
                if i=6 and flagPet = false then -- El bucle ha terminado y no hemos encontrado petición
                    decision <= "00"; -- No hay ninguna petición 
                    flagPet := true;
                end if;
                next; -- Pasamos a la siguiente iteración
            end if;
            if pet(place)='1' then -- Encontramos la petición
                flagPet := true;
                if place > to_integer(unsigned(pos)) then
                    decision <= "11"; -- La petición esta arriba
                end if;
                if place < to_integer(unsigned(pos)) then 
                    decision <= "10"; -- La petición esta abajo
                end if;
                if i = 0 then
                    decision <= "01"; -- Estamos en la petición
                end if;
            end if;
            if i=6 then -- Si estamos dentro y no hemos encontrado petición
                if flagPet = false then
                    flagPet := true; -- Terminamos el bucle
                    decision <= "00"; -- Nos detenemos
                end if;
            end if;     
        end if;
    end loop;
    end process;
end Behavioral;

