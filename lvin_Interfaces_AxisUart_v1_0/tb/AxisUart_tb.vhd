--------------------------------------------------------------------------------
-- Project Name   : IpLibrary
-- Design Name    : AxisUart
-- File Name      : AxisUart_tb.vhd
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
entity AxisUart_tb is
--  Port ( );
end entity AxisUart_tb;


--------------------------------------------------------------------------------
-- ARCHITECTURE
--------------------------------------------------------------------------------
architecture Behavioral of AxisUart_tb is

   constant g_NumByteLanes : natural := 1;
   constant g_UseTKeep     : natural := 1;
   constant g_UseTStrb     : natural := 1;
   constant g_TUserWidth   : natural := 1;
   constant g_TIdWidth     : natural := 1;
   constant g_TDestWidth   : natural := 1;

   signal AClk     : std_logic;
   signal AResetn  : std_logic;
   signal Uart_Txd : std_logic;
   signal Uart_Rxd : std_logic;
   signal In_TValid, TxByte_TValid, RxByte_TValid, Out_TValid : std_logic;
   signal In_TReady, TxByte_TReady, RxByte_TReady, Out_TReady : std_logic;
   signal In_TData , TxByte_TData , RxByte_TData , Out_TData  : std_logic_vector(8*g_NumByteLanes-1 downto 0);
   signal In_TKeep , TxByte_TKeep                                : std_logic_vector(g_UseTStrb*g_NumByteLanes-1 downto 0);

   constant c_PeriodAClk : time    := 5 ns;
   signal ClockEnable    : boolean := False;

   constant c_AClkFrequency : natural := 200000000;
   constant c_BaudRate      : natural := 9600;
   constant c_BaudRateSim   : natural := 50000000;

   signal Out_Counter : integer;
   signal In_Counter  : integer;

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
   DUT : entity work.AxisUart
      Generic map(
         g_AClkFrequency => c_AClkFrequency,
         g_BaudRate      => c_BaudRate     ,
         g_BaudRateSim   => c_BaudRateSim  
      )
      Port map( 
         AClk          => AClk            ,
         AResetn       => AResetn         ,
         UART_Txd      => Uart_Txd         ,
         UART_Rxd      => Uart_Rxd         ,
         TxByte_TValid => TxByte_TValid   ,
         TxByte_TReady => TxByte_TReady   ,
         TxByte_TData  => TxByte_TData    ,
         TxByte_TKeep  => TxByte_TKeep    ,
         RxByte_TValid => RxByte_TValid,
         RxByte_TReady => RxByte_TReady,
         RxByte_TData  => RxByte_TData
      );

   UART_Rxd <= UART_Txd;

   TxByte_TValid <= In_TValid;
   In_TReady     <= TxByte_TReady;
   TxByte_TData  <= In_TData;
   TxByte_TKeep  <= In_TKeep;
   
   Out_TValid    <= RxByte_TValid;
   RxByte_TReady <= Out_TReady;
   Out_TData     <= RxByte_TData;


   -----------------------------------------------------------------------------
   process(AClk, AResetn) is
   begin
      if AResetn = '0' then
         In_Counter  <= 0;
         Out_Counter <= 0;
         
      elsif rising_edge(AClk) then

         if In_TValid = '1' and In_TReady = '1' and In_TKeep = "1" then
            In_Counter <= In_Counter + 1;
         end if;

         if Out_TValid = '1' and Out_TReady = '1' then
            Out_Counter <= Out_Counter + 1;
         end if;
      end if;
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
         
         In_TData  <= x"00";
         In_TKeep  <= "0";
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
      SendBeat(x"05", "0");
      SendBeat(x"06", "1");
      SendBeat(x"07", "0");
      SendBeat(x"08", "0");
      SendBeat(x"09", "1");

      wait until In_Counter = Out_Counter;


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
