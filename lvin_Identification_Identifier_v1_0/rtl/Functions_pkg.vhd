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
   use IEEE.std_logic_arith.all;


--------------------------------------------------------------------------------
-- PACKAGE HEADER
--------------------------------------------------------------------------------
package Functions_pkg is
   
   function min(L, R: integer) return integer;
   function max(L, R: integer) return integer;

   function ext(x : std_logic_vector; length : integer) return std_logic_vector;
   function ext(x : std_logic; length : natural) return std_logic_vector;
   function ext(x : string; length : natural) return string;

   function to_slv(int : natural; length : natural) return std_logic_vector;
   function to_slv(str : string) return std_logic_vector;

end package;


--------------------------------------------------------------------------------
-- PACKAGE BODY
--------------------------------------------------------------------------------
package body Functions_pkg is

   function max(L, R: integer) return integer is
   begin
      if L > R then
         return L;
      else
         return R;
      end if;
   end function;


   function min(L, R: integer) return integer is
   begin
      if L < R then
         return L;
      else
         return R;
      end if;
   end function;


   function ext(x : std_logic_vector; length : integer) return std_logic_vector is
      variable y : std_logic_vector(length-1 downto 0) := (others => '0');
   begin
      for I in 0 to min(x'length, length)-1 loop
         y(I) := x(I);
      end loop;

      return y;
   end function;


   function ext(x : std_logic; length : natural) return std_logic_vector is
      variable y : std_logic_vector(length-1 downto 0) := (others => '0');
   begin
      y(0) := x;

      return y;
   end function;


   function ext(x : string; length : natural) return string is
      variable y : string(1 to length) := (others => ' ');
   begin
      for I in 1 to min(x'length, length) loop
         y(I) := x(I);
      end loop;
      return y;
   end function;


   function to_slv(int : natural; length : natural) return std_logic_vector is
   begin
      return std_logic_vector(to_unsigned(int, length));
   end function;


    function to_slv(str : string) return std_logic_vector is
        alias str_temp : string(1 to str'length) is str;
        variable slv   : std_logic_vector(8*str'length-1 downto 0);
    begin
        for I in str_temp'range loop
            slv(8*I-1 downto 8*(I-1)) := 
               std_logic_vector(to_unsigned(character'pos(str_temp(I)), 8));
        end loop;
        return slv;
    end function to_slv;




end package body;