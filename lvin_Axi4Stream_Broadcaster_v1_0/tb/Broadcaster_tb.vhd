--------------------------------------------------------------------------------
-- Project Name   : IpLibrary
-- Design Name    : Broadcaster
-- File Name      : Broadcaster_tb.vhd
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
   use IEEE.NUMERIC_STD.ALL;
   use IEEE.std_logic_arith.all;


--------------------------------------------------------------------------------
-- ENTITY
--------------------------------------------------------------------------------
entity Broadcaster_tb is
end entity Broadcaster_tb;


--------------------------------------------------------------------------------
-- ARCHITECTURE
--------------------------------------------------------------------------------
architecture tb of Broadcaster_tb is

   constant c_NumByteLanes  : natural := 1;
   constant c_UseTKeep      : natural := 1;
   constant c_UseTStrb      : natural := 1;
   constant c_TUserWidth    : natural := 0;
   constant c_TIdWidth      : natural := 0;
   constant c_TDestWidth    : natural := 0;
   constant c_NofInitiators : natural := 2;

   signal AClk             : std_logic;
   signal AResetn          : std_logic;

   signal In_TValid, Target_TValid     : std_logic;
   signal In_TReady, Target_TReady     : std_logic;
   signal In_TData , Target_TData      : std_logic_vector(8*c_NumByteLanes-1 downto 0);
   signal In_TStrb , Target_TStrb      : std_logic_vector(c_UseTKeep*c_NumByteLanes-1 downto 0);
   signal In_TKeep , Target_TKeep      : std_logic_vector(c_UseTStrb*c_NumByteLanes-1 downto 0);
   signal In_TUser , Target_TUser      : std_logic_vector(c_TUserWidth-1 downto 0);
   signal In_TId   , Target_TId        : std_logic_vector(c_TIdWidth-1 downto 0);
   signal In_TDest , Target_TDest      : std_logic_vector(c_TDestWidth-1 downto 0);
   signal In_TLast , Target_TLast      : std_logic;
   signal Out_TValid, Initiator_TValid : std_logic_vector(c_NofInitiators-1 downto 0);
   signal Out_TReady, Initiator_TReady : std_logic_vector(c_NofInitiators-1 downto 0);
   signal Out_TData , Initiator_TData  : std_logic_vector(c_NofInitiators*8*c_NumByteLanes-1 downto 0);
   signal Out_TStrb , Initiator_TStrb  : std_logic_vector(c_NofInitiators*c_UseTKeep*c_NumByteLanes-1 downto 0);
   signal Out_TKeep , Initiator_TKeep  : std_logic_vector(c_NofInitiators*c_UseTStrb*c_NumByteLanes-1 downto 0);
   signal Out_TUser , Initiator_TUser  : std_logic_vector(c_NofInitiators*c_TUserWidth-1 downto 0);
   signal Out_TId   , Initiator_TId    : std_logic_vector(c_NofInitiators*c_TIdWidth-1 downto 0);
   signal Out_TDest , Initiator_TDest  : std_logic_vector(c_NofInitiators*c_TDestWidth-1 downto 0);
   signal Out_TLast , Initiator_TLast  : std_logic_vector(c_NofInitiators-1 downto 0);

   constant c_PeriodAClk : time    := 5 ns;
   signal ClockEnable    : boolean := False;

begin

   -----------------------------------------------------------------------------
   p_AClk : process
   begin
      AClk <= '0';
      wait until ClockEnable = True;
      while ClockEnable loop
         wait for c_PeriodAClk/2;
         AClk <= not AClk;
      end loop;
      wait;
   end process;


   -----------------------------------------------------------------------------
   DUT : entity work.Broadcaster
      Generic map(
         g_NumByteLanes  => c_NumByteLanes,
         g_UseTKeep      => c_UseTKeep,
         g_UseTStrb      => c_UseTStrb,
         g_TUserWidth    => c_TUserWidth,
         g_TIdWidth      => c_TIdWidth,
         g_TDestWidth    => c_TDestWidth,
         g_NofInitiators => c_NofInitiators
      )
      Port map (
         AClk             => AClk,
         AResetn          => AResetn,
         Target_TValid    => Target_TValid,
         Target_TReady    => Target_TReady,
         Target_TData     => Target_TData,
         Target_TStrb     => Target_TStrb,
         Target_TKeep     => Target_TKeep,
         Target_TUser     => Target_TUser,
         Target_TId       => Target_TId,
         Target_TDest     => Target_TDest,
         Target_TLast     => Target_TLast,
         Initiator_TValid => Initiator_TValid,
         Initiator_TReady => Initiator_TReady,
         Initiator_TData  => Initiator_TData,
         Initiator_TStrb  => Initiator_TStrb,
         Initiator_TKeep  => Initiator_TKeep,
         Initiator_TUser  => Initiator_TUser,
         Initiator_TId    => Initiator_TId,
         Initiator_TDest  => Initiator_TDest,
         Initiator_TLast  => Initiator_TLast
      );

   Target_TValid    <= In_TValid;
   In_TReady        <= Target_TReady;
   Target_TData     <= In_TData;
   Target_TStrb     <= In_TStrb;
   Target_TKeep     <= In_TKeep;
   Target_TUser     <= In_TUser;
   Target_TId       <= In_TId;
   Target_TDest     <= In_TDest;
   Target_TLast     <= In_TLast;
   
   Out_TValid       <= Initiator_TValid;
   Initiator_TReady <= Out_TReady;
   Out_TData        <= Initiator_TData;
   Out_TStrb        <= Initiator_TStrb;
   Out_TKeep        <= Initiator_TKeep;
   Out_TUser        <= Initiator_TUser;
   Out_TId          <= Initiator_TId;
   Out_TDest        <= Initiator_TDest;
   Out_TLast        <= Initiator_TLast;


   -----------------------------------------------------------------------------
   process
      procedure WaitTics(
         constant NofTics : natural
      ) is
      begin
         for I in 0 to NofTics-1 loop
            wait until rising_edge(AClk);
         end loop;
      end procedure;

      procedure SendBeat(
         TData : std_logic_vector;
         TLast : std_logic
      ) is
      begin
         In_TValid <= '1';
         In_TData  <= ext(TData, In_TData'length);
         In_TStrb  <= (others => '1');
         In_TKeep  <= (others => '1');
         In_TLast  <= TLast;

         L1 : loop
            wait until rising_edge(AClk);
            if In_TValid = '1' and In_TReady = '1' then
               In_TValid <= '0';
               exit L1;
            end if;
         end loop;
         
         In_TData  <= x"00";
      end procedure;
 
   begin

      AResetn    <= '0';
      In_TValid  <= '0';
      Out_TReady <= (others => '0');

      wait for 10*c_PeriodAClk;
      ClockEnable <= True;

      WaitTics(10);
      AResetn <= '1';

      WaitTics(10);
      In_TValid  <= '1';
      Out_TReady <= (others => '1');
      --------------------------------------------------------------------------

      SendBeat(x"00", '0');
      SendBeat(x"01", '0');
      SendBeat(x"02", '0');
      SendBeat(x"03", '1');

      SendBeat(x"00", '0');
      SendBeat(x"01", '0');
      SendBeat(x"02", '1');

      SendBeat(x"00", '0');
      SendBeat(x"01", '1');

      SendBeat(x"00", '1');

      SendBeat(x"00", '1');

      WaitTics(5);

      SendBeat(x"00", '1');

      WaitTics(5);

      SendBeat(x"00", '0');
      SendBeat(x"01", '0');
      SendBeat(x"02", '0');
      SendBeat(x"03", '1');

      
      --------------------------------------------------------------------------
      WaitTics(10);
      AResetn <= '0';

      WaitTics(10);
      ClockEnable <= False;

      wait for 10*c_PeriodAClk;
      report "Simulation Finished";

      wait;
   end process;
end architecture tb;
