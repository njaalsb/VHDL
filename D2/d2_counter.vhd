library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity d2_counter is
    -- Oppretter to variabler, disse er heltall
    generic (
        F_CNT    : natural := 50_000_000/10;     
        NUM_BITS : natural := 10);   
    port (
        -- Setter input og output ports
        clk, rst, ena, cnt_sel: in  std_logic;
        count: out std_logic_vector(NUM_BITS-1 downto 0)
        );
end entity d2_counter;

architecture rtl of d2_counter is
   -- Lager signalet lfsr_reg, 10-bits shift-register som lagrer startverdien '0000000001'
   signal lfsr_reg : std_logic_vector(NUM_BITS-1 downto 0) := (others => '0'); -- Initial seed
	signal k: natural := 0;
begin
   p1: process(clk)
      variable i: natural range 0 to (2**NUM_BITS-1);
   begin
      -- Sjekker rst forst ettersom den skal ha hoyest prioritet
      if rst = '0' then
         i := 0;
         lfsr_reg <= (others => '0');
         lfsr_reg(0) <= '1';
		 k <= 0;
      elsif rising_edge(clk) then
		   -- sjekker at enable er satt til 1
		   if ena = '1' then
              -- sjekker om k er lik 5 millioner, får å generere ny verdi
              -- hvert 0.1 sekund
			   if k = F_CNT-1 then
				   k <= 0;
               -- cnt_sel bestemmer hvilken måte vi skal telle på
               if cnt_sel = '0' then              
                  i := i + 1;               
               elsif cnt_sel = '1' then
                  -- LFSR'en har max lengde på x^10 + x^7 + 1
                  -- Derfor shifter vi de 9 nederste bitene et bit til venstre
                  -- Setter det første bittet lik bit 9 xor bit 6
                  lfsr_reg(NUM_BITS-1 downto 1) <= lfsr_reg(NUM_BITS-2 downto 0); 
                  lfsr_reg(0) <= lfsr_reg(9) xor lfsr_reg(6);
				   end if;
				else
				   k <= k +1;
            end if; 
         end if;
		end if;
      -- count gir ut resultatet av enten LFSR eller vanlig telling, avhengig av cnt_sel
      case cnt_sel is
		   when '0' =>
			   count <= std_logic_vector(to_unsigned(i, NUM_BITS));
			when '1' => 
			   count <= lfsr_reg;
	   end case;
   end process;
end architecture rtl;