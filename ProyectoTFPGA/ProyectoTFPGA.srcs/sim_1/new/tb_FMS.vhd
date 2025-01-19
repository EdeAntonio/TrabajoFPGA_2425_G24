library ieee;
use ieee.std_logic_1164.all;

entity tb_FMS is
end tb_FMS;

architecture tb of tb_FMS is

    component FMS
    Generic(
        esp_dor: integer := 10**8
    );
    Port ( 
        decision : in STD_LOGIC_VECTOR(1 downto 0);
        clk: in std_logic;
        reset: in std_logic;
        motor: out STD_LOGIC_VECTOR (1 downto 0);
        puerta: out STD_LOGIC
    );
    end component;

    signal decision     : std_logic_vector (1 downto 0):= "00";
    signal clk: std_logic := '0';
    signal reset: std_logic := '1';
    signal motor : std_logic_vector (1 downto 0) := "00";
    signal puerta       : std_logic := '0';

    constant TbPeriod : time := 10 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    
    type vtest is record
        decisim: std_logic_vector (1 downto 0);
        motsim: std_logic_vector (1 downto 0);
        dorsim: std_logic;
    end record;
    
    type vtest_vector is array (natural RANGE <>) of vtest;
    
    constant test: vtest_vector := (
        (decisim => "00", motsim => "00", dorsim => '0'),
        (decisim => "11", motsim => "10", dorsim => '0'),
        (decisim => "11", motsim => "10", dorsim => '0'),
        (decisim => "10", motsim => "00", dorsim => '0'),
        (decisim => "10", motsim => "00", dorsim => '0'),
        (decisim => "10", motsim => "01", dorsim => '0'),
        (decisim => "01", motsim => "00", dorsim => '0'),
        (decisim => "01", motsim => "00", dorsim => '0'),
        (decisim => "01", motsim => "00", dorsim => '1'),
        (decisim => "11", motsim => "00", dorsim => '1'),
        (decisim => "11", motsim => "00", dorsim => '0'),
        (decisim => "11", motsim => "00", dorsim => '0'),
        (decisim => "11", motsim => "10", dorsim => '0'),
        (decisim => "11", motsim => "10", dorsim => '0')
        );
begin

    dut : FMS
    generic map (
        esp_dor => 1
    )  
    port map (
        decision => decision,
        clk => clk,
        reset => reset,
        motor => motor,
        puerta => puerta
    );

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2;

    
    clk <= TbClock;

    stimuli : process
    begin
        for i in 0 to test'HIGH loop
            decision <= test(i).decisim;
            wait until clk = '1';
            wait for 7.5ns;
            assert motor = test(i).motsim
                report "Error motot"
                severity Failure;
            assert puerta = test(i).dorsim
                report "Error puerta"
                severity Failure;
        end loop;
            reset <= '0';
            wait for TbPeriod;
            reset <= '1';
            assert motor = "00" and puerta = '0'
                report "Fallo reseteo"
                severity failure;
            assert false
                report ("Fin prueba")
                severity failure;
    end process;

end tb;