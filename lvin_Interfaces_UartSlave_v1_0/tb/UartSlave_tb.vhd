--------------------------------------------------------------------------------
-- Project Name   : IpLibrary
-- Design Name    : UartSlave
-- File Name      : UartSlave_tb.vhd
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
entity UartSlave_tb is
--  Port ( );
end entity UartSlave_tb;


--------------------------------------------------------------------------------
-- ARCHITECTURE
--------------------------------------------------------------------------------
architecture Behavioral of UartSlave_tb is

   constant g_NumByteLanes : natural := 1;
   constant g_UseTKeep     : natural := 1;
   constant g_UseTStrb     : natural := 1;
   constant g_TUserWidth   : natural := 1;
   constant g_TIdWidth     : natural := 1;
   constant g_TDestWidth   : natural := 1;

   signal AClk    : std_logic;
   signal AResetn : std_logic;
   signal UART_TX : std_logic;
   signal UART_RX : std_logic;
   signal In_TValid, Target_TValid, Initiator_TValid, Out_TValid : std_logic;
   signal In_TReady, Target_TReady, Initiator_TReady, Out_TReady : std_logic;
   signal In_TData , Target_TData , Initiator_TData , Out_TData  : std_logic_vector(8*g_NumByteLanes-1 downto 0);
   signal In_TKeep , Target_TKeep , Initiator_TKeep , Out_TKeep  : std_logic_vector(g_UseTStrb*g_NumByteLanes-1 downto 0);

   constant c_PeriodAClk : time    := 5 ns;
   signal ClockEnable    : boolean := False;

begin

   Dut : entity work.UartSlave
      Generic map(
         g_AClkFrequency => 200000000,
         g_BaudRate      =>   1000000
      )
      Port map( 
         AClk             => AClk            ,
         AResetn          => AResetn         ,
         UART_TX          => UART_TX         ,
         UART_RX          => UART_RX         ,
         Target_TValid    => Target_TValid   ,
         Target_TReady    => Target_TReady   ,
         Target_TData     => Target_TData    ,
         Target_TKeep     => Target_TKeep    ,
         Initiator_TValid => Initiator_TValid,
         Initiator_TReady => Initiator_TReady,
         Initiator_TData  => Initiator_TData
      );

   UART_RX <= UART_TX;

   Target_TValid    <= In_TValid;
   In_TReady        <= Target_TReady;
   Target_TData     <= In_TData;
   Target_TKeep     <= In_TKeep;

   Out_TValid       <= Initiator_TValid;
   Initiator_TReady <= Out_TReady;
   Out_TData        <= Initiator_TData;
   Out_TKeep        <= Initiator_TKeep;

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
         TKeep : std_logic_vector
      ) is
      begin
         In_TValid <= '1';
         In_TData  <= ext(TData, In_TData'length);
         In_TKeep  <= ext(TKeep, In_TKeep'length); 

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

      SendBeat(x"01", "1");
      SendBeat(x"02", "1");
      SendBeat(x"03", "1");
      SendBeat(x"04", "1");

      --------------------------------------------------------------------------
      wait for 20 us;
      AResetn <= '0';
      WaitTics(10);
      ClockEnable <= False;
      wait for 10*c_PeriodAClk;
      report "Simulation Finished";
      wait;
   end process;

end Behavioral;
