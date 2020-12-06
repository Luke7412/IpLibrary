

--------------------------------------------------------------------------------
-- LIBRARIES
--------------------------------------------------------------------------------
library IEEE;
   use IEEE.STD_LOGIC_1164.ALL;
   use IEEE.numeric_std.all;


--------------------------------------------------------------------------------
-- ENTITY
--------------------------------------------------------------------------------
entity pulse is
   generic (
      ACLK_FREQ       : natural := 100;    -- in MHz
      TDATA_NUM_BYTES : natural := 1
   );
   port (
      AClk         : in  std_logic;
      AResetn      : in  std_logic;
      Pulse_TValid : out std_logic;
      Pulse_TData  : out std_logic_vector(8*TDATA_NUM_BYTES-1 downto 0)
   );
end pulse;


--------------------------------------------------------------------------------
-- ARCHITECTURE
--------------------------------------------------------------------------------
architecture rtl of pulse is

   signal Div_cnt   : natural range 0 to ACLK_FREQ-1;
   signal Pulse_cnt : unsigned(Pulse_TData'range);

begin

   process(AClk, AResetn)
   begin
      if AResetn = '0' then
         Pulse_TValid <= '0';
         Div_cnt      <= ACLK_FREQ-1;
         Pulse_cnt    <= (others => '0');

      elsif rising_edge(AClk) then
         if Div_cnt = 0 then
            Div_cnt      <= ACLK_FREQ-1;
            Pulse_cnt    <= Pulse_cnt + 1;
            Pulse_TValid <= '1';
            Pulse_TData  <= std_logic_vector(Pulse_cnt);
         else
            Div_cnt      <= Div_cnt - 1;
            Pulse_TValid <= '0';
         end if;
      end if;
   end process;

end rtl;
