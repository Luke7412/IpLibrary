
--------------------------------------------------------------------------------
-- LIBRARIES
--------------------------------------------------------------------------------
library ieee;
   use ieee.std_logic_1164.all;
   use ieee.numeric_std.all;


--------------------------------------------------------------------------------
-- ENTITY
--------------------------------------------------------------------------------
entity Sampler2x is
   port (
      -- Clock & Reset
      clk       : in  std_logic;
      clk90     : in  std_logic;
      resetn    : in  std_logic;
      in_data   : in  std_logic;
      out_valid : out std_logic := '1';
      out_data  : out std_logic_vector(3 downto 0)
   );
end entity Sampler2x;


--------------------------------------------------------------------------------
-- ARCHITECTURE
--------------------------------------------------------------------------------
architecture rtl of Sampler2x is

   signal shift_cnt     : unsigned(0 downto 0);
   signal shift_reg_neg : std_logic_vector(1 downto 0);
   signal shift_reg_pos : std_logic_vector(1 downto 0);

begin
   
   p_sampling_neg : process(clk)
   begin
      if falling_edge(clk) then
         shift_reg_neg <= in_data & shift_reg_neg(shift_reg_neg'high downto 1);
      end if;
   end process;


   p_sampling_pos : process(clk, resetn)
   begin
      if resetn = '0' then
         shift_cnt <= (others => '1');
         out_valid <= '0';

      elsif rising_edge(clk) then
         shift_cnt     <= shift_cnt - 1;
         shift_reg_pos <= in_data & shift_reg_pos(shift_reg_pos'high downto 1);

         if shift_cnt = 0 then
            out_valid <= '1';
            out_data  <=  shift_reg_neg(1) & shift_reg_pos(1) & shift_reg_neg(0) & shift_reg_pos(0);
         else
            out_valid <= '0';
         end if;
      end if;
   end process;


end architecture rtl;