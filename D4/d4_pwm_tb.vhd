library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Tom entitet
entity d4_pwm_tb is
end d4_pwm_tb;


-- arkitekturen til testbenken
architecture sim_mod of d4_pwm_tb is 
   constant clk_per : time := 1 ns; 

   component d4_pwm
      port ( 
         clk	: in std_logic;
         rstn	: in std_logic;
         duty	: in std_logic_vector(2 downto 0);
         pwm_out: out std_logic); 
   end component d4_pwm;

   -- DOOT universery
   signal clk		: std_logic;
   signal rstn		: std_logic; 
   signal duty		: std_logic_vector(2 downto 0);
   signal pwm_out	: std_logic;

   begin
      -- Mapper ports i DUV til ports i simuleringen 
      i_d4_pwm: component d4_pwm
         port map(
            clk		=> clk,
   	    rstn	=> rstn,
            duty	=> duty,
            pwm_out	=> pwm_out
            );

      -- Klokke
      p_clk: process is
      begin
         clk <= '0';
         wait for clk_per;
         clk <= '1';
         wait for clk_per;
      end process p_clk;
      
      -- Reset
      p_rstn: process is 
      begin
         rstn <= '0';
         wait for 25 ns; 
         rstn <= '1';
         wait;
      end process p_rstn; 

      p_main: process   
         begin
            -- Hoooly hardcode !
            duty <= std_logic_vector(to_unsigned(0,3));
           
            wait for 120 ns; 
              
            duty <= std_logic_vector(to_unsigned(1,3));

            wait for 120 ns;
       
            duty <= std_logic_vector(to_unsigned(2,3));
 
            wait for 120 ns;

            duty <= std_logic_vector(to_unsigned(3,3));

            wait for 120 ns;

            duty <= std_logic_vector(to_unsigned(4,3));
    
            wait for 120 ns;

            duty <= std_logic_vector(to_unsigned(5,3));

            wait for 120 ns;

            duty <= std_logic_vector(to_unsigned(6,3));

            wait for 120 ns;

            duty <= std_logic_vector(to_unsigned(7,3));

            wait for 120 ns;

            -- avslutter simulering
            assert false report "Testbench finished" severity failure; 
         end process p_main;
end architecture sim_mod;