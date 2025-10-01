library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Tom entitet
entity something_tb.vhd is
end endity something_tb.vhd;

architecture SimMod of something_tb.vhd is
   constant c_ClkPer : time := 10 ns;      -- 50 MHz
      -- DUT signal
      clk	: in std_logic;
      rst	: in std_logic
begin
   clk_proc: process is
   begin
      clk <= '0';
      wait for c_ClkPer;
      clk <= '1';
      wait for c_ClkPer;
   end process CLK_proc; 

   rst_proc: process is 
   begin
      rst <= '0';
      wait for 15 ns;
      rst <= '1'
      wait;
   end process rst_proc;

end architecture; 
      