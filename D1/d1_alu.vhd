library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity d1_alu is
   generic (
      NUM_BITS: integer := 4);
   port (
      a, b:    in  std_logic_vector(NUM_BITS-1 downto 0);
      op_code: in  std_logic_vector(3 downto 0);
      result:  out std_logic_vector(NUM_BITS-1 downto 0)
   );
end entity d1_alu;

architecture rtl of d1_alu is
begin 
   result <= not a when op_code = "0000" else
             not b when op_code = "0001" else
             a and b when op_code = "0010" else
             a or b when op_code = "0011" else
             a nand b when op_code = "0100" else
             a nor b when op_code = "0101" else
             a xor b when op_code = "0110" else
             a xnor b when op_code = "0111" else
             a when op_code = "1000" else
             b when op_code = "1001" else
             std_logic_vector(unsigned(a) + 1) when op_code = "1010" else
             std_logic_vector(unsigned(b) + 1) when op_code = "1011" else
             std_logic_vector(unsigned(a) - 1) when op_code = "1100" else
             std_logic_vector(unsigned(b) - 1)when op_code = "1101" else
             std_logic_vector(unsigned(a) + unsigned(b)) when op_code = "1110" else
             "0000";
end architecture;