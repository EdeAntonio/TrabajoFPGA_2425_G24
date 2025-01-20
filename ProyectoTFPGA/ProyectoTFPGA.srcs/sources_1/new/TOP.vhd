----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.01.2025 21:21:32
-- Design Name: 
-- Module Name: TOP - Behavioral
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


entity TOP is
    generic(
        clk_frecuency: integer := 10**8
    );
    Port ( 
        pulsador: in std_logic_vector (3 downto 0);
        clk: in std_logic;
        reset: in std_logic;
        anLed: out std_logic_vector (7 downto 0);
        disLed: out std_logic_vector (6 downto 0);
        upMot: out std_logic;
        downMot: out std_logic;
        puerta: out std_logic;
        peticion: out std_logic_vector(3 downto 0)
    );
end TOP;

architecture Estructural of TOP is
--Componente sincronizador y sus señales
    component SYNCHRNZR
        port(
            CLK: in std_logic;
            ASYNC_IN: in std_logic;
            SYNC_OUT: out std_logic
        );
     end component;
    signal outSinc: std_logic_vector(3 downto 0);
--Componente detector de flancos y sus señales
    component EDGEDTCTR
        port(
            CLK: in std_logic;
            SYNC_IN: in std_logic;
            EDGE: out std_logic
        );
    end component;
    signal outEdge: std_logic_vector(3 downto 0);
--Componente registrados de peticiones y sus señales
    component Petition 
        port ( 
        inpet : in std_logic_vector(3 downto 0);
        clk : in std_logic;
        rm : in std_logic;
        pos : in std_logic_vector (1 downto 0);
        reset: in std_logic;
        outpet : out std_logic_vector(3 downto 0)             
        );
    end component;
    signal outPet: std_logic_vector(3 downto 0);
--Componente registro posición y sus señales
    component Position 
        generic(
            timelimit: integer := 10**8 --frecuencia del reloj para que tarde 2 segundos en actualizar
            );
        port(
            move : in std_logic_vector(1 downto 0);
            clk : in std_logic;
            reset: in std_logic;
            pos : out std_logic_vector(1 downto 0)
        );
    end component;
    signal livePos: std_logic_vector (1 downto 0);
--Componente decididor y sus señales
    component Gestor 
        Port ( 
            pet : in STD_LOGIC_VECTOR (3 downto 0);
            pos : in STD_LOGIC_VECTOR (1 downto 0);
            move : in STD_LOGIC_VECTOR (1 downto 0);
            decision: out STD_LOGIC_VECTOR (1 downto 0)
        );
    end component;
    signal deciOut: std_logic_vector(1 downto 0);
--Componente FMS del sensor y sus señales
    component FMS
        Generic(
            esp_dor: integer := 10**8
            );
        Port ( 
            decision : in STD_LOGIC_VECTOR(1 downto 0);
            clk: in STD_LOGIC;
            reset: in std_logic;
            motor: out STD_LOGIC_VECTOR (1 downto 0);
            puerta: out STD_LOGIC
        );
    end component;
    signal motOut: std_logic_vector(1 downto 0);
    signal dorOut: std_logic;
--Componente decoder de displays led
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
    signal eLedOut: std_logic_vector(6 downto 0);
    signal pLedOut: std_logic_vector(6 downto 0);
    signal mLedOut: std_logic_vector(6 downto 0);
 --Componente para el encendido de los displays
    component LedGestor
        port(
            clk: in std_logic;
            elev_led: in std_logic_vector(6 downto 0);
            move_led: in std_logic_vector(6 downto 0);
            place_led: in std_logic_vector(6 downto 0);
            pos: in std_logic_vector(1 downto 0);
            led_on: out std_logic_vector(6 downto 0);
            display_on: out std_logic_vector(7 downto 0)
        );
    end component;
begin
    Sync: for i in 0 to 3 generate
        S: SYNCHRNZR port map(
            clk => clk,
            ASYNC_IN => pulsador(i),
            SYNC_OUT => outSinc(i)
            );
    end generate;
    Edge: for i in 0 to 3 generate
        E: EDGEDTCTR port map(
            clk => clk,
            SYNC_IN => outSinc(i),
            EDGE => outEdge(i)
            );
    end generate;
    Pet: Petition port map(
        inpet => outEdge,
        clk => clk,
        rm => dorOut,
        pos => livePos,
        reset => reset,
        outpet => outPet
        );
    Pos: Position 
        generic map(
            timelimit => clk_frecuency
            )
        port map(
            move => motOut,
            clk => clk,
            reset => reset,
            pos => livePos
        );
    Dec: Gestor port map(
        pet => outPet,
        pos => livePos,
        move => motOut,
        decision => deciOut
        );
    MS: FMS 
        generic map(
            esp_dor => 10**8
            )
        port map(
        decision => deciOut,
        clk => clk,
        reset => reset,
        motor => motOut,
        puerta => dorOut
        );
    LD: LedDecoder port map(
        pos => livePos,
        move => motOut,
        door => dorOut,
        elev_led => eLedOut,
        place_led => pLedOut,
        move_led => mLedOut
        );
    LG: LedGestor port map(
        clk => clk,
        elev_led => eLedOut,
        move_led => mLedOut,
        place_led => pLedOut,
        pos => livePos,
        led_on => disLed,
        display_on => anLed
        );
    upMot <= motOut(1);
    downMot <= motOut(0);
    puerta <= dorOut;
    peticion <= outPet;
end Estructural;

