--------------------------------------------------------------------------------
-- Project Name   : IpLibrary
-- Design Name    : Identifier
-- File Name      : Identifier.vhd
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


--------------------------------------------------------------------------------
-- PACKAGE HEADER
--------------------------------------------------------------------------------
package ModuleId is
   
   constant Id : std_logic_vector(127 downto 0) := X"07f8bbe2eae35c2276b73ae0a18efd4a";

end package;