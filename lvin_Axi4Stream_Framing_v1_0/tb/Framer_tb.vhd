--------------------------------------------------------------------------------
-- Project Name   : IpLibrary
-- Design Name    : Framing
-- File Name      : Framer_tb.vhd
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
entity Framer_tb is
end entity Framer_tb;


--------------------------------------------------------------------------------
-- ARCHITECTURE
--------------------------------------------------------------------------------
architecture rtl of Framer_tb is

   constant c_StartByte : std_logic_vector(7 downto 0) := x"aa";
   constant c_StopByte  : std_logic_vector(7 downto 0) := x"bb";

   signal AClk             : std_logic;
   signal AResetn          : std_logic;

   signal In_TValid, Target_TValid     : std_logic;
   signal In_TReady, Target_TReady     : std_logic;
   signal In_TData , Target_TData      : std_logic_vector(7 downto 0);
   signal In_TLast , Target_TLast      : std_logic;
   signal Out_TValid, Initiator_TValid : std_logic;
   signal Out_TReady, Initiator_TReady : std_logic;
   signal Out_TData , Initiator_TData  : std_logic_vector(7 downto 0);

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
   DUT : entity work.Framer
      Generic map(
         g_StartByte => c_StartByte,
         g_StopByte  => c_StopByte
      )
      Port map( 
         AClk             => AClk            ,
         AResetn          => AResetn         ,
         
         Target_TValid    => Target_TValid   ,
         Target_TReady    => Target_TReady   ,
         Target_TData     => Target_TData    ,
         Target_TLast     => Target_TLast    ,
         
         Initiator_TValid => Initiator_TValid,
         Initiator_TReady => Initiator_TReady,
         Initiator_TData  => Initiator_TData 
      );

   Target_TValid    <= In_TValid;    
   In_TReady        <= Target_TReady;    
   Target_TData     <= In_TData ;    
   Target_TLast     <= In_TLast ; 

   Out_TValid       <= Initiator_TValid;
   Initiator_TReady <= Out_TReady; 
   Out_TData        <= Initiator_TData;


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
      Out_TReady <= '0';

      wait for 10*c_PeriodAClk;
      ClockEnable <= True;

      WaitTics(10);
      AResetn <= '1';

      WaitTics(10);
      In_TValid  <= '1';
      Out_TReady <= '1';
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

end architecture rtl;
