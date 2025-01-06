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
        pet : in STD_LOGIC_VECTOR (3 downto 0);
        pos : in STD_LOGIC_VECTOR (1 downto 0);
        move : in STD_LOGIC_VECTOR (1 downto 0);
        decision: out STD_LOGIC_VECTOR (1 downto 0)
        );
end Gestor;
--decision code 00 nada 01 puerta 10 abajo 11 arriba
architecture Behavioral of Gestor is
type secuence is array (0 to 3) of integer;
constant serieum: secuence := (-1,1,-2,2);
begin
    p1: process(move, pos, pet)
    variable i: integer := 0;
    variable place: integer := 0;
    variable flagPet: boolean := false;
    begin
    while flagPet = false loop
    
        if move="10" then --Tratamiento cuando el ascensor sube
            place := i + TO_INTEGER(unsigned(pos)); --Calculo posicion a comparar
            if place > 3 then --Corrección overflow
                place := to_integer(unsigned(pos)) - i;
            end if;
            if pet(place)='1' then
                flagPet := true;
                if i = 0 then
                    decision <= "01";
                end if;
                if i <= (3 - to_integer(unsigned(pos))) then
                    decision <= "11";
                end if;
                if i > (3 - to_integer(unsigned(pos))) then 
                    decision <= "01";
                end if;
            end if;
            if i=3 then 
                if flagPet = false then
                    decision <= "00";
                    flagPet := true;
                end if;
            end if;     
        end if;
        
        if move="01" then --Tratamiento cuando el ascensor baja
            place := TO_INTEGER(unsigned(pos)) - i; -- Calculo posición
            if place < 0 then -- Tratamiento overflow
                place := i + to_integer(unsigned(pos));
            end if;
            if pet(place)='1' then --Detecta petición
                flagPet := true;
                if i = 0 then
                    decision <= "01";
                end if;
                if i > to_integer(unsigned(pos)) then
                    decision <= "10";
                end if;
                if i <= to_integer(unsigned(pos)) then 
                    decision <= "01";
                end if;
            end if;
            if i=3 then -- Final del bucle
                if flagPet = false then
                    decision <= "00";
                    flagPet := true;
                end if;
            end if;     
        end if;
        
        if move="00" then --Tratamiento cuando esta parado.
            place := i + serieum(i);
            if place > 3 or place < 0 then
                if i=4 and flagPet = false then
                    decision <= "00";
                    flagPet := true;
                end if;
                i:= i + 1;
                next;
            end if;
            if pet(place)='1' then
                flagPet := true;
                if i = 0 then
                    decision <= "01";
                end if;
                if place > to_integer(unsigned(pos)) then
                    decision <= "11";
                end if;
                if place < to_integer(unsigned(pos)) then 
                    decision <= "10";
                end if;
            end if;
            if i=4 then 
                if flagPet = false then
                    flagPet := true;
                    decision <= "00";
                end if;
            end if;     
        end if;
        i := i + 1;
    end loop;
    end process;
end Behavioral;

