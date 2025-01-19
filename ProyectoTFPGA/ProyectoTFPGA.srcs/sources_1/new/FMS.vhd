library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FMS is
    Generic(
        esp_dor: integer := 10**8 --Espera en ciclos
    );
    Port ( 
        decision : in STD_LOGIC_VECTOR(1 downto 0);
        clk: in STD_LOGIC;
        reset: in std_logic;
        motor: out STD_LOGIC_VECTOR (1 downto 0);
        puerta: out STD_LOGIC
    );
end FMS;

architecture Behavioral of FMS is
    type state is (ST, GU, GD, OD);
    signal espactiva: std_logic := '0';
    signal cstate, nstate : state := ST;
    signal counter: integer := 0;
begin
    stateregister: process(clk)
    begin
        if rising_edge(clk) then
            if espactiva = '1' then
                counter <= counter +1;
                if counter >= esp_dor then
                    counter <= 0;
                    cstate <= nstate;
                end if; 
            else
                cstate <= nstate;
            end if;
                
            if reset = '0' then
                cstate <= ST;
                counter <= 0;
            end if;
        end if;
    end process;
    
    statedecoder: process(decision, cstate)
    begin
        case cstate is
            when ST =>
                if decision = "00" then
                    nstate <= ST;
                elsif decision = "10" then
                    nstate <= GD;
                elsif decision = "11" then
                    nstate <= GU;
                elsif decision = "01" then
                    nstate <= OD;
                else
                    nstate <= ST;
                end if;
            when GU =>
                if decision = "11" then
                    nstate <= GU;
                 else 
                    nstate <= ST;
                end if;
            when GD =>
                if decision = "10" then
                    nstate <= GU;
                 else 
                    nstate <= ST;
                end if;
            when OD =>
                if decision = "01" then
                    nstate <= OD;
                else
                    nstate <= ST;
                end if;
            when others => nstate <= cstate;
        end case;
    end process;
    
    outdecoder: process(cstate)
    begin
        case cstate is
            when ST =>
                motor <= "00";
                puerta <= '0';
            when GU =>
                motor <= "10";
                puerta <= '0';
            when GD =>
                motor <= "01";
                puerta <= '0';
            when OD => 
                motor <= "00";
                puerta <= '1';
            when others =>
                motor <= "00";
                puerta <= '0';
        end case;
     end process;
     acti_esp: process(cstate, counter)
     begin
        if reset = '0' then
            espactiva <= '0';
        end if;
        if cstate = ST OR cstate = OD then
            espactiva <= '1';
        else
            espactiva <= '0';
        end if;
    end process;
end Behavioral;