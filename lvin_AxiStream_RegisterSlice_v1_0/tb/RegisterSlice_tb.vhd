--------------------------------------------------------------------------------
-- Project Name   : IpLibrary
-- Design Name    : RegisterSlice
-- File Name      : RegisterSlice_tb.vhd
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
entity RegisterSlice_tb is
--  Port ( );
end entity RegisterSlice_tb;


--------------------------------------------------------------------------------
-- ARCHITECTURE
--------------------------------------------------------------------------------
architecture Behavioral of RegisterSlice_tb is

   constant g_NumByteLanes : natural := 1;
   constant g_UseTKeep     : natural := 1;
   constant g_UseTStrb     : natural := 1;
   constant g_TUserWidth   : natural := 1;
   constant g_TIdWidth     : natural := 1;
   constant g_TDestWidth   : natural := 1;

   signal AClk    : std_logic;
   signal AResetn : std_logic;
   signal In_TValid, Target_TValid, Initiator_TValid, Out_TValid : std_logic;
   signal In_TReady, Target_TReady, Initiator_TReady, Out_TReady : std_logic;
   signal In_TData , Target_TData , Initiator_TData , Out_TData  : std_logic_vector(8*g_NumByteLanes-1 downto 0);
   signal In_TStrb , Target_TStrb , Initiator_TStrb , Out_TStrb  : std_logic_vector(g_UseTKeep*g_NumByteLanes-1 downto 0);
   signal In_TKeep , Target_TKeep , Initiator_TKeep , Out_TKeep  : std_logic_vector(g_UseTStrb*g_NumByteLanes-1 downto 0);
   signal In_TUser , Target_TUser , Initiator_TUser , Out_TUser  : std_logic_vector(g_TUserWidth-1 downto 0);
   signal In_TId   , Target_TId   , Initiator_TId   , Out_TId    : std_logic_vector(g_TIdWidth-1 downto 0);
   signal In_TDest , Target_TDest , Initiator_TDest , Out_TDest  : std_logic_vector(g_TDestWidth-1 downto 0);
   signal In_TLast , Target_TLast , Initiator_TLast , Out_TLast  : std_logic;

   constant c_PeriodAClk : time    := 5 ns;
   signal ClockEnable    : boolean := False;

   type t_AxisBeat is record
      TData : std_logic_vector(8*g_NumByteLanes-1 downto 0);
      TKeep : std_logic_vector(g_UseTKeep*g_NumByteLanes-1 downto 0);
      TStrb : std_logic_vector(g_UseTStrb*g_NumByteLanes-1 downto 0);
      TUser : std_logic_vector(g_TUserWidth-1 downto 0);
      TId   : std_logic_vector(g_TIdWidth-1 downto 0);
      TDest : std_logic_vector(g_TDestWidth-1 downto 0);
      TLast : std_logic;
   end record t_AxisBeat;

begin

   DUT : entity work.RegisterSlice(rtl)
      Generic map(
         g_NumByteLanes => g_NumByteLanes,
         g_UseTKeep     => g_UseTKeep,
         g_UseTStrb     => g_UseTStrb,         
         g_TUserWidth   => g_TUserWidth,
         g_TIdWidth     => g_TIdWidth,
         g_TDestWidth   => g_TDestWidth
      )
      Port map( 
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
   p_AClk : process
   begin
      AClk <= '0';
      wait until ClockEnable = True;
      while ClockEnable loop
         AClk <= not AClk;
         wait for c_PeriodAClk/2;
      end loop;
      wait;
   end process;


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
         TKeep : std_logic_vector; 
         TStrb : std_logic_vector;
         TUser : std_logic_vector;
         TId   : std_logic_vector;
         TDest : std_logic_vector;
         TLast : std_logic
      ) is
      begin
         In_TValid <= '1';
         In_TData  <= ext(TData, In_TData'length);
         In_TKeep  <= ext(TKeep, In_TKeep'length); 
         In_TStrb  <= ext(TStrb, In_TStrb'length);
         In_TUser  <= ext(TUser, In_TUser'length);
         In_TId    <= ext(TId, In_TId  'length);
         In_TDest  <= ext(TDest, In_TDest'length);
         In_TLast  <= TLast;

         L1 : loop
            wait until rising_edge(AClk);
            if In_TValid = '1' and In_TReady = '1' then
               In_TValid <= '0';
               exit L1;
            end if;
         end loop;
      end procedure;

   begin

      AResetn    <= '0';
      In_TValid  <= '0';
      Out_TReady <= '0';

      wait for 10*c_PeriodAClk;
      ClockEnable <= True;

      WaitTics(10);
      AResetn <= '1';

      WaitTics(10);
      In_TValid  <= '1';
      Out_TReady <= '1';
      --------------------------------------------------------------------------

      SendBeat(x"01", "1", "1", "0", "1", "0", '0');
      SendBeat(x"02", "1", "1", "0", "1", "0", '0');
      SendBeat(x"03", "1", "1", "0", "1", "0", '0');
      SendBeat(x"04", "1", "1", "0", "1", "0", '1');

      --------------------------------------------------------------------------
      WaitTics(10);
      AResetn <= '0';
      WaitTics(10);
      ClockEnable <= False;
      wait for 10*c_PeriodAClk;
      report "Simulation Finished";
      wait;
   end process;

end Behavioral;
