--------------------------------------------------------------------------------
-- Project Name   : IpLibrary
-- Design Name    : Framing
-- File Name      : Framing.vhd
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


--------------------------------------------------------------------------------
-- ENTITY
--------------------------------------------------------------------------------
entity Framing is
   Generic(
      g_EscapeByte : std_logic_vector(7 downto 0) := x"00";
      g_StartByte  : std_logic_vector(7 downto 0) := x"01";
      g_StopByte   : std_logic_vector(7 downto 0) := x"02"
   );
   Port (
      -- Clock and Reset
      AClk           : in  std_logic;
      AResetn        : in  std_logic;
      -- Axi4-Stream RxByte Interface
      RxByte_TValid  : in  std_logic;
      RxByte_TReady  : out std_logic;
      RxByte_TData   : in  std_logic_vector(7 downto 0) := (others => '0');
      -- Axi4-Stream RxFrame Interface
      RxFrame_TValid : out std_logic;
      RxFrame_TReady : in  std_logic;
      RxFrame_TData  : out std_logic_vector(7 downto 0);
      RxFrame_TLast  : out std_logic;
      -- Axi4-Stream TxByte Interface
      TxByte_TValid  : out std_logic;
      TxByte_TReady  : in  std_logic;
      TxByte_TData   : out std_logic_vector(7 downto 0);
      -- Axi4-Stream TxFrame Interface
      TxFrame_TValid : in  std_logic;
      TxFrame_TReady : out std_logic;
      TxFrame_TData  : in  std_logic_vector(7 downto 0) := (others => '0');
      TxFrame_TLast  : in  std_logic
   );
end entity Framing;


--------------------------------------------------------------------------------
-- ARCHITECTURE
--------------------------------------------------------------------------------
architecture rtl of Framing is

   signal Escaped_TValid  : std_logic;
   signal Escaped_TReady  : std_logic;
   signal Escaped_TData   : std_logic_vector(7 downto 0);
   signal Escaped_TLast   : std_logic;
   
   signal DeFramed_TValid : std_logic;
   signal DeFramed_TReady : std_logic;
   signal DeFramed_TData  : std_logic_vector(7 downto 0);
   signal DeFramed_TLast  : std_logic;

begin

   i_DeFramer : entity work.DeFramer
      Generic map(
         g_EscapeByte => g_EscapeByte,
         g_StartByte  => g_StartByte,
         g_StopByte   => g_StopByte 
      )
      Port map( 
         AClk             => AClk,
         AResetn          => AResetn,
         Target_TValid    => RxByte_TValid,
         Target_TReady    => RxByte_TReady,
         Target_TData     => RxByte_TData,
         Initiator_TValid => DeFramed_TValid,
         Initiator_TReady => DeFramed_TReady,
         Initiator_TData  => DeFramed_TData,
         Initiator_TLast  => DeFramed_TLast
      );

   i_RemoveEscape : entity work.RemoveEscape
      Generic map(
         g_EscapeByte => g_EscapeByte
      )
      Port map(
         AClk             => AClk,
         AResetn          => AResetn,
         Target_TValid    => DeFramed_TValid,
         Target_TReady    => DeFramed_TReady,
         Target_TData     => DeFramed_TData,
         Target_TLast     => DeFramed_TLast,
         Initiator_TValid => RxFrame_TValid,
         Initiator_TReady => RxFrame_TReady,
         Initiator_TData  => RxFrame_TData,
         Initiator_TLast  => RxFrame_TLast
      );


   -----------------------------------------------------------------------------
   i_InsertEscape : entity work.InsertEscape
      Generic map(
         g_EscapeByte => g_EscapeByte,
         g_StartByte  => g_StartByte,
         g_StopByte   => g_StopByte
      )
      Port map(
         AClk             => AClk,
         AResetn          => AResetn,
         Target_TValid    => TxFrame_TValid,
         Target_TReady    => TxFrame_TReady,
         Target_TData     => TxFrame_TData,
         Target_TLast     => TxFrame_TLast,
         Initiator_TValid => Escaped_TValid,
         Initiator_TReady => Escaped_TReady,
         Initiator_TData  => Escaped_TData,
         Initiator_TLast  => Escaped_TLast
      );

   i_Framer : entity work.Framer
      Generic map(
         g_StartByte => g_StartByte,
         g_StopByte  => g_StopByte
      )
      Port map( 
         AClk             => AClk,
         AResetn          => AResetn,
         Target_TValid    => Escaped_TValid,
         Target_TReady    => Escaped_TReady,
         Target_TData     => Escaped_TData,
         Target_TLast     => Escaped_TLast,
         Initiator_TValid => TxByte_TValid,
         Initiator_TReady => TxByte_TReady,
         Initiator_TData  => TxByte_TData 
      );

end architecture rtl;
