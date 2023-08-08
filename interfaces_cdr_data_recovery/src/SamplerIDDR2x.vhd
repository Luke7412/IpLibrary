
--------------------------------------------------------------------------------
-- LIBRARIES
--------------------------------------------------------------------------------
library ieee;
   use ieee.std_logic_1164.all;
   use ieee.numeric_std.all;

library UNISIM;
   use UNISIM.vcomponents.all;


--------------------------------------------------------------------------------
-- ENTITY
--------------------------------------------------------------------------------
entity SamplerIddr2x is
   port (
      -- Clock & Reset
      clk       : in  std_logic;
      clk90     : in  std_logic;
      resetn    : in  std_logic;
      in_data   : in  std_logic;
      out_valid : out std_logic := '1';
      out_data  : out std_logic_vector(3 downto 0)
   );
end entity SamplerIddr2x;


--------------------------------------------------------------------------------
-- ARCHITECTURE
--------------------------------------------------------------------------------
architecture rtl of SamplerIddr2x is

   signal Q2, Q1    : std_logic; 
   signal shift_cnt : unsigned(0 downto 0);
   signal shift_reg : std_logic_vector(3 downto 0);

begin

-- "OPPOSITE_EDGE", "SAME_EDGE" or "SAME_EDGE_PIPELINED" 
   IDDR_inst : IDDR
      generic map (
         DDR_CLK_EDGE => "SAME_EDGE_PIPELINED",
         INIT_Q1      => '0',
         INIT_Q2      => '0',
         SRTYPE       => "SYNC"
      )
      port map (
         Q1 => Q1,
         Q2 => Q2,
         C  => clk,
         CE => '1',
         D  => in_data,
         R  => '0',
         S  => '0'
      );


   p_sampling : process(clk, resetn)
   begin
      if resetn = '0' then
         shift_cnt <= (others => '0');
         out_valid <= '0';

      elsif rising_edge(clk) then
         shift_cnt <= shift_cnt + 1;
         shift_reg <= Q2 & Q1 & shift_reg(shift_reg'high downto 2);

         if shift_cnt = 0 then
            out_valid <= '1';
         else
            out_valid <= '0';
         end if;
      end if;
   end process;

   out_data <= shift_reg;

end architecture rtl;