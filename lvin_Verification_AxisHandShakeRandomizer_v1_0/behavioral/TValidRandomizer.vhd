--------------------------------------------------------------------------------
-- Project Name   : IpLibrary
-- Design Name    : AxisHandShakeRandomizer
-- File Name      : TValidRandomizer.vhd
--------------------------------------------------------------------------------
-- Author         : Lukas Vinkx
-- Description: 
-- 
-- 
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
-- LIBRARIES
--------------------------------------------------------------------------------
library IEEE;
   use IEEE.STD_LOGIC_1164.ALL;
   use ieee.math_real.all;


--------------------------------------------------------------------------------
-- ENTITY
--------------------------------------------------------------------------------
entity TValidRandomizer is
   Generic(
      MinWaitStates : integer := 0;
      MaxWaitStates : integer := 5
   );
   Port ( 
      AClk             : in  std_logic;
      AResetn          : in  std_logic;
      Target_TValid    : in  std_logic;
      Target_TReady    : out std_logic;
      Initiator_TValid : out std_logic;
      Initiator_TReady : in  std_logic;
      Mode             : in  std_logic_vector(3 downto 0)
   );
end entity TValidRandomizer;


--------------------------------------------------------------------------------
-- ARCHITECTURE
--------------------------------------------------------------------------------
architecture Behavioral of TValidRandomizer is

   signal Target_TReady_i    : std_logic;
   signal Initiator_TValid_i : std_logic;
   signal Enable             : boolean;

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
         Count  := 0;
         Enable <= false;

      elsif rising_edge(AClk) then
         if Target_TValid = '1' and Target_TReady_i = '1' then
            case Mode is

               when x"0" => -- bypass
                  Count := 0;                  

               when x"1" => -- one every 2 throughput
                  Count := 1;

               when x"2" => -- one every 3 throughput
                  Count := 2;

               when x"3" => -- one every 4 throughput
                  Count := 3;

               when x"4" => -- random
                  uniform(Seed1, Seed2, Rand);
                  Count := MinWaitStates + integer(Rand*real(MaxWaitStates-MinWaitStates));

               when others => 
                  Count := 0;
            end case;
         end if;

         if Target_TValid = '1' and Initiator_TValid_i = '0' then
            if Count /= 0 then
               Count := Count - 1;
            end if;
         end if;
         
         Enable <= (Count = 0);
      end if;
   end process;


  Initiator_TValid_i <= Target_TValid    when Enable else '0';
  Target_TReady_i    <= Initiator_TReady when Enable else '0';

end architecture Behavioral;
