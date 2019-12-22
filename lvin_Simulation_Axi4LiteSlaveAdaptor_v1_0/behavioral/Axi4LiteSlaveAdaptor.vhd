--------------------------------------------------------------------------------
-- Project Name   : IpLibrary
-- Design Name    : Axi4LiteSlaveAdaptor
-- File Name      : Axi4LiteSlaveAdaptor.vhd
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

library lvin_Simulation_Axi4LiteIntf_v1_0;
   use lvin_Simulation_Axi4LiteIntf_v1_0.Axi4LiteIntf_pkg.all;


--------------------------------------------------------------------------------
-- ENTITY
--------------------------------------------------------------------------------
entity Axi4LiteSlaveAdaptor is
   Generic( 
      IntfIndex : natural := 0;
      AddrWidth : natural := 32
   );
   Port ( 
      -- Clock and Reset
      AClk          : in  std_logic;
      AResetn       : in  std_logic;
      -- Axi4Stream Slave Interface
      Slave_ARValid : in  std_logic;
      Slave_ARReady : out std_logic;
      Slave_ARAddr  : in  std_logic_vector(AddrWidth-1 downto 0);
      Slave_ARProt  : in  std_logic_vector(2 downto 0);
      Slave_RValid  : out std_logic;
      Slave_RReady  : in  std_logic;
      Slave_RData   : out std_logic_vector(31 downto 0);
      Slave_RResp   : out std_logic_vector(1 downto 0);
      Slave_AWValid : in  std_logic;
      Slave_AWReady : out std_logic;
      Slave_AWAddr  : in  std_logic_vector(AddrWidth-1 downto 0);
      Slave_AWProt  : in  std_logic_vector(2 downto 0);
      Slave_WValid  : in  std_logic;
      Slave_WReady  : out std_logic;
      Slave_WData   : in  std_logic_vector(31 downto 0);
      Slave_WStrb   : in  std_logic_vector(3 downto 0);
      Slave_BValid  : out std_logic;
      Slave_BReady  : in  std_logic;
      Slave_BResp   : out std_logic_vector(1 downto 0)
   );
   constant MaxNofIntf : natural := lvin_Simulation_Axi4LiteIntf_v1_0.Axi4LiteIntf_pkg.nofIntfs;
begin
   -- synthesis translate_off
   assert IntfIndex < MaxNofIntf
      report "IntfIndex must be smaller than " & integer'image(MaxNofIntf)
      severity failure;
   -- synthesis translate_on
end entity Axi4LiteSlaveAdaptor;


--------------------------------------------------------------------------------
-- ARCHITECTURE
--------------------------------------------------------------------------------
architecture rtl of Axi4LiteSlaveAdaptor is
   
   constant Simulation : boolean := false
                                 -- synthesis translate_off
                                 or true
                                 -- synthesis translate_on
   ;

   alias Axi4LiteIntf : t_Axi4LiteIntf is lvin_Simulation_Axi4LiteIntf_v1_0.Axi4LiteIntf_pkg.Axi4LiteIntfArray(IntfIndex);

begin

   gen_Sim : if Simulation generate
   begin
      Axi4LiteIntf.AClk    <= AClk;
      Axi4LiteIntf.AResetn <= AResetn;
      Axi4LiteIntf.ARValid <= Slave_ARValid;
      Slave_ARReady        <= Axi4LiteIntf.ARReady;
      Axi4LiteIntf.ARAddr  <= Slave_ARAddr;
      Axi4LiteIntf.ARProt  <= Slave_ARProt;
      Slave_RValid         <= Axi4LiteIntf.RValid;
      Axi4LiteIntf.RReady  <= Slave_RReady;
      Slave_RData          <= Axi4LiteIntf.RData(Slave_RData'range);
      Slave_RResp          <= Axi4LiteIntf.RResp(Slave_RResp'range);
      Axi4LiteIntf.AWValid <= Slave_AWValid;
      Slave_AWReady        <= Axi4LiteIntf.AWReady;
      Axi4LiteIntf.AWAddr  <= Slave_AWAddr;
      Axi4LiteIntf.AWProt  <= Slave_AWProt;
      Axi4LiteIntf.WValid  <= Slave_WValid;
      Slave_WReady         <= Axi4LiteIntf.WReady;
      Axi4LiteIntf.WData   <= Slave_WData;
      Axi4LiteIntf.WStrb   <= Slave_WStrb;
      Slave_BValid         <= Axi4LiteIntf.BValid;
      Axi4LiteIntf.BReady  <= Slave_BReady;
      Slave_BResp          <= Axi4LiteIntf.BResp;

   end generate gen_Sim;

   gen_Synth : if not Simulation generate
   begin
      Slave_ARReady <= Axi4LiteIntf.ARReady;
      Slave_RValid  <= Axi4LiteIntf.RValid;
      Slave_RData   <= (others => '0');
      Slave_RResp   <= (others => '0');
      Slave_AWReady <= Axi4LiteIntf.AWReady;
      Slave_WReady  <= Axi4LiteIntf.WReady;
      Slave_BValid  <= Axi4LiteIntf.BValid;
      Slave_BResp   <= Axi4LiteIntf.BResp;
   end generate gen_Synth;

end architecture rtl;
