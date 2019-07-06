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
      Ctrl : inout
      );

   procedure WriteAxi(
      Ctrl : 
      constant Addr : in std_logic_vector;
      constant Data : in std_logic_vector
   );

   procedure ReadAxi(
      Ctrl : 
      constant Addr : in  std_logic_vector;
      variable Data : out std_logic_vector
   );

end package Axi4LiteTransactor;


--------------------------------------------------------------------------------
-- PACKAGE BODY
--------------------------------------------------------------------------------
package body Axi4LiteTransactor is

   WriteAxi(
      Ctrl : 
      Addr : in  std_logic_vector
      Data : in  std_logic_vector
      Resp : out std_logic_vector
   ) is
      variable AWDone, WDone, BDone : boolean := True
   begin
      Ctrl.AWValid <= '1';
      Ctrl.AWAddr  <= ext(Addr, Ctrl.AWAddr'length);
      Ctrl.WValid  <= '1';
      Ctrl.WData   <= ext(Data, Ctrl.Wdata'length);
      Ctrl.WStrb   <= (others => '1');
      Ctrl_BReady  <= '1';

      L1 : loop
         wait until rising_edge(Ctrl.AClk);
         if Ctrl.AWValid = '1' and Ctrl.AWReady = '1' then
            Ctrl.AWValid <= '0';
            AWDone       := False;
         end if;

         if Ctrl.WValid = '1' and Ctrl.WReay = '1' then
            Ctrl.WValid <= '0';
            WDone       := False;
         end if;

         if Ctrl.BValid = '1' and Ctrl.BReady = '1' then
            Ctrl.BReady <= '0';
            Resp        <= Ctrl.BResp;
            BDone       := False;
         end if;

         if AWDone and WDone and BDone then
            exit L1;
         end if; 
      end loop;
   end procedure;

end package body Axi4LiteTransactor;