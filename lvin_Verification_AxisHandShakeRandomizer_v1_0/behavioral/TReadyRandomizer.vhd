--------------------------------------------------------------------------------
-- Project Name   : IpLibrary
-- Design Name    : AxisHandShakeRandomizer
-- File Name      : TReadyRandomizer.vhd
--------------------------------------------------------------------------------
-- Author         : Lukas Vinkx
-- Description: 
-- 
-- 
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
-- LIBRARIES
--------------------------------------------------------------------------------
library ieee;
   use ieee.std_logic_1164.all;
   use ieee.math_real.all;


--------------------------------------------------------------------------------
-- ENTITY
--------------------------------------------------------------------------------
entity TReadyRandomizer is
   generic (
      MinWaitStates : integer := 0;
      MaxWaitStates : integer := 5
   );
   port (
      AClk             : in  std_logic;
      AResetn          : in  std_logic;
      Target_TValid    : in  std_logic;
      Target_TReady    : out std_logic;
      Initiator_TValid : out std_logic;
      Initiator_TReady : in  std_logic;
      Mode             : in  std_logic_vector(3 downto 0)
   );
end TReadyRandomizer;


--------------------------------------------------------------------------------
-- ARCHITECTURE
--------------------------------------------------------------------------------
architecture Behavioral of TReadyRandomizer is
   
   signal Target_TReady_i    : std_logic;
   signal Initiator_TValid_i : std_logic;
   signal Enable             : boolean;

   signal Delayed_TReady     : std_logic;
   signal Delayed_TReady_dly : std_logic;

begin

   Target_TReady    <= Target_TReady_i;
   Initiator_TValid <= Initiator_TValid_i;


   process (AClk, AResetn)
      variable Seed1 : positive := 256;
      variable Seed2 : positive := 145;
      variable Rand  : real;
      subtype t_Count is integer range MinWaitStates to MaxWaitStates;
      variable Count : integer;

   begin

      if AResetn = '0' then
         Delayed_TReady <= '0';
         Count          := 0;
         Enable         <= false;

      elsif rising_edge(AClk) then
         if Target_TValid = '1' and Target_TReady_i = '1' then
            Delayed_TReady <= '0';
         
         elsif Initiator_TValid_i = '1' and Initiator_TReady = '1' then
            Delayed_TReady <= '1';
         end if;

         if Target_TValid = '1' and Target_TReady_i = '1' then
            uniform(Seed1, Seed2, Rand);
            Count := MinWaitStates + integer(Rand*real(MaxWaitStates-MinWaitStates));
         end if;
         
         if Target_TValid = '1' and Initiator_TValid_i = '0' then
            if Count /= 0 then
               Count := Count - 1;
            end if;
         end if;
         
         Enable <= (Count = 0);
      end if;
   end process;

   -- Delay to avoid delta-cycle glitch
   Delayed_TReady_dly <= Delayed_TReady after 1 ns;

   Initiator_TValid_i <= Target_TValid                      when Delayed_TReady_dly = '0' else '0';
   Target_TReady_i    <= Initiator_TReady or Delayed_TReady when Enable else '0';


end Behavioral;
