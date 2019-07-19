--------------------------------------------------------------------------------
-- Project Name   : IpLibrary
-- Design Name    : DownSizer
-- File Name      : DownSizer.vhd
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
entity DownSizer is
   Generic(
      g_S_AXIS_TDataWidth : natural := 64;
      g_M_AXIS_TDataWidth : natural := 8;
      g_S_AXIS_TUserWidth : natural := 3;
      g_M_AXIS_TUserWidth : natural := 1;
      g_AXIS_TIdWidth     : natural := 1;
      g_AXIS_TDestWidth   : natural := 1
   );
   Port ( 
      AClk          : in  std_logic;
      AResetn       : in  std_logic;
      S_AXIS_TValid : in  std_logic;
      S_AXIS_TReady : out std_logic;
      S_AXIS_TData  : in  std_logic_vector(g_S_AXIS_TDataWidth-1 downto 0)   := (others => '0');
      S_AXIS_TStrb  : in  std_logic_vector(g_S_AXIS_TDataWidth/8-1 downto 0) := (others => '1');
      S_AXIS_TKeep  : in  std_logic_vector(g_S_AXIS_TDataWidth/8-1 downto 0) := (others => '1');
      S_AXIS_TUser  : in  std_logic_vector(g_S_AXIS_TUserWidth-1 downto 0)   := (others => '0');
      S_AXIS_TId    : in  std_logic_vector(g_AXIS_TIdWidth-1 downto 0)       := (others => '0');
      S_AXIS_TDest  : in  std_logic_vector(g_AXIS_TDestWidth-1 downto 0)     := (others => '0');
      S_AXIS_TLast  : in  std_logic                                          := '1';
      M_AXIS_TValid : out std_logic;
      M_AXIS_TReady : in  std_logic;
      M_AXIS_TData  : out std_logic_vector(g_M_AXIS_TDataWidth-1 downto 0); 
      M_AXIS_TStrb  : out std_logic_vector(g_M_AXIS_TDataWidth/8-1 downto 0);
      M_AXIS_TKeep  : out std_logic_vector(g_M_AXIS_TDataWidth/8-1 downto 0);
      M_AXIS_TUser  : out std_logic_vector(g_M_AXIS_TUserWidth-1 downto 0);  
      M_AXIS_TId    : out std_logic_vector(g_AXIS_TIdWidth-1 downto 0);      
      M_AXIS_TDest  : out std_logic_vector(g_AXIS_TDestWidth-1 downto 0);   
      M_AXIS_TLast  : out std_logic
   );
   begin
      assert g_S_AXIS_TDataWidth mod 8 = 0
         report "g_S_AXIS_TDataWidth Must be a multple of 8."
         severity failure;
end entity DownSizer;


--------------------------------------------------------------------------------
-- ARCHITECTURE
--------------------------------------------------------------------------------
architecture rtl of DownSizer is

   signal 

begin

end architecture; -- rtl