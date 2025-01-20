library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Position is
    generic(
        timelimit: integer := 10**8 --frecuencia del reloj para que tarde 2 segundos en actualizar
        );
    port(
        move : in std_logic_vector(1 downto 0);     -- Entrada que define la dirección del movimiento
        clk : in std_logic;                        -- Señal de reloj
        reset: in std_logic;                       -- Señal de reseteo
        pos : out std_logic_vector(1 downto 0)     -- Salida que representa la posición actual
        );
end Position;

architecture Behavioral of Position is
    signal tup : std_logic := '0';                -- Señal interna para el temporizador de actualización
    type state is (P0, P1, P2, P3);                -- Se representan los estados de las plantas (P0 = planta 0; P1 = planta 1; P2 = planta 2; P3 = planta 3)
    signal currentpos, nextpos : state := P0;    -- Señales internas para el estado actual y el siguiente
begin       
    timecounter: process(clk)                     -- Proceso encargado de contar los ciclos de reloj para generar la señal `tup`
        variable timecount : integer := 0;        -- Variable interna para contar el tiempo
    begin
        if rising_edge(clk) then                -- Se ejecuta en el flanco de subida del reloj
            timecount := timecount + 1;           -- Incrementa el contador de tiempo
            if timecount = timelimit then        
                tup <= '0';                        -- Señal `tup` en bajo después del primer intervalo
            end if;
            if timecount = 2*timelimit then
                timecount := 0;                    -- Reinicia el contador después de 2 intervalos
                tup <= '1';                        -- Señal `tup` en alto para indicar actualización
            end if;
        end if;
    end process;
    
    stateregister: process(tup,reset)                     -- Proceso para actualizar el estado actual según la señal `tup`
    begin
         if rising_edge(tup) then                         -- Sincronizamos con la señal temporizada
            currentpos <= nextpos;
        end if;
        if reset = '0' then                             --Se añade reset y vuelve a la posicion 0 (inicial)
            currentpos <= P0;
        end if;
    end process;
    
    statedecoder: process(move, currentpos)           -- Proceso que decide la planta siguiente según la planta actual y la entrada `move` (00 = quieto; 10 = subir; 01= bajar)
    begin
        case currentpos is
            when P0 =>                                -- Si el ascensor está en la planta baja: 
                if move = "00" then                        --Si no se realiza ningún movimiento se mantiene en la planta 0
                    nextpos <= P0;                         
                elsif move = "10" then                     --Si se realiza un movimeinto ascendente el ascensor sube a la planta 1
                    nextpos <= P1;                    
                else
                    nextpos <= P0;                         -- En cualquier otro caso el ascensor permanece en la planta en la que está
                end if;
            when P1 =>                                -- Si el ascensor está en la planta 1: 
                if move = "00" then                         --Si no se realiza ningún movimiento se mantiene en la planta 1
                    nextpos <= P1;
                elsif move = "10" then                      --Si se realiza un movimeinto ascendente el ascensor sube a la planta 2
                    nextpos <= P2;
                elsif move = "01" then                      --Si se realiza un movimeinto descendente el ascensor baja a la planta 0
                    nextpos <= P0;
                else                                        -- En cualquier otro caso el ascensor permanece en la planta en la que está
                    nextpos <= P1;
                end if;
            when P2 =>                                 -- Si el ascensor está en la planta 2: 
                if move = "00" then                         --Si no se realiza ningún movimiento se mantiene en la planta 2
                    nextpos <= P2;
                elsif move = "10" then                      --Si se realiza un movimeinto ascendente el ascensor sube a la planta 3
                    nextpos <= P3;
                elsif move = "01" then                       --Si se realiza un movimeinto descendente el ascensor baja a la planta 1
                    nextpos <= P1;
                else                                          -- En cualquier otro caso el ascensor permanece en la planta en la que está
                    nextpos <= P2;
                end if;
            when P3 =>                                -- Si el ascensor está en la planta 3: 
                if move = "00" then                           --Si no se realiza ningún movimiento se mantiene en la planta 3
                    nextpos <= P3;
                elsif move = "01" then                        --Si se realiza un movimeinto descendente el ascensor baja a la planta 2
                    nextpos <= P2;
                else                                          -- En cualquier otro caso el ascensor permanece en la planta en la que está
                    nextpos <= P3;
                end if;
            when others => nextpos <= currentpos;            -- Opción por defecto en caso de error (se mantiene en la posición actual si hay un fallo)
        end case;
    end process;
    
    outdecoder: process(currentpos)                            -- Proceso para decodificar el estado actual (planta) y asignarlo a la salida `pos`
    begin
        case currentpos is
            when P0 =>
                pos <= "00";                            -- Planta baja representada como "00"
            when P1 =>
                pos <= "01";                            -- Planta 1 representada como "01"
            when P2 =>
                pos <= "10";                            -- Planta 2 representada como "10"
            when P3 => 
                pos <= "11";                            -- Planta 3 representada como "11"
            when others =>
                pos <= "00";                            -- Valor por defecto: planta baja
        end case;
     end process;
end Behavioral;
