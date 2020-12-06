

--------------------------------------------------------------------------------
-- LIBRARIES
--------------------------------------------------------------------------------
library IEEE;
   use IEEE.STD_LOGIC_1164.ALL;


--------------------------------------------------------------------------------
-- ENTITY
--------------------------------------------------------------------------------
entity pulse_tb is
end pulse_tb;


--------------------------------------------------------------------------------
-- ARCHITECTURE
--------------------------------------------------------------------------------
architecture tb of pulse_tb is

   signal AClk           : std_logic := '1';
   signal AResetn        : std_logic;
   signal Pulse          : std_logic;
   
   constant c_PERIODACLK : time    := 5 ns;
   constant CLK_FREQ     : natural := 200;

begin
   
   -----------------------------------------------------------------------------
   process
   begin
      wait for c_PERIODACLK;
      AClk <= not AClk;
   end process;


   -----------------------------------------------------------------------------
   DUT : entity work.pulse
      generic map(
         CLK_FREQ => CLK_FREQ
      )
      port map(
         AClk    => AClk   ,
         AResetn => AResetn,
         Pulse   => Pulse
      );

end tb;
