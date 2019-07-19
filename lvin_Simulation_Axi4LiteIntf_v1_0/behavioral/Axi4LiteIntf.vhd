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
      AClk    : std_logic;
      AResetn : std_logic;
      ARValid : std_logic;
      ARReady : std_logic;
      ARAddr  : std_logic_vector(31 downto 0);
      ARProt  : std_logic_vector (2 downto 0);
      RValid  : std_logic;
      RReady  : std_logic;
      RData   : std_logic_vector(31 downto 0);
      RResp   : std_logic_vector(1 downto 0);
      AWValid : std_logic;
      AWReady : std_logic;
      AWAddr  : std_logic_vector(31 downto 0);
      AWProt  : std_logic_vector (2 downto 0);
      WValid  : std_logic;
      WReady  : std_logic;
      WData   : std_logic_vector(31 downto 0);
      WStrb   : std_logic_vector(3 downto 0);
      BValid  : std_logic;
      BReady  : std_logic;
      BResp   : std_logic_vector(1 downto 0);
   end record t_Axi4LiteIntf;

   constant nofIntfs : natural := 16;
   
   type t_Axi4LiteIntfArray is array (0 to nofIntfs-1) of t_Axi4LiteIntf;
   signal Axi4LiteIntfArray : t_Axi4LiteIntfArray;

end package Axi4LiteIntf;


--------------------------------------------------------------------------------
-- PACKAGE BODY
--------------------------------------------------------------------------------
package body Axi4LiteIntf is
end package body Axi4LiteIntf;