
--------------------------------------------------------------------------------
-- LIBRARIES
--------------------------------------------------------------------------------
library ieee;
   use ieee.std_logic_1164.all;
   use ieee.numeric_std.all;


--------------------------------------------------------------------------------
-- ENTITY
--------------------------------------------------------------------------------
entity Sampler4x is
   port (
      -- Clock & Reset
      clk       : in  std_logic;
      clk90     : in  std_logic;
      resetn    : in  std_logic;
      in_data   : in  std_logic;
      out_valid : out std_logic := '1';
      out_data  : out std_logic_vector(3 downto 0)
   );
end entity Sampler4x;


--------------------------------------------------------------------------------
-- ARCHITECTURE
--------------------------------------------------------------------------------
architecture rtl of Sampler4x is

   signal shift_cnt : unsigned(1 downto 0);
   signal shift_reg : std_logic_vector(3 downto 0);

begin
   
   p_sampling : process(clk)
   begin
      if resetn = '0' then
         shift_cnt <= (others => '1');
         out_valid <= '0';

      elsif rising_edge(clk) then
         shift_cnt <= shift_cnt - 1;
         shift_reg <= in_data & shift_reg(shift_reg'high downto 1);

         if shift_cnt = 0 then
            out_valid <= '1';
         else
            out_valid <= '0';
         end if;
      end if;
   end process;

   out_data <= shift_reg;

end architecture rtl;