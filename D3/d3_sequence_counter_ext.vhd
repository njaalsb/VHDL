-- Versjon 2 av den originale filen, men med en ekstra arkitektur som bruker 
-- et skifteregister fremfor en tilstandsmaskin

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity d3_sequence_detector is 

   port (
      clk, rst, data: in std_logic;
      seq_found: out std_logic);
end entity d3_sequence_detector;

architecture rtl of d3_sequence_detector is
   -- Oppretter en egendefinert type for hver state
   type state_type is (ZERO, FIRST, SECOND, THIRD, FOURTH);
   signal state : state_type := ZERO;
   begin 
      p1: process(clk)
      begin
         -- Asynkron reset
         if rst = '1' then
            state <= ZERO;
            seq_found <= '0';
         elsif rising_edge(clk) then
            seq_found <= '0';
            -- cases
            case state is
            -- Vi starter i null casen, vi går bare tilbake hit om vi får "00"
               when ZERO =>
                  if data = '1' then
                     state <= FIRST;
                  end if;              
               when FIRST =>
                      -- Vi har "1", om vi får '0' går vi videre, ellers blir vi i casen
                      if data = '0' then
                         state <= SECOND;
                      else 
                         state <= FIRST;
                      end if;
               when SECOND =>
               -- Her har vi "10", går videre om vi får "1"
               -- Viss vi får "0" går vi tilbake til case ZERO
                  if data = '1' then
                     state <= THIRD;
                  else 
                     state <= ZERO;
                 end if;
               when THIRD =>
                  -- Her har vi "101", får vi 1 går vi videre og setter seq_num = 1
                  -- Viss vi får 0 går vi tilbake til case SECOND siden vi har "10" 
                  if data = '1' then
                     seq_found <= '1';
                     state <= FOURTH;
                  else
                     state <= SECOND;
                  end if;
               when FOURTH =>
                  -- Her har vi den ferdige sekvensen, viss vi får 1 går vi tilbake til first
                  -- Viss vi får 0 går vi til case SECOND, ettersom vi har "10" 
                  if data = '1' then 
                     seq_found <= '1';
                     state <= FIRST;
                  else 
                     state <= SECOND;
                  end if;
            end case;                                   
         end if;
      end process;	
end architecture rtl; 


-- Alternativ architecture for d3_sequence_detector 
architecture rtl2 of d3_sequence_detector is
   signal skift_reg : std_logic_vector(3 downto 0) := (others => '0');
begin
   p2: process(clk)
   begin 
      -- sjekker reset uavhengig utenfor klokka, for asynkron reset 
      if rst = '1' then
         skift_reg <= (others => '0');
         seq_found <= '0';
      elsif rising_edge(clk) then
         -- skifter inn et nytt bit
         skift_reg <= skift_reg(2 downto 0) & data;

         -- Setter seq_num til 0
         seq_found <= '0';
         -- Sjekker som skifteregisteret inneholder sekvensen
         if skift_reg = "1011" then 
            seq_found <= '1';
         end if;
      end if;
   end process;
end architecture rtl2;
