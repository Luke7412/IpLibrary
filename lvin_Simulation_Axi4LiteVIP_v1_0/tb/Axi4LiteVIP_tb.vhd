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

library lvin_Axi4Lite_Regbank_v1_0;


--------------------------------------------------------------------------------
-- ENTITY
--------------------------------------------------------------------------------
entity Axi4LiteVIP_tb is
end entity Axi4LiteVIP_tb;


--------------------------------------------------------------------------------
-- ARCHITECTURE
--------------------------------------------------------------------------------
architecture rtl of Axi4LiteVIP_tb is

   constant AddrWidth : natural := 32;
   
   signal AClk                          : std_logic;
   signal AResetn                       : std_logic;
   
   signal Master_ARValid, Slave_ARValid : std_logic;
   signal Master_ARReady, Slave_ARReady : std_logic;
   signal Master_ARAddr , Slave_ARAddr  : std_logic_vector(AddrWidth-1 downto 0);
   signal Master_ARProt , Slave_ARProt  : std_logic_vector(2 downto 0);
   signal Master_RValid , Slave_RValid  : std_logic;
   signal Master_RReady , Slave_RReady  : std_logic;
   signal Master_RData  , Slave_RData   : std_logic_vector(31 downto 0);
   signal Master_RResp  , Slave_RResp   : std_logic_vector(1 downto 0);
   signal Master_AWValid, Slave_AWValid : std_logic;
   signal Master_AWReady, Slave_AWReady : std_logic;
   signal Master_AWAddr , Slave_AWAddr  : std_logic_vector(AddrWidth-1 downto 0);
   signal Master_AWProt , Slave_AWProt  : std_logic_vector(2 downto 0);
   signal Master_WValid , Slave_WValid  : std_logic;
   signal Master_WReady , Slave_WReady  : std_logic;
   signal Master_WData  , Slave_WData   : std_logic_vector(31 downto 0);
   signal Master_WStrb  , Slave_WStrb   : std_logic_vector(3 downto 0);
   signal Master_BValid , Slave_BValid  : std_logic;
   signal Master_BReady , Slave_BReady  : std_logic;
   signal Master_BResp  , Slave_BResp   : std_logic_vector(1 downto 0);

   constant c_PeriodAClk : time    := 5 ns;
   signal ClockEnable    : boolean := False;

   alias Ctrl0 : t_Axi4LiteIntf is lvin_Simulation_Axi4LiteIntf_v1_0.Axi4LiteIntf_pkg.Axi4LiteIntfArray(0);
   alias Ctrl1 : t_Axi4LiteIntf is lvin_Simulation_Axi4LiteIntf_v1_0.Axi4LiteIntf_pkg.Axi4LiteIntfArray(1);

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

   -----------------------------------------------------------------------------
   -- DUT
   -----------------------------------------------------------------------------
   Master : entity work.Axi4LiteVIP
   Generic map( 
      IntfIndex => 0,
      AddrWidth => AddrWidth,
      Mode      => "Master"
   )
   Port map( 
      -- Clock and Reset
      AClk           => AClk,
      AResetn        => AResetn,
      -- Axi4Stream Master Interface
      Master_ARValid => Slave_ARValid,
      Master_ARReady => Slave_ARReady,
      Master_ARAddr  => Slave_ARAddr,
      Master_ARProt  => Slave_ARProt,
      Master_RValid  => Slave_RValid,
      Master_RReady  => Slave_RReady,
      Master_RData   => Slave_RData,
      Master_RResp   => Slave_RResp,
      Master_AWValid => Slave_AWValid,
      Master_AWReady => Slave_AWReady,
      Master_AWAddr  => Slave_AWAddr,
      Master_AWProt  => Slave_AWProt,
      Master_WValid  => Slave_WValid,
      Master_WReady  => Slave_WReady,
      Master_WData   => Slave_WData,
      Master_WStrb   => Slave_WStrb,
      Master_BValid  => Slave_BValid,
      Master_BReady  => Slave_BReady,
      Master_BResp   => Slave_BResp
   );

   Passthrough : entity work.Axi4LiteVIP
   Generic map( 
      IntfIndex => 1,
      AddrWidth => AddrWidth,
      Mode      => "Passthrough"
   )
   Port map( 
      -- Clock and Reset
      AClk           => AClk,
      AResetn        => AResetn,
      -- Axi4Stream Slave Interface
      Slave_ARValid  => Slave_ARValid,
      Slave_ARReady  => Slave_ARReady,
      Slave_ARAddr   => Slave_ARAddr,
      Slave_ARProt   => Slave_ARProt,
      Slave_RValid   => Slave_RValid,
      Slave_RReady   => Slave_RReady,
      Slave_RData    => Slave_RData,
      Slave_RResp    => Slave_RResp,
      Slave_AWValid  => Slave_AWValid,
      Slave_AWReady  => Slave_AWReady,
      Slave_AWAddr   => Slave_AWAddr,
      Slave_AWProt   => Slave_AWProt,
      Slave_WValid   => Slave_WValid,
      Slave_WReady   => Slave_WReady,
      Slave_WData    => Slave_WData,
      Slave_WStrb    => Slave_WStrb,
      Slave_BValid   => Slave_BValid,
      Slave_BReady   => Slave_BReady,
      Slave_BResp    => Slave_BResp,
      -- Axi4Stream Master Interface
      Master_ARValid => Master_ARValid,
      Master_ARReady => Master_ARReady,
      Master_ARAddr  => Master_ARAddr,
      Master_ARProt  => Master_ARProt,
      Master_RValid  => Master_RValid,
      Master_RReady  => Master_RReady,
      Master_RData   => Master_RData,
      Master_RResp   => Master_RResp,
      Master_AWValid => Master_AWValid,
      Master_AWReady => Master_AWReady,
      Master_AWAddr  => Master_AWAddr,
      Master_AWProt  => Master_AWProt,
      Master_WValid  => Master_WValid,
      Master_WReady  => Master_WReady,
      Master_WData   => Master_WData,
      Master_WStrb   => Master_WStrb,
      Master_BValid  => Master_BValid,
      Master_BReady  => Master_BReady,
      Master_BResp   => Master_BResp
   );

   i_Regbank : entity lvin_Axi4Lite_Regbank_v1_0.Regbank
      Port map( 
         AClk         => AClk        ,
         AResetn      => AResetn     ,
         
         Ctrl_ARValid => Master_ARValid,
         Ctrl_ARReady => Master_ARReady,
         Ctrl_ARAddr  => Master_ARAddr ,
         Ctrl_RValid  => Master_RValid ,
         Ctrl_RReady  => Master_RReady ,
         Ctrl_RData   => Master_RData  ,
         Ctrl_RResp   => Master_RResp  ,
         Ctrl_AWValid => Master_AWValid,
         Ctrl_AWReady => Master_AWReady,
         Ctrl_AWAddr  => Master_AWAddr ,
         Ctrl_WValid  => Master_WValid ,
         Ctrl_WReady  => Master_WReady ,
         Ctrl_WData   => Master_WData  ,
         Ctrl_WStrb   => Master_WStrb  ,
         Ctrl_BValid  => Master_BValid ,
         Ctrl_BReady  => Master_BReady ,
         Ctrl_BResp   => Master_BResp  
      );


   -----------------------------------------------------------------------------
   -- MAIN CTRL
   -----------------------------------------------------------------------------
   process
      variable data : std_logic_vector(31 downto 0);
   begin

      AResetn <= '0';
      InitAxi(Ctrl0);
      InitAxi(Ctrl1);

      wait for 20*c_PeriodAClk;
      ClockEnable <= True;

      Idle(Ctrl0, 20);
      AResetn <= '1';

      Idle(Ctrl0, 20);
      --------------------------------------------------------------------------

      ReadAxi(Ctrl0,  x"00", data);
      ReadAxi(Ctrl0,  x"04", data);
      ReadAxi(Ctrl0,  x"08", data);
      ReadAxi(Ctrl0,  x"0C", data);

      WriteAxi(Ctrl0, x"00", x"BEEF0000");
      WriteAxi(Ctrl0, x"04", x"BEEF0001");
      WriteAxi(Ctrl0, x"08", x"BEEF0002");
      WriteAxi(Ctrl0, x"0C", x"BEEF0003");

      ReadAxi(Ctrl1,  x"10", data);
      ReadAxi(Ctrl1,  x"14", data);
      ReadAxi(Ctrl1,  x"18", data);
      ReadAxi(Ctrl1,  x"1C", data);

      WriteAxi(Ctrl1, x"10", x"BEEF0000");
      WriteAxi(Ctrl1, x"14", x"BEEF0001");
      WriteAxi(Ctrl1, x"18", x"BEEF0002");
      WriteAxi(Ctrl1, x"1C", x"BEEF0003");

      WriteAxi(Ctrl0, x"00", x"BEEFDEAD");
      WriteAxi(Ctrl1, x"10", x"deadbeef");
      WriteAxi(Ctrl0, x"00", x"BEEFDEAD");
      WriteAxi(Ctrl1, x"10", x"deadbeef");

      ReadAxi(Ctrl0, x"00", data);
      ReadAxi(Ctrl1, x"10", data);
      ReadAxi(Ctrl0, x"00", data);
      ReadAxi(Ctrl1, x"10", data);

      WriteAxi(Ctrl0, x"00", x"BEEFDEAD");
      ReadAxi(Ctrl0,  x"00", data);
      WriteAxi(Ctrl1, x"10", x"deadbeef");
      ReadAxi(Ctrl1,  x"10", data);

      WriteAxi(Ctrl1, x"10", x"deadbeef");
      ReadAxi(Ctrl0,  x"00", data);
      WriteAxi(Ctrl0, x"00", x"BEEFDEAD");
      ReadAxi(Ctrl1,  x"10", data);

      --------------------------------------------------------------------------
      Idle(Ctrl0, 20);
      AResetn <= '0';

      Idle(Ctrl0, 20);
      ClockEnable <= False;

      wait for 20*c_PeriodAClk;
      report "Simulation Finished" severity failure;
   end process;

end architecture rtl;
