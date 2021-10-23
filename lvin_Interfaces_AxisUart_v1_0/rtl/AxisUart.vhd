
--------------------------------------------------------------------------------
-- LIBRARIES
--------------------------------------------------------------------------------
library IEEE;
   use IEEE.STD_LOGIC_1164.ALL;


--------------------------------------------------------------------------------
-- ENTITY
--------------------------------------------------------------------------------
entity AxisUart is
   Generic(
      g_AClkFrequency : natural := 200000000;
      g_BaudRate      : natural := 9600;
      g_BaudRateSim   : natural := 50000000
   );
   Port (
      -- Clock and Reset
      AClk          : in  std_logic;
      AResetn       : in  std_logic;
      -- Uart Interface
      Uart_TxD      : out std_logic;
      Uart_RxD      : in  std_logic;
      -- Axi4-Stream TxByte Interface
      TxByte_TValid : in  std_logic;
      TxByte_TReady : out std_logic;
      TxByte_TData  : in  std_logic_vector(7 downto 0) := (others => '0');
      TxByte_TKeep  : in  std_logic_vector(0 downto 0) := (others => '1');
      -- Axi4-Stream RxByte Interface
      RxByte_TValid : out std_logic;
      RxByte_TReady : in  std_logic;
      RxByte_TData  : out std_logic_vector(7 downto 0)
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
         g_BaudRate      => g_BaudRate,
         g_BaudRateSim   => g_BaudRateSim
      )
      Port map( 
         AClk          => AClk,
         AResetn       => AResetn,
         Uart_RxD      => Uart_RxD,
         RxByte_TValid => RxByte_TValid,
         RxByte_TReady => RxByte_TReady,
         RxByte_TData  => RxByte_TData
      );

   UartTx_i : entity work.UartTx
      Generic map(
         g_AClkFrequency => g_AClkFrequency,
         g_BaudRate      => g_BaudRate,
         g_BaudRateSim   => g_BaudRateSim
      )
      Port map( 
         AClk          => AClk,
         AResetn       => AResetn,
         Uart_TxD      => Uart_TxD,
         TxByte_TValid => TxByte_TValid,
         TxByte_TReady => TxByte_TReady,
         TxByte_TData  => TxByte_TData,
         TxByte_TKeep  => TxByte_TKeep 
      );

end architecture rtl;
