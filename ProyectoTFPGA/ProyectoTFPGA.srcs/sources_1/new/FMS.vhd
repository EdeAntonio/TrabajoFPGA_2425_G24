library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FMS is
    Generic(
        esp_dor: integer := 10**8 --Espera en ciclos
    );
    Port ( 
        decision : in STD_LOGIC_VECTOR(1 downto 0); -- Entrada de decisión
        clk: in STD_LOGIC; -- Señal de reloj
        reset: in std_logic; -- Señal reset
        motor: out STD_LOGIC_VECTOR (1 downto 0); -- Salida para el motor
        puerta: out STD_LOGIC -- Salida para la puerta
    );
end FMS;

architecture Behavioral of FMS is
     -- Definición de los estados
    type state is (ST, GU, GD, OD);
    signal espactiva: std_logic := '0'; -- Señal para activar la espera
    signal cstate, nstate : state := ST; -- Estado actual y siguiente
    signal counter: integer := 0; -- Contador para la espera
begin
    -- Proceso para el registro de estado
    stateregister: process(clk)
    begin
        if rising_edge(clk) then
            if espactiva = '1' then
                counter <= counter +1; -- Incrementa el contador
                if counter >= esp_dor then
                    counter <= 0; -- Reinicia el contador
                    cstate <= nstate; -- Actualiza el estado actual
                end if; 
            else
                cstate <= nstate; -- Actualiza el estado actual
            end if;
                
            if reset = '0' then
                cstate <= ST; -- Reinicia al estado inicial
                counter <= 0; -- Reinicia el contador
            end if;
        end if;
    end process;
     -- Proceso para decodificar el estado
    statedecoder: process(decision, cstate)
    begin
        case cstate is
            when ST =>
                if decision = "00" then
                    nstate <= ST;  -- Mantiene el estado
                elsif decision = "10" then
                    nstate <= GD;  -- Cambia al estado GD
                elsif decision = "11" then
                    nstate <= GU;  -- Cambia al estado GU
                elsif decision = "01" then
                    nstate <= OD;  -- Cambia al estado OD
                else
                    nstate <= ST; -- Mantiene el estado
                end if;
            when GU =>
                if decision = "11" then
                    nstate <= GU; -- Mantiene el estado
                 else 
                    nstate <= ST; -- Cambia al estado ST
                end if;
            when GD =>
                if decision = "10" then
                    nstate <= GU; -- Cambia al estado GU
                 else 
                    nstate <= ST; -- Cambia al estado ST
                end if;
            when OD =>
                if decision = "01" then
                    nstate <= OD; -- Mantiene el estado
                else
                    nstate <= ST; -- Cambia al estado ST
                end if;
            when others => nstate <= cstate;
        end case;
    end process;
       -- Proceso para decodificar las salidas
    outdecoder: process(cstate)
    begin
        case cstate is
            when ST =>
                motor <= "00"; -- Motor apagado
                puerta <= '0'; -- Puerta cerrada
            when GU =>
                motor <= "10"; -- Motor Subiendo
                puerta <= '0'; -- Puerta cerrada
            when GD =>
                motor <= "01"; -- Motor Bajando 
                puerta <= '0'; -- Puerta cerrada
            when OD => 
                motor <= "00"; -- Motor apagado
                puerta <= '1'; -- Puerta abierta
            when others =>
                motor <= "00"; -- Motor apagado
                puerta <= '0'; -- Puerta cerrada
        end case;
     end process;
    -- Proceso para activar la espera
     acti_esp: process(cstate, reset)
     begin
        if reset = '0' then
            espactiva <= '0'; -- Desactiva la espera
        end if;
        if cstate = ST OR cstate = OD then
            espactiva <= '1'; -- Activa la espera
        else
            espactiva <= '0'; -- Desactiva la espera
        end if;
    end process;
end Behavioral;
