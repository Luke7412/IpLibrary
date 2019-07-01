-- File Name      : UartRx.vhd
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


--------------------------------------------------------------------------------
-- ENTITY
--------------------------------------------------------------------------------
entity DestPacketizer is
   port (
      -- Clock and reset
      AClk            : in  std_logic;
      AResetn         : in  std_logic;
      -- Axi4-Stream RxFrame interface
      RxFrame_TValid  : in  std_logic;
      RxFrame_TReady  : out std_logic;
      RxFrame_TLast   : in  std_logic;
      RxFrame_TData   : in  std_logic_vector(7 downto 0);
      -- Axi4-Stream TxFrame interface
      TxFrame_TValid  : out std_logic;
      TxFrame_TReady  : in  std_logic;
      TxFrame_TLast   : out std_logic;
      TxFrame_TData   : out std_logic_vector(7 downto 0);
      -- Axi4-Stream RxPacket interface
      RxPacket_TValid : out std_logic;
      RxPacket_TReady : in  std_logic;
      RxPacket_TLast  : out std_logic;
      RxPacket_TData  : out std_logic_vector(7 downto 0);
      RxPacket_TId    : out std_logic_vector(2 downto 0);
      --RxPacket_TKeep  : out std_logic_vector(0 downto 0);
      -- Axi4-Stream TxPacket interface
      TxPacket_TValid : in  std_logic;
      TxPacket_TReady : out std_logic;
      TxPacket_TLast  : in  std_logic;
      TxPacket_TData  : in  std_logic_vector(7 downto 0);
      TxPacket_TId    : in  std_logic_vector(2 downto 0) := (others => '0')
   );
end DestPacketizer;


--------------------------------------------------------------------------------
-- ARCHITECTURE
--------------------------------------------------------------------------------
architecture RTL of DestPacketizer is

begin

   --RxPacket_TKeep <= (others => '1');


   DestExtract_1 : entity work.DestExtract
      port map (
         AClk             => AClk,
         AResetn          => AResetn,
         Target_TValid    => RxFrame_TValid,
         Target_TReady    => RxFrame_TReady,
         Target_TLast     => RxFrame_TLast,
         Target_TData     => RxFrame_TData,
         Initiator_TValid => RxPacket_TValid,
         Initiator_TReady => RxPacket_TReady,
         Initiator_TLast  => RxPacket_TLast,
         Initiator_TData  => RxPacket_TData,
         Initiator_TId    => RxPacket_TId
      );

   DestInsert_1 : entity work.DestInsert
      port map (
         AClk             => AClk,
         AResetn          => AResetn,
         Target_TValid    => TxPacket_TValid,
         Target_TReady    => TxPacket_TReady,
         Target_TLast     => TxPacket_TLast,
         Target_TData     => TxPacket_TData,
         Target_TId       => TxPacket_TId,
         Initiator_TValid => TxFrame_TValid,
         Initiator_TReady => TxFrame_TReady,
         Initiator_TLast  => TxFrame_TLast,
         Initiator_TData  => TxFrame_TData
      );

end RTL;