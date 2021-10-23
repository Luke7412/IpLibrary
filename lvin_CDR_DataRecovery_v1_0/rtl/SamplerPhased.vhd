
--------------------------------------------------------------------------------
-- LIBRARIES
--------------------------------------------------------------------------------
library ieee;
   use ieee.std_logic_1164.all;
   use ieee.numeric_std.all;


--------------------------------------------------------------------------------
-- ENTITY
--------------------------------------------------------------------------------
entity SamplerPhased is
   port (
      -- Clock & Reset
      clk       : in  std_logic;
      clk90     : in  std_logic;
      resetn    : in  std_logic;
      in_data   : in  std_logic;
      out_valid : out std_logic := '1';
      out_data  : out std_logic_vector(3 downto 0)
   );
end entity SamplerPhased;


--------------------------------------------------------------------------------
-- ARCHITECTURE
--------------------------------------------------------------------------------
architecture rtl of SamplerPhased is

   signal AZ, BZ, CZ, DZ : std_logic_vector(3 downto 0);

begin
   
   p_sampling_clk000 : process(clk)
   begin
      if rising_edge(clk) then
         AZ(0) <= in_data;
         AZ(1) <= AZ(0);
         AZ(2) <= AZ(1);
         AZ(3) <= AZ(2);

         BZ(1) <= BZ(0);
         BZ(2) <= BZ(1);
         BZ(3) <= BZ(2);

         CZ(2) <= CZ(1);
         CZ(3) <= CZ(2);

         DZ(3) <= DZ(2);
      end if;
   end process;


   p_sampling_clk090 : process(clk90)
   begin
      if rising_edge(clk90) then
         BZ(0) <= in_data;
         CZ(1) <= CZ(0);
         DZ(2) <= DZ(1);
      end if;
   end process;


   p_sampling_clk180 : process(clk)
   begin
      if falling_edge(clk) then
         CZ(0) <= in_data;
         DZ(1) <= DZ(0);
      end if;
   end process;


   p_sampling_clk270 : process(clk90)
   begin
      if falling_edge(clk90) then
         DZ(0) <= in_data;
      end if;
   end process;


   out_valid <= '1';
   out_data  <= DZ(3) & CZ(3) & BZ(3) & AZ(3);


end architecture rtl;