library ieee;
use ieee.std_logic_1164.all;

entity tb_Position is
end tb_Position;

architecture tb of tb_Position is

    component Position
        generic(
            timelimit: integer                                    -- Parámetro genérico para temporización
            );
        port (
            move     : in std_logic_vector (1 downto 0);          -- Entrada para indicar acción de movimiento (00: quieto; 10: subir; 01: bajar)
            clk      : in std_logic;                              -- Señal de reloj
            reset    : in std_logic;                              -- Señal de reseteo
            pos : out std_logic_vector (1 downto 0)              -- Salida que indica la planta actual
        );
    end component;

    signal move     : std_logic_vector (1 downto 0):= "00";        -- Señal de movimiento inicializada en "00" para que no se mueva
    signal clk      : std_logic := '0';                            -- Señal de reloj inicializada en '0'
    signal pos : std_logic_vector (1 downto 0) := "00";            -- Salida que almacena la posición se iniciliza en "00" para ubicarse en la planta baja
    signal reset    : std_logic := '1';                            -- Se inicia el reseteo a 1 para reiniciar todo

    constant TbPeriod : time := 5 ns;                             -- Período del reloj de prueba
    signal TbClock : std_logic := '0';                            -- Señal interna para generar el reloj
    
    type vtest is record     -- Definición de un tipo de registro para los casos de prueba
        movesim: std_logic_vector (1 downto 0);                    -- Movimiento esperado en cada paso
        possim: std_logic_vector (1 downto 0);                    -- Salida esperada (posición)
    end record;
    
    type vtest_vector is array (natural RANGE <>) of vtest;        -- Definición de un array de casos de prueba utilizando el tipo `vtest`
    
    constant test: vtest_vector := (
        (movesim => "00", possim => "00"),       -- Mantenerse en la planta baja
        (movesim => "10", possim => "01"),       -- Subir a la planta 1
        (movesim => "10", possim => "10"),       -- Subir a la planta 2
        (movesim => "10", possim => "11"),       -- Subir a la planta 3
        (movesim => "10", possim => "11"),       -- Intentar subir más allá de la planta 3 (debe quedarse en P3)
        (movesim => "00", possim => "11"),       -- Mantenerse en la planta 3
        (movesim => "01", possim => "10"),       -- Bajar a la planta 2
        (movesim => "00", possim => "10"),       -- Mantenerse en la planta 2
        (movesim => "01", possim => "01"),       -- Bajar a la planta 1
        (movesim => "00", possim => "01"),       -- Mantenerse en la planta 1
        (movesim => "11", possim => "01")        -- Comando inválido, mantener planta actual
        );
begin

    dut : Position
    generic map(
        timelimit => 1                            -- Tiempo mínimo para las pruebas
    )
    port map (
            move => move,                         -- Conexión de la señal de movimiento
            clk  => clk,                          -- Conexión de la señal de reloj
            pos  => pos,                          -- Conexión de la señal de posición
           reset => reset,                       -- Conexión de la señal de reset
    );

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2;      -- Alterna el estado de `TbClock` para simular el reloj       
    clk <= TbClock;                               -- Conexión del reloj interno a la señal `clk`

    stimuli : process
    begin
        for i in 0 to test'HIGH loop            -- Pasar por todos los casos de prueba definidos en `test`
            move <= test(i).movesim;            -- Aplicar el movimiento correspondiente
             wait for 2*tbperiod;

            assert pos = test(i).possim
                report "Error transición"        -- Comprobar que la posición coincide con el valor esperado
                severity failure;
        end loop;
          reset <= '0';                          -- Se establece el reseteo como falso
            wait for tbperiod;
            assert pos = "00"
                report "fallo reseteo"
                severity failure;

            assert false
                report ("Fin prueba")            -- Al finalizar todos los casos de prueba, generar un mensaje de fin
                severity failure;
    end process;

end tb;
