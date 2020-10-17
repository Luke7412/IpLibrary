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
   use IEEE.numeric_std.all;


--------------------------------------------------------------------------------
-- PACKAGE HEADER
--------------------------------------------------------------------------------
package Functions_pkg is
   
   function ext(x : std_logic_vector; length : integer) return std_logic_vector;
   function ext(x : std_logic; length : integer) return std_logic_vector;

   function smallest(a,b : integer) return integer;

   function to_slv(x: string) return std_logic_vector;

end package;


--------------------------------------------------------------------------------
-- PACKAGE BODY
--------------------------------------------------------------------------------
package body Functions_pkg is
   
   function smallest(a,b : integer) return integer is
   begin
      if a < b then
         return a;
      else
         return b;
      end if;
   end function;

   function ext(x : std_logic_vector; length : integer) return std_logic_vector is
      constant MinLength : integer := smallest(x'length, length);
      variable y : std_logic_vector(length-1 downto 0) := (others => '0');
   begin
      for I in 0 to MinLength-1 loop
         y(I) := x(I);
      end loop;

      return y;
   end function;

   function ext(x : std_logic; length : integer) return std_logic_vector is
      variable y : std_logic_vector(length-1 downto 0) := (others => '0');
   begin
      y(0) := x;

      return y;
   end function;

    function to_slv(x : string)
        return std_logic_vector is
        variable slv : std_logic_vector(x'length*8-1 downto 0);
    begin
        for Index in x'range loop
            slv(Index*8-1 downto (Index-1)*8) := 
               std_logic_vector(to_unsigned(character'pos(x(x'length-Index+1)), 8));
        end loop;
        return slv;
    end function to_slv;

end package body;