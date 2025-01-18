library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Position is
    generic(
        timelimit: integer := 10**8 --frecuencia del reloj para que tarde 2 segundos en actualizar
        );
    port(
        move : in std_logic_vector(1 downto 0);     -- Entrada que define la dirección del movimiento
        clk : in std_logic;                        -- Señal de reloj
        pos : out std_logic_vector(1 downto 0);    -- Salida que representa la posición actual
        t1: out std_logic                            -- Señal de control para indicar actualización
    );
        );
end Position;

architecture Behavioral of Position is
    signal tup : std_logic := '0';                -- Señal interna para el temporizador de actualización
    type state is (P0, P1, P2, P3);                -- Tipo enumerado para representar los estados
    signal currentpos, nextpos : state := P0;    -- Señales internas para el estado actual y el siguiente
begin
    t1 <= tup;                                    -- Asignación de la señal interna `tup` a la salida `t1`
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
    
    stateregister: process(tup)
    begin
        if tup = '1' then
            currentpos <= nextpos;
        end if;
    end process;
    
    statedecoder: process(move, currentpos)
    begin
        case currentpos is
            when P0 =>
                if move = "00" then
                    nextpos <= P0;
                elsif move = "10" then
                    nextpos <= P1;
                else
                    nextpos <= P0;
                end if;
            when P1 =>
                if move = "00" then 
                    nextpos <= P1;
                elsif move = "10" then
                    nextpos <= P2;
                elsif move = "01" then 
                    nextpos <= P0;
                else
                    nextpos <= P1;
                end if;
            when P2 =>
                if move = "00" then 
                    nextpos <= P2;
                elsif move = "10" then
                    nextpos <= P3;
                elsif move = "01" then 
                    nextpos <= P1;
                else
                    nextpos <= P2;
                end if;
            when P3 =>
                if move = "00" then
                    nextpos <= P3;
                elsif move = "01" then
                    nextpos <= P2;
                else
                    nextpos <= P3;
                end if;
            when others => nextpos <= currentpos;
        end case;
    end process;
    
    outdecoder: process(currentpos)
    begin
        case currentpos is
            when P0 =>
                pos <= "00";
            when P1 =>
                pos <= "01";
            when P2 =>
                pos <= "10";
            when P3 => 
                pos <= "11";
            when others =>
                pos <= "00";
        end case;
     end process;
end Behavioral;
