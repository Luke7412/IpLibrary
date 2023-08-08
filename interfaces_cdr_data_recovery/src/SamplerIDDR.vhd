
--------------------------------------------------------------------------------
-- LIBRARIES
--------------------------------------------------------------------------------
library ieee;
   use ieee.std_logic_1164.all;
   use ieee.numeric_std.all;

Library UNISIM;
   use UNISIM.vcomponents.all;


--------------------------------------------------------------------------------
-- ENTITY
--------------------------------------------------------------------------------
entity SamplerIddr is
   port (
      -- Clock & Reset
      clk       : in  std_logic;
      clk90     : in  std_logic;
      resetn    : in  std_logic;
      in_data   : in  std_logic;
      out_valid : out std_logic := '1';
      out_data  : out std_logic_vector(3 downto 0)
   );
end entity SamplerIddr;


--------------------------------------------------------------------------------
-- ARCHITECTURE
--------------------------------------------------------------------------------
architecture rtl of SamplerIddr is

   signal AZ, BZ, CZ, DZ : std_logic_vector(1 downto 0);

begin

   -- "OPPOSITE_EDGE", "SAME_EDGE" or "SAME_EDGE_PIPELINED" 
   i_IDDR_clk00 : IDDR
      generic map (
         DDR_CLK_EDGE => "SAME_EDGE_PIPELINED",
         INIT_Q1      => '0',
         INIT_Q2      => '0',
         SRTYPE       => "SYNC"
      )
      port map (
         Q1 => AZ(0),
         Q2 => CZ(0),
         C  => clk,
         CE => '1',
         D  => in_data,
         R  => '0',
         S  => '0'
      );

   i_IDDR_clk90 : IDDR
      generic map (
         DDR_CLK_EDGE => "SAME_EDGE_PIPELINED",
         INIT_Q1      => '0',
         INIT_Q2      => '0',
         SRTYPE       => "SYNC"
      )
      port map (
         Q1 => BZ(0),
         Q2 => DZ(0),
         C  => clk90,
         CE => '1',
         D  => in_data,
         R  => '0',
         S  => '0'
      );


   p_sampling : process(clk)
   begin
      if rising_edge(clk) then
         out_data(0) <= AZ(0);
         out_data(1) <= BZ(0);
         out_data(2) <= CZ(0);
         out_data(3) <= DZ(0);
      end if;
   end process;
   
   out_valid <= '1';


end architecture rtl;