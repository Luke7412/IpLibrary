--------------------------------------------------------------------------------
-- Project Name   : IpLibrary
-- Design Name    : Axi4LitePassThroughAdaptor
-- File Name      : Axi4LitePassThroughAdaptor.vhd
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
   use IEEE.STD_LOGIC_ARITH.ALL;

library lvin_Simulation_Axi4LiteIntf_v1_0;
   use lvin_Simulation_Axi4LiteIntf_v1_0.Axi4LiteIntf_pkg.all;

library lvin_simulation_Axi4LiteTransactor_v1_0;
   use lvin_simulation_Axi4LiteTransactor_v1_0.Axi4LiteTransactor_pkg.all;


--------------------------------------------------------------------------------
-- ENTITY
--------------------------------------------------------------------------------
entity Identifier_tb is
end entity Identifier_tb;


--------------------------------------------------------------------------------
-- ARCHITECTURE
--------------------------------------------------------------------------------
architecture tb of Identifier_tb is
  
   signal AClk           : std_logic;
   signal AResetn        : std_logic;
   
   constant c_PeriodAClk : time    := 5 ns;
   signal ClockEnable    : boolean := False;
   
   alias Ctrl : t_Axi4LiteIntf is lvin_Simulation_Axi4LiteIntf_v1_0.Axi4LiteIntf_pkg.Axi4LiteIntfArray(0);

begin

   -----------------------------------------------------------------------------
   -- CLOCK
   -----------------------------------------------------------------------------
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
   -- DUT
   -----------------------------------------------------------------------------
   DUT : entity work.Identifier
   --Generic map(
   --   g_AddressWidth => 32
   --)
   Port map( 
      AClk         => Ctrl.AClk,
      AResetn      => Ctrl.AResetn,
      Ctrl_ARValid => Ctrl.ARValid,
      Ctrl_ARReady => Ctrl.ARReady,
      Ctrl_ARAddr  => Ctrl.ARAddr(7 downto 0),
      Ctrl_RValid  => Ctrl.RValid ,
      Ctrl_RReady  => Ctrl.RReady ,
      Ctrl_RData   => Ctrl.RData  ,
      Ctrl_RResp   => Ctrl.RResp  ,
      Ctrl_AWValid => Ctrl.AWValid,
      Ctrl_AWReady => Ctrl.AWReady,
      Ctrl_AWAddr  => Ctrl.AWAddr(7 downto 0),
      Ctrl_WValid  => Ctrl.WValid ,
      Ctrl_WReady  => Ctrl.WReady ,
      Ctrl_WData   => Ctrl.WData  ,
      Ctrl_WStrb   => Ctrl.WStrb  ,
      Ctrl_BValid  => Ctrl.BValid ,
      Ctrl_BReady  => Ctrl.BReady ,
      Ctrl_BResp   => Ctrl.BResp
   );


   -----------------------------------------------------------------------------
   -- MAIN CTRL
   -----------------------------------------------------------------------------
   process
      variable slv_data : std_logic_vector(31 downto 0);
      variable int_data : integer;

   begin

      AResetn <= '0';
      InitAxi(Ctrl);

      wait for 20*c_PeriodAClk;
      ClockEnable <= True;

      Idle(Ctrl, 20);
      AResetn <= '1';

      Idle(Ctrl, 20);
      --------------------------------------------------------------------------

      for I in 0 to 7 loop
         ReadAxi(Ctrl,  4*I, int_data);
      end loop;

      --------------------------------------------------------------------------
      Idle(Ctrl, 20);
      AResetn <= '0';

      Idle(Ctrl, 20);
      ClockEnable <= False;

      wait for 20*c_PeriodAClk;
      report "Simulation Finished" severity failure;
   end process;

end architecture tb;
