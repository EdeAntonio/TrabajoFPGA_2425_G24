----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.01.2025 19:33:52
-- Design Name: 
-- Module Name: petition_tb - Behavioral
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

entity tb_Petition is
end tb_Petition;

architecture tb of tb_Petition is

    component Petition
        port (inpet  : in std_logic_vector (3 downto 0);
              rm     : in std_logic;
              pos    : in std_logic_vector (1 downto 0);
              outpet : out std_logic_vector (3 downto 0));
    end component;

    signal inpet  : std_logic_vector (3 downto 0);
    signal rm     : std_logic;
    signal pos    : std_logic_vector (1 downto 0);
    signal outpet : std_logic_vector (3 downto 0);

    type vtest is record
        insim: std_logic_vector (3 downto 0);
        rmsim: std_logic;
        possim: std_logic_vector (1 downto 0);
        outsim: std_logic_vector (3 downto 0);
    end record;
    
    type vtest_vector is array (natural RANGE <>) of vtest;
    
    constant test: vtest_vector := (
        (insim => "1000", rmsim => '0', possim => "00", outsim => "1000"),
        (insim => "0000", rmsim => '0', possim => "10", outsim => "1000"), 
        (insim => "0010", rmsim => '1', possim => "11", outsim => "0010"),
        (insim => "0000", rmsim => '0', possim => "01", outsim => "0010"),
        (insim => "0000", rmsim => '1', possim => "01", outsim => "0000")
    );
begin

    dut : Petition
    port map (inpet  => inpet,
              rm     => rm,
              pos    => pos,
              outpet => outpet);

    stimuli : process
    begin
        wait for 20ns;
        for i in 0 to test'HIGH loop
            inpet <= test(i).insim;
            rm <= test(i).rmsim;
            pos <= test(i).possim;
            wait for 20ns;
            assert test(i).outsim=outpet
                report "Error en simulación"
                severity error;
        end loop;
        assert false
            report "Fin Simulación"
            severity FAILURE;
        
    end process;

end tb;