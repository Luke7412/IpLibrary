--------------------------------------------------------------------------------
-- Project Name   : IpLibrary
-- Design Name    : Axi4LiteIntf
-- File Name      : Axi4LiteIntf.vhd
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
-- PACKAGE HEADER
--------------------------------------------------------------------------------
package Axi4LiteIntf is

   type t_Axi4LiteIntf is record
      AClk         : std_logic;
      AResetn      : std_logic;
      Ctrl_ARValid : std_logic;
      Ctrl_ARReady : std_logic;
      Ctrl_ARAddr  : std_logic_vector(31 downto 0);
      Ctrl_RValid  : std_logic;
      Ctrl_RReady  : std_logic;
      Ctrl_RData   : std_logic_vector(31 downto 0);
      Ctrl_RResp   : std_logic_vector(1 downto 0);
      Ctrl_AWValid : std_logic;
      Ctrl_AWReady : std_logic;
      Ctrl_AWAddr  : std_logic_vector(31 downto 0);
      Ctrl_WValid  : std_logic;
      Ctrl_WReady  : std_logic;
      Ctrl_WData   : std_logic_vector(31 downto 0);
      Ctrl_WStrb   : std_logic_vector(3 downto 0);
      Ctrl_BValid  : std_logic;
      Ctrl_BReady  : std_logic;
      Ctrl_BResp   : std_logic_vector(1 downto 0);
   end record t_Axi4LiteIntf;

   constant NofAxi4LiteIntf : natural := 16;
   
   type t_Axi4LiteIntfs is array (integer range <>) of t_Axi4LiteIntf;
   signal Axi4LiteIntfs : t_Axi4LiteIntfs(0 to NofAxi4LiteIntf-1);

end package Axi4LiteIntf;


--------------------------------------------------------------------------------
-- PACKAGE BODY
--------------------------------------------------------------------------------
package body Axi4LiteIntf is
end package body Axi4LiteIntf;