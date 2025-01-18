----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.01.2025 17:37:17
-- Design Name: 
-- Module Name: Gestor_tb - Behavioral
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
library ieee;
use ieee.std_logic_1164.all;

entity tb_Gestor is
end tb_Gestor;

architecture tb of tb_Gestor is

    component Gestor
        port (pet      : in std_logic_vector (3 downto 0);
              pos      : in std_logic_vector (1 downto 0);
              move     : in std_logic_vector (1 downto 0);
              decision : out std_logic_vector (1 downto 0));
    end component;

    signal pet      : std_logic_vector (3 downto 0) := "1001";
    signal pos      : std_logic_vector (1 downto 0) := "11";
    signal move     : std_logic_vector (1 downto 0) := "00";
    signal decision : std_logic_vector (1 downto 0) := "11";

    type vtest is record
        petsim: std_logic_vector (3 downto 0);
        possim: std_logic_vector (1 downto 0);
        movesim: std_logic_vector (1 downto 0);
        decisim: std_logic_vector (1 downto 0);
    end record;
    
    type vtest_vector is array (natural RANGE <>) of vtest;
    
    constant test: vtest_vector := (
        (petsim => "1001", possim => "01", movesim => "10", decisim => "11"),
         -- si se mueve para arriva y hay una petición arriba continúa para arriba "11"
        (petsim => "1001", possim => "01", movesim => "01", decisim => "10"),
        -- si se mueve para abajo y hay una petición ababjo continúa para abajo "10"
        (petsim => "1001", possim => "01", movesim => "00", decisim => "10"),
        (petsim => "1001", possim => "10", movesim => "00", decisim => "11"),
        (petsim => "1011", possim => "10", movesim => "00", decisim => "10"),
        -- si no se mueve y va a la petición más cercana priorizando la más baja
        (petsim => "0001", possim => "01", movesim => "10", decisim => "10"),
         -- si se mueve para arriva y no hay una petición arriba busca abajo, si encuentra va
        (petsim => "1000", possim => "01", movesim => "01", decisim => "11"),
        -- si se mueve para abajo y no hay una petición abajo busca arriba, si encuentra va
        (petsim => "0000", possim => "01", movesim => "01", decisim => "00"),
        (petsim => "0000", possim => "01", movesim => "10", decisim => "00"),
        -- si no hay peticiones se detiene
        (petsim => "0010", possim => "01", movesim => "01", decisim => "01"),
        (petsim => "0100", possim => "10", movesim => "10", decisim => "01"),
        (petsim => "1000", possim => "11", movesim => "01", decisim => "01"),
        (petsim => "0001", possim => "00", movesim => "10", decisim => "01"),
        --si esta en la posición abre la puerta sin importar lo que pase
        (petsim => "1000", possim => "00", movesim => "00", decisim => "11")
        --alcance máximo de la serie.
    );
begin

    dut : Gestor
    port map (pet      => pet,
              pos      => pos,
              move     => move,
              decision => decision
              );

    stimuli : process
    begin
        wait for 5 ns;
        for i in 0 to test'HIGH loop
            pet <= test(i).petsim;
            pos <= test(i).possim;
            move <= test(i).movesim;
            wait for 10ns;
            assert decision = test(i).decisim
                report "Fallo en el test"
                severity Failure;
            wait for 10ns;    
        end loop;   
        assert false
            report "Fin Prueba"
            severity FAILURE;
    end process;

end tb;
