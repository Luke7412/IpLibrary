--------------------------------------------------------------------------------
-- Project Name   : IpLibrary
-- Design Name    : AxisUart
-- File Name      : AxisUart.vhd
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
   use ieee.math_real.all;


--------------------------------------------------------------------------------
-- ENTITY
--------------------------------------------------------------------------------
entity AxisUart is
   Generic(
      g_AClkFrequency : natural := 200000000;
      g_BaudRate      : natural := 9600
   );
   Port ( 
      AClk             : in  std_logic;
      AResetn          : in  std_logic;
      UART_TX          : out std_logic;
      UART_RX          : in  std_logic;
      Target_TValid    : in  std_logic;
      Target_TReady    : out std_logic;
      Target_TData     : in  std_logic_vector(7 downto 0) := (others => '0');
      Target_TKeep     : in  std_logic_vector(0 downto 0) := (others => '1');
      Initiator_TValid : out std_logic;
      Initiator_TReady : in  std_logic;
      Initiator_TData  : out std_logic_vector(7 downto 0)
   );
end entity AxisUart;


--------------------------------------------------------------------------------
-- ARCHITECTURE
--------------------------------------------------------------------------------
architecture rtl of AxisUart is

begin
   
   UartRx_i : entity work.UartRx
      Generic map(
         g_AClkFrequency => g_AClkFrequency,
         g_BaudRate      => g_BaudRate
      )
      Port map( 
         AClk             => AClk,
         AResetn          => AResetn,
         UART_RX          => UART_RX,
         Initiator_TValid => Initiator_TValid,
         Initiator_TReady => Initiator_TReady,
         Initiator_TData  => Initiator_TData
      );

   UartTx_i : entity work.UartTx
      Generic map(
         g_AClkFrequency => g_AClkFrequency,
         g_BaudRate      => g_BaudRate
      )
      Port map( 
         AClk          => AClk,
         AResetn       => AResetn,
         UART_TX       => UART_TX,
         Target_TValid => Target_TValid,
         Target_TReady => Target_TReady,
         Target_TData  => Target_TData,
         Target_TKeep  => Target_TKeep 
      );

end architecture rtl;
