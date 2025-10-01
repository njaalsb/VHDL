library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Ikke ferdig, forsøk på testbenk for en DFF

entity dff_test_tb is 
end entity

architecture SimMod of dff_test_tb is
    --DUT signals
    signal clk  : std_logic;
    signal d    : std_logic;
    signal q    : std_logic;
    signal q_bar: std_logic;

    begin
    process 
        p_clk: process 
        begin
            clk <= '0';
            wait for 10 ns;
            clk <= '1';
            wait for 10 ns;
        end process p_clk;    
    end process
end architecture