--------------------------------------------------------------------------------
-- Project Name   : IpLibrary
-- Design Name    : Axi4LiteTransactor
-- File Name      : Dummy.vhd
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

library work;
   use work.Axi4LiteTransactor_pkg.all;


--------------------------------------------------------------------------------
-- ENTITY
--------------------------------------------------------------------------------
entity Axi4LiteTransactor_Dummy is
   Port ( 
      Dummy : out std_logic
   );
end entity Axi4LiteTransactor_Dummy;


--------------------------------------------------------------------------------
-- ARCHITECTURE
--------------------------------------------------------------------------------
architecture behavioral of Axi4LiteTransactor_Dummy is
   
begin

   Dummy <= 'Z';

end architecture behavioral;
