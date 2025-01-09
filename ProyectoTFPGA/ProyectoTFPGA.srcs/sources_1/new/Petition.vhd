----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.01.2025 18:21:08
-- Design Name: 
-- Module Name: Petition - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

entity Petition is
    Port ( 
        inpet : in std_logic_vector(3 downto 0);
        rm : in std_logic;
        pos : in std_logic_vector (1 downto 0);
        outpet : out std_logic_vector(3 downto 0)             
    );
end Petition;

architecture Behavioral of Petition is

begin
    p0: process(inpet(1))
    begin
        if inpet(1) = '1' then
            outpet(1) <= '1';
        end if;
    end process;
    
    p1: process(inpet(2))
    begin
        if inpet(2) = '1' then
            outpet(2) <= '1';
        end if;
    end process;
    
     p2: process(inpet(2))
    begin
        if inpet(2) = '1' then
            outpet(2) <= '1';
        end if;
    end process;
    
    p3: process(inpet(2))
    begin
        if inpet(3) = '1' then
            outpet(3) <= '1';
        end if;
    end process;
    
    remove: process(rm)
    begin
        if rm = '1' then
            outpet(to_integer(unsigned(pos))) <= '0';
        end if;
    end process;

end Behavioral;

