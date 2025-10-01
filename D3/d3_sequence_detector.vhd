library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity d3_sequence_detector is 

   port (
      clk, rst, data: in std_logic;
      seq_found: out std_logic);
end entity d3_sequence_detector;

architecture rtl of d3_sequence_detector is
   type state_type is (ZERO, FIRST, SECOND, THIRD, FOURTH);
   signal state : state_type := ZERO;
   begin 
      p1: process(clk)
      begin
         if rst = '1' then
            state <= ZERO;
            seq_found <= '0';
         elsif rising_edge(clk) then
            seq_found <= '0';
            case state is
               when ZERO =>
                  if data = '1' then
                     state <= FIRST;
                  end if;              
               when FIRST =>
                      if data = '0' then
                         state <= SECOND;
                      else 
                         state <= FIRST;
                      end if;
               when SECOND =>
               -- 10
                  if data = '1' then
                     state <= THIRD;
                  else 
                     state <= ZERO;
                 end if;
               when THIRD => 
                  if data = '1' then
                     --101
                     seq_found <= '1';
                     state <= FOURTH;
                  else
                     state <= SECOND;
                  end if;
               when FOURTH => 
                  if data = '1' then 
                     -- 1011
                     seq_found <= '1';
                     state <= FIRST;
                  else 
                     state <= SECOND;
                  end if;
            end case;                                   
         end if;
      end process;	
end architecture rtl; 
