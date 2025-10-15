use library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity d4_pwm is
   generic (
      F_CLK       : natural := 50_000_000;   -- Klokkefrekvens
      BITS        : natural := 3;            -- Opplosningen til PWM signalet
      T_CLK_PWM   : real    := 60.0e-9       -- PWM klokkeperiode (60 ns)
   );
   port ( 
      clk, rstn   : in  std_logic;
      duty        : in  std_logic_vector(BITS-1 downto 0);
      pwm_out     : out std_logic
   );
end entity d4_pwm;

architecture rtl of d4_pwm is
   -- Regner ut M og konverterer den til en integer
   constant M      : real    := T_CLK_PWM * real(F_CLK);
   constant M_INT  : natural := integer(M);

   signal cnt      : natural := 0;
   signal ena      : std_logic := '0';
   signal var      : natural := 0;

begin
   process(clk)
   begin
      if rising_edge(clk) then
         if rstn = '0' then
            cnt     <= 0;
            ena     <= '0';
            var     <= 0;
            pwm_out <= '0';
         else
            -- Bruker en teller for aa faa lavere klokkefrekvens til PWM
            if cnt >= M_INT then
               cnt <= 0;
               ena <= not ena;
            else
               cnt <= cnt + 1;
            end if;

            -- Bruker en ny teller for å generere PWM signal
            if ena = '1' then
               if var >= (2**BITS - 1) then
                  var <= 0;
               else
                  var <= var + 1;
               end if;

               if var < (to_integer(unsigned(duty)) + 1) then
                  pwm_out <= '1';
               else
                  pwm_out <= '0';
               end if;
            end if;
         end if;
      end if;
   end process;

end architecture rtl;
