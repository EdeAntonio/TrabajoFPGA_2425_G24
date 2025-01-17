library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Position is
    generic(
        timelimit: integer := 10**8 --frecuencia del reloj para que tarde 2 segundos en actualizar
        );
    port(
        move : in std_logic_vector(1 downto 0);
        clk : in std_logic;
        pos : out std_logic_vector(1 downto 0);
        t1: out std_logic
        );
end Position;

architecture Behavioral of Position is
    signal tup : std_logic := '0';
    type state is (P0, P1, P2, P3);
    signal currentpos, nextpos : state := P0;
begin
    t1 <= tup;
    timecounter: process(clk)
        variable timecount : integer := 0;
    begin
        if rising_edge(clk) then
            timecount := timecount + 1;
            if timecount = timelimit then
                tup <= '0';
            end if;
            if timecount = 2*timelimit then
                timecount := 0;
                tup <= '1';
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
