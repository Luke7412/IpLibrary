--------------------------------------------------------------------------------
-- Project Name   : IpLibrary
-- Design Name    : Axi4LiteTransactor
-- File Name      : Axi4LiteTransactor.vhd
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
package Axi4LiteTransactor is

   procedure InitAxi(
      intf : inout
      );

   procedure WriteAxi(
      constant Addr : in std_logic_vector;
      constant Data : in std_logic_vector
   );

   procedure ReadAxi(
      constant Addr : in  std_logic_vector;
      variable Data : out std_logic_vector
   );

end package Axi4LiteTransactor;


--------------------------------------------------------------------------------
-- PACKAGE BODY
--------------------------------------------------------------------------------
package body Axi4LiteTransactor is


end package body Axi4LiteTransactor;