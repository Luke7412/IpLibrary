
--------------------------------------------------------------------------------
-- LIBRARIES
--------------------------------------------------------------------------------
library IEEE;
   use IEEE.STD_LOGIC_1164.ALL;
   use IEEE.numeric_std.all;

library lvin_Verification_Axi4LiteIntf_v1_0;
   use lvin_Verification_Axi4LiteIntf_v1_0.Axi4LiteIntf_pkg.all;

library lvin_Verification_Axi4LiteTransactor_v1_0;
   use lvin_Verification_Axi4LiteTransactor_v1_0.Axi4LiteTransactor_pkg.all;

library work;
   use work.ModuleId.Id;


--------------------------------------------------------------------------------
-- ENTITY
--------------------------------------------------------------------------------
entity Identifier_tb is
end entity Identifier_tb;


--------------------------------------------------------------------------------
-- ARCHITECTURE
--------------------------------------------------------------------------------
architecture tb of Identifier_tb is
  
   constant c_Name         : string  := "ABCDEFGHIJKLMNOP";
   constant c_MajorVersion : integer := 2;
   constant c_MinorVersion : integer := 8;

   signal AClk           : std_logic;
   signal AResetn        : std_logic;
   
   constant c_PeriodAClk : time    := 5 ns;
   signal ClockEnable    : boolean := False;
   
   alias Ctrl : t_Axi4LiteIntf is lvin_Verification_Axi4LiteIntf_v1_0.Axi4LiteIntf_pkg.Axi4LiteIntfArray(0);

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
      Generic map(
         g_Name         => c_Name ,
         g_MajorVersion => c_MajorVersion,
         g_MinorVersion => c_MinorVersion
      )
      Port map( 
         AClk         => Ctrl.AClk,
         AResetn      => Ctrl.AResetn,
         Ctrl_ARValid => Ctrl.ARValid,
         Ctrl_ARReady => Ctrl.ARReady,
         Ctrl_ARAddr  => Ctrl.ARAddr(7 downto 0),
         Ctrl_RValid  => Ctrl.RValid,
         Ctrl_RReady  => Ctrl.RReady,
         Ctrl_RData   => Ctrl.RData,
         Ctrl_RResp   => Ctrl.RResp
      );


   -----------------------------------------------------------------------------
   -- MAIN CTRL
   -----------------------------------------------------------------------------
   process
      variable slv_data : std_logic_vector(31 downto 0);
      variable int_data : integer;

      constant c_OFFSET_ID      : integer := 16#00#;
      constant c_OFFSET_NAME0   : integer := 16#04#;
      constant c_OFFSET_NAME1   : integer := 16#08#;
      constant c_OFFSET_NAME2   : integer := 16#0C#;
      constant c_OFFSET_NAME3   : integer := 16#10#;
      constant c_OFFSET_VERSION : integer := 16#14#;
   begin

      AResetn <= '0';
      InitAxi(Ctrl);

      wait for 20*c_PeriodAClk;
      ClockEnable <= True;

      Idle(Ctrl, 20);
      AResetn <= '1';

      Idle(Ctrl, 20);
      --------------------------------------------------------------------------

      -- Read Module Id
      ReadAxi(Ctrl,  c_OFFSET_ID, slv_data);
      assert slv_data = Id(31 downto 0) report "Wrong ID" severity error;
 
      -- Read Version
      ReadAxi(Ctrl,  c_OFFSET_VERSION, slv_data);
      assert to_integer(unsigned(slv_data(31 downto 16))) = c_MajorVersion report "Wrong Major Version" severity error;
      assert to_integer(unsigned(slv_data(15 downto  0))) = c_MinorVersion report "Wrong Minor Version" severity error;

      -- Read NAME
      ReadAxi(Ctrl,  c_OFFSET_NAME0, slv_data);
      ReadAxi(Ctrl,  c_OFFSET_NAME1, slv_data);
      ReadAxi(Ctrl,  c_OFFSET_NAME2, slv_data);
      ReadAxi(Ctrl,  c_OFFSET_NAME3, slv_data);


      --------------------------------------------------------------------------
      Idle(Ctrl, 20);
      AResetn <= '0';

      Idle(Ctrl, 20);
      ClockEnable <= False;

      wait for 20*c_PeriodAClk;
      report "Simulation Finished" severity failure;
   end process;

end architecture tb;
