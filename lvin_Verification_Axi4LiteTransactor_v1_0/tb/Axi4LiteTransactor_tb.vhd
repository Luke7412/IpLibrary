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

library lvin_Verification_Axi4LiteIntf_v1_0;
   use lvin_Verification_Axi4LiteIntf_v1_0.Axi4LiteIntf_pkg.all;


--------------------------------------------------------------------------------
-- ENTITY
--------------------------------------------------------------------------------
entity Axi4LiteTransactor_tb is
end entity Axi4LiteTransactor_tb;


--------------------------------------------------------------------------------
-- ARCHITECTURE
--------------------------------------------------------------------------------
architecture tb of Axi4LiteTransactor_tb is
   
   alias Ctrl : t_Axi4LiteIntf is lvin_Verification_Axi4LiteIntf_v1_0.Axi4LiteIntf_pkg.Axi4LiteIntfArray(0);

   signal AClk           : std_logic;
   signal AResetn        : std_logic;

   constant c_PeriodAClk : time    := 5 ns;
   signal ClockEnable    : boolean := False;

begin

   -----------------------------------------------------------------------------
   -- Clocking
   p_AClk : process
   begin
      AClk <= '0';
      wait until ClockEnable = True;
      while ClockEnable loop
         AClk <= not AClk;
         wait for c_PeriodAClk/2;
      end loop;
      wait;
   end process;


   Ctrl.AClk    <= AClk;
   Ctrl.AResetn <= AResetn;


   -----------------------------------------------------------------------------
   -- Main
   process 
   begin
      ClockEnable <= False;
      AResetn     <= '0';
      InitAxi(Ctrl);

      wait for 20*c_PeriodAClk;
      ClockEnable <= True;

      Idle(Ctrl, 20);
      AResetn     <= '1';

      Idle(Ctrl, 20);
      AResetn     <= '0';

      Idle(Ctrl, 20);
      ClockEnable <= False;

      wait for 20*c_PeriodAClk;
      report "The End" severity failure;
   end process;

end architecture tb;
