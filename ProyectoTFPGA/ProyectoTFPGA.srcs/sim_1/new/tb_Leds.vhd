----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.01.2025 16:30:15
-- Design Name: 
-- Module Name: tb_Leds - Behavioral
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

entity tb_Leds is
end tb_Leds;

architecture tb of tb_Leds is

    component LedGestor
        generic(
                timelimit: integer := 10**8
            ); 
        port (clk        : in std_logic;
              elev_led   : in std_logic_vector (6 downto 0);
              move_led   : in std_logic_vector (6 downto 0);
              place_led  : in std_logic_vector (6 downto 0);
              pos        : in std_logic_vector (1 downto 0);
              led_on     : out std_logic_vector (6 downto 0);
              display_on : out std_logic_vector (7 downto 0));
    end component;
    component LedDecoder
        port(
             pos: in std_logic_vector(1 downto 0);
            move: in std_logic_vector(1 downto 0);
            door: in std_logic;
            elev_led: out std_logic_vector(6 downto 0);
            place_led: out std_logic_vector(6 downto 0);
            move_led: out std_logic_vector(6 downto 0)
        );
    end component;

    signal clk        : std_logic;
    signal move       : std_logic_vector (1 downto 0);
    signal door       : std_logic;
    signal pos        : std_logic_vector (1 downto 0);
    signal elev_led   : std_logic_vector (6 downto 0);
    signal move_led   : std_logic_vector (6 downto 0);
    signal place_led  : std_logic_vector (6 downto 0);
    signal led_on     : std_logic_vector (6 downto 0);
    signal display_on : std_logic_vector (7 downto 0);

    constant TbPeriod : time := 10 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    
begin
    LD: LedDecoder
    port map(pos => pos,
             move => move,
             door => door,
             elev_led => elev_led,
             place_led => place_led,
             move_led => move_led
             );
    LG : LedGestor
    generic map(timelimit => 2*10**3)
    port map (clk        => clk,
              elev_led   => elev_led,
              move_led   => move_led,
              place_led  => place_led,
              pos        => pos,
              led_on     => led_on,
              display_on => display_on);
    
    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2;

    -- EDIT: Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        move <= "00";
        door <= '0';
        pos <= "00";
        wait for 80*TbPeriod;
        assert false
            report "fin simulacion"
            severity failure;
    end process;

end tb;
