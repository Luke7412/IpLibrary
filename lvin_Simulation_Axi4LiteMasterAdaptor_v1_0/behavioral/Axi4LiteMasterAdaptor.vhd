--------------------------------------------------------------------------------
-- Project Name   : IpLibrary
-- Design Name    : Axi4LiteMasterAdaptor
-- File Name      : Axi4LiteMasterAdaptor.vhd
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
entity Axi4LiteMasterAdaptor is
   Generic( 
      IntfIndex : natural := 0;
      AddrWidth : natural := 32
   );
   Port ( 
      -- Clock and Reset
      AClk           : in  std_logic;
      AResetn        : in  std_logic;
      -- Axi4Stream Master Interface
      Master_ARValid : out std_logic;
      Master_ARReady : in  std_logic;
      Master_ARAddr  : out std_logic_vector(AddrWidth-1 downto 0);
      Master_ARProt  : out std_logic_vector(2 downto 0);
      Master_RValid  : in  std_logic;
      Master_RReady  : out std_logic;
      Master_RData   : in  std_logic_vector(31 downto 0);
      Master_RResp   : in  std_logic_vector(1 downto 0);
      Master_AWValid : out std_logic;
      Master_AWReady : in  std_logic;
      Master_AWAddr  : out std_logic_vector(AddrWidth-1 downto 0);
      Master_AWProt  : out std_logic_vector(2 downto 0);
      Master_WValid  : out std_logic;
      Master_WReady  : in  std_logic;
      Master_WData   : out std_logic_vector(31 downto 0);
      Master_WStrb   : out std_logic_vector(3 downto 0);
      Master_BValid  : in  std_logic;
      Master_BReady  : out std_logic;
      Master_BResp   : in  std_logic_vector(1 downto 0)
   );
   constant MaxNofIntf : natural := lvin_Simulation_Axi4LiteIntf_v1_0.Axi4LiteIntf_pkg.nofIntfs;
begin
   -- synthesis translate_off
   assert IntfIndex < MaxNofIntf
      report "IntfIndex must be smaller than " & integer'image(MaxNofIntf)
      severity failure;
   -- synthesis translate_on
end entity Axi4LiteMasterAdaptor;


--------------------------------------------------------------------------------
-- ARCHITECTURE
--------------------------------------------------------------------------------
architecture rtl of Axi4LiteMasterAdaptor is
   
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
      Master_ARValid       <= Axi4LiteIntf.ARValid;
      Axi4LiteIntf.ARReady <= Master_ARReady;
      Master_ARAddr        <= Axi4LiteIntf.ARAddr(Master_ARAddr'range);
      Master_ARProt        <= Axi4LiteIntf.ARProt;
      Axi4LiteIntf.RValid  <= Master_RValid;
      Master_RReady        <= Axi4LiteIntf.RReady;
      Axi4LiteIntf.RData   <= Master_RData;
      Axi4LiteIntf.RResp   <= Master_RResp;
      Master_AWValid       <= Axi4LiteIntf.AWValid;
      Axi4LiteIntf.AWReady <= Master_AWReady;
      Master_AWAddr        <= Axi4LiteIntf.AWAddr(Master_AWAddr'range);
      Master_AWProt        <= Axi4LiteIntf.AWProt;
      Master_WValid        <= Axi4LiteIntf.WValid;
      Axi4LiteIntf.WReady  <= Master_WReady;
      Master_WData         <= Axi4LiteIntf.WData;
      Master_WStrb         <= Axi4LiteIntf.WStrb;
      Axi4LiteIntf.BValid  <= Master_BValid;
      Master_BReady        <= Axi4LiteIntf.BReady;
      Axi4LiteIntf.BResp   <= Master_BResp;
   end generate gen_Sim;

   gen_Synth : if not Simulation generate
   begin
      Master_ARValid <= '0';
      Master_ARAddr  <= (others => '0');
      Master_ARProt  <= (others => '0');
      Master_RReady  <= '0';
      Master_AWValid <= '0';
      Master_AWAddr  <= (others => '0');
      Master_AWProt  <= (others => '0');
      Master_WValid  <= '0';
      Master_WData   <= (others => '0');
      Master_WStrb   <= (others => '0');
      Master_BReady  <= '0';
   end generate gen_Synth;

end architecture rtl;
