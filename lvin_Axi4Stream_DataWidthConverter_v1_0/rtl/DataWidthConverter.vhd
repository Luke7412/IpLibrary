--------------------------------------------------------------------------------
-- Project Name   : IpLibrary
-- Design Name    : DataWidthConverter
-- File Name      : DataWidthConverter.vhd
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
entity DataWidthConverter is
   Generic(
      g_NumByteLanes : natural := 1;
      g_UseTKeep     : natural := 1;
      g_UseTStrb     : natural := 1;
      g_TUserWidth   : natural := 0;
      g_TIdWidth     : natural := 0;
      g_TDestWidth   : natural := 0
   );
   Port ( 
      AClk             : in  std_logic;
      AResetn          : in  std_logic;
      Target_TValid    : in  std_logic;
      Target_TReady    : out std_logic;
      Target_TData     : in  std_logic_vector(8*g_NumByteLanes-1 downto 0)          := (others => '0');
      Target_TStrb     : in  std_logic_vector(g_UseTKeep*g_NumByteLanes-1 downto 0) := (others => '1');
      Target_TKeep     : in  std_logic_vector(g_UseTStrb*g_NumByteLanes-1 downto 0) := (others => '1');
      Target_TUser     : in  std_logic_vector(g_TUserWidth-1 downto 0)              := (others => '0');
      Target_TId       : in  std_logic_vector(g_TIdWidth-1 downto 0)                := (others => '0');
      Target_TDest     : in  std_logic_vector(g_TDestWidth-1 downto 0)              := (others => '0');
      Target_TLast     : in  std_logic                                              := '1';
      Initiator_TValid : out std_logic;
      Initiator_TReady : in  std_logic;
      Initiator_TData  : out std_logic_vector(8*g_NumByteLanes-1 downto 0);
      Initiator_TStrb  : out std_logic_vector(g_UseTKeep*g_NumByteLanes-1 downto 0);
      Initiator_TKeep  : out std_logic_vector(g_UseTStrb*g_NumByteLanes-1 downto 0);
      Initiator_TUser  : out std_logic_vector(g_TUserWidth-1 downto 0);
      Initiator_TId    : out std_logic_vector(g_TIdWidth-1 downto 0);
      Initiator_TDest  : out std_logic_vector(g_TDestWidth-1 downto 0);
      Initiator_TLast  : out std_logic
   );
   begin
      assert g_UseTKeep = 0 or g_UseTKeep = 1
         report "g_UseTKeep Must be 0 or 1."
         severity failure;
      assert g_UseTStrb = 0 or g_UseTStrb = 1
         report "g_UseTStrb Must be 0 or 1."
         severity failure;
end entity DataWidthConverter;


--------------------------------------------------------------------------------
-- ARCHITECTURE
--------------------------------------------------------------------------------
architecture rtl of DataWidthConverter is


begin


end architecture rtl;
